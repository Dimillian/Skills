# Testing content-hash dedup (CSV/API import)

When importing records from an external source (CSV, an API sync, a file share extension), re-running the same import must not create duplicates. The usual mechanism is a content hash — e.g. `SHA256(date + amount + payee)` — stored on each record and checked before insert. This file covers the test patterns specific to that mechanism, not general `@ModelActor` testing (see `model-actor-testing.md` for that).

## Pattern: same input twice, one row

```swift
@Test func importingSameFileTwiceIsIdempotent() async throws {
    let container = try makeContainer()
    let actor = TransactionImportActor(modelContainer: container)

    let rows = [TransactionRow(date: fixedDate, amount: 12.50, payee: "Coffee Shop")]

    _ = try await actor.importTransactions(rows)
    let secondSummary = try await actor.importTransactions(rows) // same rows again

    #expect(secondSummary.imported == 0)
    #expect(secondSummary.skippedAsDuplicate == 1)

    let context = ModelContext(container)
    #expect(try context.fetchCount(FetchDescriptor<Transaction>()) == 1)
}
```

## Pattern: hash stability and collision boundaries

The hash function itself deserves direct unit tests, separate from the import pipeline — these don't need SwiftData at all:

```swift
@Test func hashIsStableForIdenticalInput() {
    let a = Transaction.importHash(date: fixedDate, amount: 12.50, payee: "Coffee Shop")
    let b = Transaction.importHash(date: fixedDate, amount: 12.50, payee: "Coffee Shop")
    #expect(a == b)
}

@Test func hashDiffersWhenAnyComponentChanges() {
    let base = Transaction.importHash(date: fixedDate, amount: 12.50, payee: "Coffee Shop")

    #expect(base != Transaction.importHash(date: fixedDate, amount: 12.51, payee: "Coffee Shop"))
    #expect(base != Transaction.importHash(date: fixedDate.addingTimeInterval(1), amount: 12.50, payee: "Coffee Shop"))
    #expect(base != Transaction.importHash(date: fixedDate, amount: 12.50, payee: "Coffee Shop "))  // trailing space
}
```

That last case is the one that actually catches bugs in practice: two rows that a human would call "the same transaction" but that hash differently because the payee string wasn't normalized (whitespace, case, unicode form) before hashing — or two genuinely different transactions that collide because normalization was too aggressive. Pick whichever direction matches the app's intended behavior and assert it explicitly, since it's easy to get backwards.

## Rules

- Use a **fixed** `Date` in dedup tests (`fixedDate` above), not `.now` — two calls to `.now` a few milliseconds apart will produce different hashes and silently defeat the dedup test's own premise.
- Test the hash function directly, without a `ModelContainer`, in addition to testing it through the import pipeline. A hash-stability bug and an import-pipeline bug produce the same visible symptom (duplicate rows) but need different tests to isolate which one broke.
- If the hash includes free-text fields (payee, memo), add at least one test case for the specific normalization the app applies — or its deliberate absence — since that's where real-world duplicate-vs-distinct judgment calls live, not in the hash algorithm itself.
- Assert on the import summary's counts (`imported`, `skippedAsDuplicate`), not just the final row count. A pipeline that silently drops a row for the wrong reason can produce the same row count as one that correctly deduped it — the summary is what distinguishes "worked as intended" from "failed silently."

## Common mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| Using `.now` instead of a fixed `Date` in dedup tests | Test is flaky / passes by accident | Use a fixed `Date` constant |
| Only testing through the full import pipeline | Can't tell whether the hash or the pipeline broke | Add direct unit tests for the hash function |
| Asserting only on final row count | Misses "dropped for the wrong reason" bugs | Assert on the import summary's `imported`/`skipped` breakdown |

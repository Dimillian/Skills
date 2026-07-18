# Testing @ModelActor code

`@ModelActor` types run off the main actor and own their own `ModelContext`. Test code has to respect the same isolation rules as production code — the most common bug this skill catches is a test that "cheats" by reaching into the actor's context directly from the test's actor.

## Pattern: DTOs across the boundary, never `@Model` instances

```swift
@ModelActor
actor TransactionImportActor {
    func importTransactions(_ rows: [TransactionRow]) async throws -> ImportSummary {
        var imported = 0
        for row in rows {
            let transaction = Transaction(date: row.date, amount: row.amount, payee: row.payee)
            modelContext.insert(transaction)
            imported += 1
        }
        try modelContext.save()
        return ImportSummary(imported: imported)
    }
}
```

```swift
@Test func importSkipsDuplicateRows() async throws {
    let container = try makeContainer() // isStoredInMemoryOnly: true
    let actor = TransactionImportActor(modelContainer: container)

    let rows = [TransactionRow(date: .now, amount: 12.50, payee: "Coffee")]
    let summary = try await actor.importTransactions(rows)

    #expect(summary.imported == 1)

    // Assert from a fresh, main-context read — never reach into the actor's
    // own ModelContext from the test.
    let context = ModelContext(container)
    let descriptor = FetchDescriptor<Transaction>()
    #expect(try context.fetch(descriptor).count == 1)
}
```

`TransactionRow` and `ImportSummary` are plain `Sendable` structs — value types cross the actor boundary safely. `Transaction` (a `@Model`) never does.

## Rules

- Construct the `@ModelActor` with a shared `ModelContainer`, not a `ModelContext` — the actor creates its own context internally.
- Never pass a `@Model` instance into or out of a `@ModelActor` method under test. Pass `PersistentIdentifier` or a value-type DTO; re-fetch inside the actor if the model itself is needed there.
- Assert on results either via the actor's own return value (preferred — it's already `Sendable`) or by creating a **separate** `ModelContext` from the same container on the calling side. Do not reach into `actor.modelContext` from a test — that's exactly the cross-actor access the type exists to prevent, and doing it from a test just hides the bug instead of catching it.
- Test methods that call into a `@ModelActor` must be `async` and use `await` at the call site — there is no way to test actor-isolated code synchronously, and forcing it (e.g. wrapping in `Task` and blocking) reintroduces the races the actor was meant to remove.
- If the actor reports progress (`AsyncStream<Double>`, a delegate callback, etc.), test it by collecting emitted values into an array within the test's own task rather than asserting on a single final value — progress-reporting bugs are almost always about intermediate values, not the terminal one.

## Common mistakes

| Mistake | Why it's wrong |
|---|---|
| Reading `actor.modelContext.fetch(...)` directly from a test | Crosses the actor boundary the same way a real bug would — the test can't catch what it also does |
| Passing a `@Model` instance as a method argument | Not `Sendable`; compiles today, becomes a race the moment the actor's internals change |
| Wrapping an actor call in `Task { }` and polling a flag instead of `await`ing it | Reintroduces a timing-dependent test — flaky by construction |

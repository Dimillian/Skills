---
name: swiftdata-testing
description: Writes and reviews SwiftData test code — in-memory ModelContainer fixtures, mock repository patterns, @ModelActor test isolation, Decimal money-value assertions, and content-hash dedup testing. Use when writing or reviewing unit/integration tests for a SwiftData-backed app.
---

# SwiftData Testing

## Overview

Write and review SwiftData test code so it runs in isolation, never touches the device's persistent store, and catches the failure modes specific to `@Model`, `@ModelActor`, and money-typed data. Report only genuine problems — do not nitpick or invent issues.

## Workflow

1. For repository/integration tests, use `references/model-container-fixtures.md` for the in-memory `ModelContainer` setup.
1. For ViewModel unit tests, use `references/mock-repositories.md` — never construct a real `ModelContainer` just to unit test a ViewModel.
1. If the code under test uses `@ModelActor`, use `references/model-actor-testing.md` for actor-isolation-safe test patterns.
1. If the model stores currency/money values, use `references/decimal-money-values.md` — `Decimal` requires different assertion patterns than `Double`.
1. If the code deduplicates records via a content hash (e.g. CSV/API import), use `references/import-hash-dedup.md`.

If doing partial work, load only the relevant reference files.

## Core Instructions

- Target Swift 6.2+ with the `Testing` framework (`@Suite`, `@Test`, `#expect`, `#require`) — not XCTest, for unit and integration tests.
- Every test that touches SwiftData must use `isStoredInMemoryOnly: true`. A test that writes to the real persistent store is not a unit test — it's a device-state mutation with a `#Test` label on it.
- Never share a `ModelContext` or `ModelContainer` instance across tests. Build a fresh one per `@Test` — SwiftData containers are cheap, and cross-test state leakage produces the kind of intermittent failure that looks like flakiness but is actually a fixture bug.
- Domain/business-logic tests should not need a `ModelContainer` at all. If a test imports `SwiftData` just to instantiate a value it never persists or fetches, that's a sign business logic isn't cleanly separated from the persistence layer yet — flag it rather than writing around it.
- Never move a `@Model` instance across an actor boundary — not even in test code. Pass `PersistentIdentifier` or a value-type DTO and re-fetch inside the target actor.

## Output Format

If the user asks for a review, organize findings by file. For each issue:

1. State the file and relevant line(s).
2. Name the rule being violated.
3. Show a brief before/after code fix.

Skip files with no issues. End with a prioritized summary of the most impactful fixes.

If the user asks you to write or fix tests, follow the same rules above but make the changes directly instead of returning a findings report.

## Known Gotcha: `migrationPlan` + `isStoredInMemoryOnly` don't mix

Applying a `SchemaMigrationPlan` to an in-memory-only `ModelConfiguration` causes `save()` to fail — sometimes silently, sometimes non-deterministically depending on device load, which makes it look flaky rather than broken. An in-memory store starts fresh on every launch, so there is nothing to migrate.

```swift
// Before — breaks intermittently under isStoredInMemoryOnly
let container = try ModelContainer(
    for: schema,
    migrationPlan: AppMigrationPlan.self,
    configurations: [config]
)

// After — branch on isStoredInMemoryOnly before applying the migration plan
if config.isStoredInMemoryOnly {
    return try ModelContainer(for: schema, configurations: [config])
}
return try ModelContainer(for: schema, migrationPlan: AppMigrationPlan.self, configurations: [config])
```

This applies to both `@main` app-launch code (for UI test targets) and any test helper that happens to reuse the app's production container builder instead of a dedicated in-memory one.

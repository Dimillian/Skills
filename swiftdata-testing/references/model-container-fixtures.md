# In-memory ModelContainer fixtures

Repository and integration tests need a `ModelContainer` that runs entirely in memory — no writes to the device's real persistent store, no state leaking between tests.

```swift
import Testing
import SwiftData
@testable import YourApp

// Place this at the top of each repository test file.
private func makeContainer() throws -> ModelContainer {
    let schema = Schema([
        Account.self,
        Transaction.self,
        Category.self
        // ...every @Model type reachable from the schema graph
    ])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    return try ModelContainer(for: schema, configurations: [config])
}
```

Use it fresh inside each `@Test`:

```swift
@Suite("SwiftDataAccountRepositoryTests")
struct SwiftDataAccountRepositoryTests {

    @Test func fetchReturnsOnlyMatchingAccount() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let repo = SwiftDataAccountRepository(context: context)

        let account = Account(id: UUID(), name: "Checking", balance: 100)
        context.insert(account)

        let result = try repo.fetch(id: account.id)
        #expect(result?.name == "Checking")
    }
}
```

## Rules

- **Always** `isStoredInMemoryOnly: true` in test configurations.
- **Never** share a `ModelContext` across tests — call `makeContainer()` fresh per `@Test`. A shared container turns test order into a hidden dependency: pass in isolation, fail when run alongside others.
- **List every `@Model` type** reachable from the object graph in the `Schema([...])` array. A model referenced only through a `@Relationship` still needs to be listed explicitly — SwiftData does not walk relationships to infer the schema at `ModelContainer` init time, it throws.
- Domain Service / business-logic tests don't need a `ModelContainer` at all — pass plain Swift values directly and skip the `import SwiftData` entirely.

## Common mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| Sharing a `ModelContext` across `@Test`s | Tests pass alone, fail in the full suite | Fresh `makeContainer()` per test |
| Omitting `isStoredInMemoryOnly: true` | Tests write to and leak state via the device's real store | Always set it in test configs |
| Missing a model in the `Schema` array | `ModelContainer` init throws | List every `@Model` type, including relationship targets |
| Applying a `migrationPlan` to an in-memory config | `save()` fails intermittently | See the "Known Gotcha" in `SKILL.md` |

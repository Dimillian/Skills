# Mock repository pattern for ViewModel tests

A ViewModel test should never construct a real `ModelContainer`. If a ViewModel depends on a repository *protocol*, inject an in-memory mock that conforms to it — the test then runs in microseconds and has zero SwiftData surface area to go wrong.

```swift
protocol AccountRepositoryProtocol {
    func fetchAll() throws -> [Account]
    func fetch(id: UUID) throws -> Account?
    func save(_ account: Account) throws
    func delete(_ account: Account) throws
}

final class MockAccountRepository: AccountRepositoryProtocol {
    var accounts: [Account] = []
    var saveCalled = false
    var deleteCalled = false

    func fetchAll() throws -> [Account] { accounts }

    func fetch(id: UUID) throws -> Account? {
        accounts.first { $0.id == id }
    }

    func save(_ account: Account) throws {
        saveCalled = true
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index] = account
        } else {
            accounts.append(account)
        }
    }

    func delete(_ account: Account) throws {
        deleteCalled = true
        accounts.removeAll { $0.id == account.id }
    }
}
```

```swift
@Test func creatingAccountCallsSave() throws {
    let mock = MockAccountRepository()
    let viewModel = AccountListViewModel(repository: mock)

    try viewModel.addAccount(name: "Savings", balance: 0)

    #expect(mock.saveCalled)
    #expect(mock.accounts.count == 1)
}
```

## Why this matters

If a ViewModel test needs `import SwiftData` at all, that's a signal the ViewModel is depending on a concrete SwiftData type instead of a repository protocol — a layering violation, not a testing inconvenience. Fix the dependency direction rather than working around it with a real container.

## Rules

- ViewModels depend on repository **protocols**, never concrete SwiftData repository implementations — this is what makes the mock substitutable in the first place.
- Give the mock simple recording fields (`saveCalled`, `deleteCalled`, captured arguments) rather than a mocking framework — for a handful of repository methods, hand-written mocks stay more readable than DSL-based ones and don't add a dependency.
- Seed the mock's backing array directly in the test (`mock.accounts = [...]`) instead of round-tripping through `save()` in setup — keeps the arrange step of the test obviously separate from the act step.

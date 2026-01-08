---
name: swift-testing
description: Swift Testing framework (@Test, @Suite, #expect, #require) for Swift 5.9+/Xcode 16+. Use when writing tests, migrating from XCTest, or fixing Swift Testing failures.
---

# Swift Testing

## Overview

Write unit tests using Apple's Swift Testing framework with `@Test`, `@Suite`, `#expect`, and `#require`. Replaces XCTest for non-UI tests.

## Quick reference

| XCTest | Swift Testing |
|--------|---------------|
| `import XCTest` | `import Testing` |
| `class FooTests: XCTestCase` | `@Suite struct FooTests` |
| `func testBar()` | `@Test func bar()` |
| `XCTAssertEqual(a, b)` | `#expect(a == b)` |
| `XCTAssertNil(x)` | `#expect(x == nil)` |
| `XCTAssertThrowsError` | `#expect(throws:)` |
| `XCTUnwrap(x)` | `try #require(x)` |
| `setUpWithError()` | `init() throws` |
| `tearDown()` | `deinit` |

## Workflow

### 1. Set up the test suite

Create a struct with `@Suite` and use `init()` for setup:

```swift
import Testing

@Suite struct UserServiceTests {
    let sut: UserService
    let mockRepo: MockRepository

    init() {
        mockRepo = MockRepository()
        sut = UserService(repository: mockRepo)
    }
}
```

### 2. Write test functions

Add `@Test` to test functions. Remove the `test` prefix:

```swift
@Test func fetchUser_returnsValidUser() async throws {
    let user = try await sut.fetchUser(id: "123")
    #expect(user.name == "John")
}
```

### 3. Use assertions

- `#expect(condition)` — soft assertion, test continues on failure
- `try #require(optional)` — hard assertion, test stops if nil

```swift
#expect(result == expected)
#expect(isValid)
let value = try #require(optional)

#expect(throws: ValidationError.self) {
    try validate(badInput)
}
```

### 4. Add parameterized tests

Run the same test with multiple inputs:

```swift
@Test(arguments: ["", " ", "   "])
func validate_rejectsBlankStrings(_ input: String) {
    #expect(!isValid(input))
}

@Test(arguments: [
    (input: "hello", expected: 5),
    (input: "", expected: 0)
])
func count_returnsCorrectLength(input: String, expected: Int) {
    #expect(input.count == expected)
}
```

### 5. Apply traits for test control

```swift
@Test(.enabled(if: ProcessInfo.processInfo.environment["CI"] != nil))
func onlyOnCI() { }

@Test(.disabled("Waiting for backend fix"))
func brokenEndpoint() { }

@Test(.tags(.slow, .network))
func networkHeavyTest() { }

@Test(.timeLimit(.minutes(1)))
func mustCompleteFast() { }

@Suite(.serialized)
struct DatabaseTests {
    @Test func insert() { }
    @Test func delete() { }
}
```

## Common mistakes

| Mistake | Fix |
|---------|-----|
| `#expect(x == nil)` on `T??` | Use `try #require(x)` first to unwrap outer optional |
| Test not running | Ensure `@Test` attribute is present |
| Shared state between tests | Use `init()` for setup, avoid `static var` |
| Async test not awaited | Mark test `async`, use `await` |
| XCTest assertions in Swift Testing | Replace with `#expect` / `#require` |

## Reference material

- See `references/swift-testing-basics.md` for core concepts and syntax.
- See `references/migration-from-xctest.md` for migration strategies.
- See `references/advanced-patterns.md` for parameterized tests, traits, and mocking.

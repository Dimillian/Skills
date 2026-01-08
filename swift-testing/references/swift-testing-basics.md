# Swift Testing Basics

## Core Components

### @Test

```swift
@Test func userCanLogin() { }
@Test func emptyInput_returnsError() { }
@Test("User can update their profile") func updateProfile() { }
```

**Requirements:**
- Must be a function (not a property or subscript)
- Can be `async` and/or `throws`
- Can be instance method or free function
- No parameters unless using parameterized testing

### @Suite

```swift
@Suite struct AuthenticationTests {
    @Test func login() { }
    @Test func logout() { }
}
```

**Suite features:**
- Can be `struct`, `class`, `actor`, or `enum`
- `struct` recommended (value semantics, fresh instance per test)
- Can nest suites for hierarchy
- Supports traits for suite-wide configuration

### #expect

```swift
#expect(value == 42)
#expect(array.isEmpty)
#expect(string.contains("hello"))
#expect(!isDisabled)
```

Soft assertion—test continues on failure.

**Comparisons:**
```swift
#expect(a == b)
#expect(a != b)
#expect(a > b)
#expect(a === b)
```

**Errors:**
```swift
#expect(throws: (any Error).self) {
    try riskyOperation()
}

#expect(throws: NetworkError.self) {
    try fetch()
}

#expect {
    try validate("")
} throws: { error in
    error as? ValidationError == .empty
}

#expect(throws: Never.self) {
    try safeOperation()
}
```

### #require

Hard assertion—test stops on failure. Use for unwrapping.

```swift
let user = try #require(await fetchUser())
#expect(user.name == "John")

try #require(array.count > 0)
let first = array[0]

let viewModel = try #require(controller.viewModel as? ProfileViewModel)
```

## Lifecycle

```swift
@Suite struct ServiceTests {
    let service: MyService
    let mockRepository: MockRepository

    init() {
        mockRepository = MockRepository()
        service = MyService(repository: mockRepository)
    }

    @Test func fetchData() async { }
}
```

`init()` runs before each test. Each test gets a fresh instance.

### Teardown (class only)

```swift
@Suite class ResourceTests {
    var tempFile: URL?

    init() throws {
        tempFile = try createTempFile()
    }

    deinit {
        if let tempFile {
            try? FileManager.default.removeItem(at: tempFile)
        }
    }
}
```

## Async

```swift
@Test func asyncFetch() async throws {
    let data = try await api.fetchData()
    #expect(data.count > 0)
}
```

```swift
@Test(.timeLimit(.seconds(5)))
func mustCompleteFast() async { }

@Suite(.serialized)
struct OrderDependentTests {
    @Test func first() { }
    @Test func second() { }
}
```

## Running Tests

**Xcode:** Cmd+U (all), click diamond (individual)

**Command line:**
```bash
swift test
swift test --filter UserTests
swift test --filter .tags:slow
swift test --skip .tags:slow
```


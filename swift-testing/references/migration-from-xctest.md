# Migration from XCTest

Both frameworks coexist. Migrate file-by-file. Keep XCTest for UI tests.

## Conversion

```swift
// XCTest
class UserTests: XCTestCase {
    func testUserCreation() { }
    func testUserValidation() { }
}

// Swift Testing
@Suite struct UserTests {
    @Test func creation() { }
    @Test func validation() { }
}
```

### Setup and Teardown

```swift
// XCTest
class ServiceTests: XCTestCase {
    var sut: MyService!
    var mockRepo: MockRepository!

    override func setUpWithError() throws {
        mockRepo = MockRepository()
        sut = MyService(repository: mockRepo)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRepo = nil
    }
}

// Swift Testing
@Suite struct ServiceTests {
    let sut: MyService
    let mockRepo: MockRepository

    init() {
        mockRepo = MockRepository()
        sut = MyService(repository: mockRepo)
    }
}
```

### Assertions

```swift
// XCTest                              // Swift Testing
XCTAssertTrue(condition)               #expect(condition)
XCTAssertFalse(condition)              #expect(!condition)
XCTAssertEqual(a, b)                   #expect(a == b)
XCTAssertNotEqual(a, b)                #expect(a != b)
XCTAssertNil(x)                        #expect(x == nil)
XCTAssertNotNil(x)                     #expect(x != nil)
XCTAssertGreaterThan(a, b)             #expect(a > b)
XCTAssertLessThanOrEqual(a, b)         #expect(a <= b)
XCTAssertIdentical(a, b)               #expect(a === b)
```

### Optional Unwrapping

```swift
// XCTest
func testUnwrap() throws {
    let value = try XCTUnwrap(optional)
    XCTAssertEqual(value.name, "test")
}

// Swift Testing
@Test func unwrap() throws {
    let value = try #require(optional)
    #expect(value.name == "test")
}
```

### Error Testing

```swift
// XCTest
XCTAssertThrowsError(try doSomething())
XCTAssertThrowsError(try validate("")) { error in
    XCTAssertEqual(error as? ValidationError, .empty)
}
XCTAssertNoThrow(try safeThing())

// Swift Testing
#expect(throws: (any Error).self) { try doSomething() }
#expect { try validate("") } throws: { $0 as? ValidationError == .empty }
#expect(throws: Never.self) { try safeThing() }
```

### Async Tests

```swift
// XCTest
func testAsync() async throws {
    let result = try await service.fetch()
    XCTAssertEqual(result.count, 5)
}

// Swift Testing
@Test func async() async throws {
    let result = try await service.fetch()
    #expect(result.count == 5)
}
```

### Skipping Tests

```swift
// XCTest
func testConditional() throws {
    try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] == nil)
    // test code
}

func testSkipUnless() throws {
    try XCTSkipUnless(FeatureFlags.newFeature)
    // test code
}

// Swift Testing
@Test(.enabled(if: ProcessInfo.processInfo.environment["CI"] != nil))
func conditional() { }

@Test(.disabled("Not implemented yet"))
func notReady() { }
```

### Parameterized Tests

```swift
// XCTest
func testMultipleInputs() {
    for input in ["a", "b", "c"] { XCTAssertFalse(input.isEmpty) }
}

// Swift Testing
@Test(arguments: ["a", "b", "c"])
func multipleInputs(_ input: String) { #expect(!input.isEmpty) }
```

## Checklist

1. `import XCTest` → `import Testing`
2. `class FooTests: XCTestCase` → `@Suite struct FooTests`
3. Remove `test` prefix, add `@Test`
4. `setUpWithError()` → `init() throws`
5. Remove `tearDown()`
6. `XCTAssert*` → `#expect` / `#require`
7. `XCTUnwrap` → `try #require`
8. `XCTSkipIf` → `.enabled(if:)` / `.disabled()`

## Pitfalls

```swift
var sut: MyService!              // bad: IUO
let sut: MyService               // good

static var shared: Resource?     // bad: shared state
let resource: Resource           // good: fresh per test

XCTAssertEqual(result!.name, x)  // bad: force unwrap
try #require(result)             // good
```

## Keep in XCTest

- UI tests (XCUITest)
- Performance tests (`measure {}`)
- KIF / other XCTest frameworks


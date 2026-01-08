# Advanced Swift Testing Patterns

## Parameterized Tests

### Single Parameter

```swift
@Test(arguments: ["hello", "world", "swift"])
func stringIsNotEmpty(_ input: String) {
    #expect(!input.isEmpty)
}
```

### Multiple Parameters

```swift
@Test(arguments: [
    (input: "hello", expected: 5),
    (input: "", expected: 0),
    (input: "swift", expected: 5)
])
func stringLength(input: String, expected: Int) {
    #expect(input.count == expected)
}
```

### Cartesian Product

```swift
@Test(arguments: ["a", "b"], [1, 2, 3])
func combination(_ letter: String, _ number: Int) { }
```

### Using Enums

```swift
enum UserRole: CaseIterable {
    case admin, editor, viewer
}

@Test(arguments: UserRole.allCases)
func roleHasPermissions(_ role: UserRole) {
    #expect(role.permissions.isEmpty == false)
}
```

### Custom Arguments

```swift
struct TestCase: CustomTestStringConvertible {
    let input: String
    let expected: Result
    var testDescription: String { "input: \(input)" }
}

@Test(arguments: [
    TestCase(input: "valid@email.com", expected: .success),
    TestCase(input: "invalid", expected: .failure)
])
func emailValidation(_ testCase: TestCase) {
    #expect(validate(testCase.input) == testCase.expected)
}
```

## Traits

### Conditional Execution

```swift
@Test(.enabled(if: FeatureFlags.newAuth))
func newAuthFlow() { }

@Test(.enabled(if: ProcessInfo.processInfo.environment["CI"] != nil))
func ciOnly() { }

@Test(.disabled("Blocked by #123"))
func blockedTest() { }
```

### Bug References

```swift
@Test(.bug("https://github.com/org/repo/issues/456"))
func workaroundForBug() { }

@Test(.bug("JIRA-123", "Flaky on CI"))
func flakyTest() { }
```

### Tags

```swift
extension Tag {
    @Tag static var slow: Self
    @Tag static var network: Self
}

@Test(.tags(.slow, .network))
func largeDownload() async { }

@Suite(.tags(.network))
struct NetworkTests {
    @Test func fetch() { }
}
```

### Time Limits

```swift
@Test(.timeLimit(.seconds(5)))
func mustBeFast() async { }

@Suite(.timeLimit(.seconds(10)))
struct QuickTests {
    @Test func fast1() { }
}
```

### Serial Execution

```swift
@Suite(.serialized)
struct OrderedTests {
    @Test func step1() { }
    @Test func step2() { }
}
```

### Combining Traits

```swift
@Test(
    .enabled(if: ProcessInfo.processInfo.environment["RUN_SLOW"] != nil),
    .tags(.slow, .network),
    .timeLimit(.minutes(5)),
    .bug("https://issues.example.com/999")
)
func expensiveNetworkTest() async { }
```

## Mocking Patterns

### Protocol + Mock

```swift
protocol UserRepository {
    func fetch(id: String) async throws -> User
    func save(_ user: User) async throws
}

final class MockUserRepository: UserRepository {
    var fetchResult: Result<User, Error> = .failure(MockError.notConfigured)
    var savedUsers: [User] = []

    func fetch(id: String) async throws -> User {
        try fetchResult.get()
    }

    func save(_ user: User) async throws {
        savedUsers.append(user)
    }
}

@Suite struct UserServiceTests {
    let mockRepo: MockUserRepository
    let sut: UserService

    init() {
        mockRepo = MockUserRepository()
        sut = UserService(repository: mockRepo)
    }

    @Test func fetchUser_returnsFromRepository() async throws {
        let expected = User(id: "1", name: "Test")
        mockRepo.fetchResult = .success(expected)

        let result = try await sut.getUser(id: "1")

        #expect(result == expected)
    }

    @Test func saveUser_callsRepository() async throws {
        let user = User(id: "1", name: "Test")

        try await sut.save(user)

        #expect(mockRepo.savedUsers.contains(user))
    }
}
```

### Spy Pattern

```swift
actor CallTracker {
    private(set) var calls: [String] = []
    func record(_ method: String) { calls.append(method) }
    func wasCalled(_ method: String) -> Bool { calls.contains(method) }
}

final class SpyAnalytics: AnalyticsService {
    let tracker = CallTracker()
    func track(_ event: String) async { await tracker.record("track:\(event)") }
}

@Test func login_tracksAnalytics() async {
    let spy = SpyAnalytics()
    let sut = LoginService(analytics: spy)
    await sut.login(user: "test", password: "pass")
    #expect(await spy.tracker.wasCalled("track:login_attempt"))
}
```

### Stub Sequences

```swift
actor StubSequence<T> {
    private var values: [T]
    private var index = 0
    init(_ values: [T]) { self.values = values }
    func next() -> T {
        defer { index = min(index + 1, values.count - 1) }
        return values[index]
    }
}

final class MockNetworkClient: NetworkClient {
    var responses: StubSequence<Result<Data, Error>>!
    func fetch(_ url: URL) async throws -> Data { try await responses.next().get() }
}

@Test func retryLogic_succeedsOnThirdAttempt() async throws {
    let mock = MockNetworkClient()
    mock.responses = StubSequence([
        .failure(NetworkError.timeout),
        .failure(NetworkError.timeout),
        .success(Data("ok".utf8))
    ])
    let result = try await sut.fetchWithRetry(url: testURL)
    #expect(result == Data("ok".utf8))
}
```

## Async Testing Patterns

### Testing AsyncSequence

```swift
@Test func streamEmitsValues() async {
    let stream = makeNumberStream()
    var collected: [Int] = []
    for await value in stream.prefix(3) {
        collected.append(value)
    }
    #expect(collected == [1, 2, 3])
}
```

### Polling for Conditions

```swift
@Test func stateEventuallyUpdates() async throws {
    await sut.triggerAsyncUpdate()

    let deadline = ContinuousClock.now + .seconds(1)
    while ContinuousClock.now < deadline {
        if await sut.state == .completed { break }
        try await Task.sleep(for: .milliseconds(10))
    }

    #expect(await sut.state == .completed)
}
```

### Testing Cancellation

```swift
@Test func cancellationStopsWork() async {
    let task = Task { try await sut.longRunningOperation() }
    try await Task.sleep(for: .milliseconds(50))
    task.cancel()

    let result = await task.result
    #expect(throws: CancellationError.self) { try result.get() }
}
```

## Confirmation

```swift
@Test func delegateCalledTwice() async {
    await confirmation(expectedCount: 2) { confirm in
        sut.onProgress = { _ in confirm() }
        await sut.processItems([1, 2])
    }
}
```


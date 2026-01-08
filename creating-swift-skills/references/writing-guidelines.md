# Writing guidelines

## Tone

- Direct and actionable
- Write for experienced developers
- No tutorials or hand-holding
- No emojis

## Structure

**Do:**
- Numbered workflow steps
- Code examples inline
- Tables for comparisons
- Short paragraphs

**Don't:**
- "Introduction" sections
- "When to Use This" preambles
- Lengthy explanations before code
- Theory without examples

## Code examples

Minimal and copy-paste ready:

```swift
// Good - shows the pattern directly
@Test func userCanLogin() async throws {
    let result = try await auth.login(user: "test", pass: "pass")
    #expect(result.isSuccess)
}
```

```swift
// Bad - too much setup noise
import Testing
import Foundation

struct AuthTests {
    let auth = AuthService()

    // This test verifies that a user can successfully log in
    // with valid credentials and receive a success response
    @Test func userCanLogin() async throws {
        // Arrange
        let username = "test"
        let password = "pass"

        // Act
        let result = try await auth.login(user: username, pass: password)

        // Assert
        #expect(result.isSuccess)
    }
}
```

## Descriptions

Frontmatter description format:

```yaml
# Good
description: Fix Swift Concurrency issues with actor isolation and Sendable. Use when compiler warns about data races.

# Bad
description: A comprehensive skill for understanding and resolving Swift Concurrency problems.
```

Include:
- What it does
- When to use (trigger words)

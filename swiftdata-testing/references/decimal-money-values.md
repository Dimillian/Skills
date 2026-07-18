# Testing Decimal money values

Money-typed `@Model` properties should be `Decimal`, never `Double` — binary floating point cannot represent most decimal fractions exactly, and a `Double`-typed balance will eventually drift by a cent under repeated arithmetic. Test code has to respect that same precision, or it'll pass against `Double`-shaped bugs it should be catching.

## Construct Decimal values precisely

```swift
// Prefer literals — Swift parses decimal literals directly into Decimal,
// no binary floating-point round trip.
let price: Decimal = 19.99

// When building from a Double at a boundary (e.g. parsing legacy JSON),
// go through the string initializer, not Decimal(double:) — the latter
// carries over the source Double's imprecision instead of correcting it.
let fromLegacyJSON = Decimal(string: "19.99")!
```

```swift
@Test func splittingTransactionPreservesTotalExactly() throws {
    let total: Decimal = 100.00
    let splits = try splitEvenly(total, into: 3)

    // Decimal division is exact where Double division would drift —
    // asserting exact sum-equality here is the point of the test.
    #expect(splits.reduce(0, +) == total)
}
```

## Rules

- Compare `Decimal` values with `==`, never with an epsilon tolerance. Unlike `Double`, exact equality is the correct comparison — if a test needs a tolerance to pass, that's evidence a `Double` leaked into the calculation somewhere upstream, not a reason to loosen the assertion.
- When a test seeds a model with a money value, use a decimal literal (`50` or `19.99`) directly typed as `Decimal` — don't write `Decimal(50.0)`, which routes through `Double` first and can carry over the wrong value for some literals.
- If a calculation must divide a `Decimal` (e.g. splitting a transaction N ways), test that partial results re-sum to the original total exactly. This is the failure mode `Decimal` is chosen to prevent, so it's the one worth a dedicated test rather than assuming the type guarantees it.
- Test currency *formatting* (`Decimal.formatted(.currency(code:))`) separately from currency *arithmetic*. A locale/formatting bug and a precision bug produce similar-looking symptoms in a UI screenshot but are unrelated and shouldn't share a test.
- If the codebase has a lint or grep-based gate for `Double` in money-typed properties (`CLAUDE.md`-style layer rules are a common place for this), add a test fixture that would fail if a future refactor reintroduces `Double` — a model with an intentionally wrong `Double` property, guarded by `#if compiler` or a comment explaining it exists to prove the gate still fires.

## Common mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| `Decimal(someDouble)` to convert a legacy value | Precision loss carried over from the `Double` | `Decimal(string: String(someDouble))` or fix the source type |
| Epsilon-based comparison (`abs(a - b) < 0.01`) | Masks real off-by-a-cent bugs | Exact `==` — `Decimal` doesn't need tolerance |
| Splitting a `Decimal` total N ways without a re-sum assertion | Rounding-loss bugs ship silently | Assert `splits.reduce(0, +) == total` |

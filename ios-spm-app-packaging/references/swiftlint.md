# SwiftLint integration

Enforces Swift code style. The bootstrap template includes a pre-configured `.swiftlint.yml`.

## Install

```bash
brew install swiftlint
```

## Configuration

The included `.swiftlint.yml` enforces:

- Opt-in rules: `sorted_imports`, `empty_count`, `explicit_init`, `redundant_nil_coalescing`
- Analyzer rules: `explicit_self`, `unused_import`
- Line length: warning at 120, error at 150
- Type/function body limits
- `force_cast`: warning, `force_try`: error

Customize by editing `.swiftlint.yml`.

## Usage

```bash
swiftlint lint
swiftlint lint --strict
swiftlint autocorrect
```

## Xcode integration

Add a Run Script Phase:

```bash
if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed"
fi
```

## Fastlane integration

```ruby
lane :lint do
  swiftlint(mode: :lint, strict: true, reporter: "xcode")
end
```

## CI integration

```yaml
- name: Lint
  run: swiftlint lint --strict
```

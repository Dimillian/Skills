# Fastlane integration (optional)

Fastlane automates signing, building, and uploading to TestFlight/App Store. Use it when you want single-command releases or need automated certificate management.

## Install

**Recommended (with Bundler):**
```bash
# Gemfile is in bootstrap/ template
cd MyApp
bundle install
bundle exec fastlane [lane]
```

Using Bundler locks dependencies, eliminates startup warnings, and makes Fastlane launch faster. Commit `Gemfile` and `Gemfile.lock` to version control.

**Alternative (Homebrew):**
```bash
brew install fastlane
fastlane [lane]
```

## Initialize in project

If starting fresh (not using templates):
```bash
cd MyApp
bundle init
echo 'gem "fastlane"' >> Gemfile
bundle install
bundle exec fastlane init
```

Select option 4 (manual setup) to avoid overwriting existing configuration.

## Signing with match

Tuist defines build settings but doesn't manage certificates. Fastlane's `match` stores signing assets in a private git repo.

**Setup match:**
```bash
fastlane match init
```

**Generate certificates:**
```bash
fastlane match development
fastlane match appstore
```

**Use in Fastfile:**
```ruby
lane :beta do
  match(type: "appstore")
  build_app(scheme: "MyApp", configuration: "Release")
  upload_to_testflight
end
```

## Minimal Fastfile

Wraps existing shell scripts:

```ruby
default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    sh "cd .. && tuist generate"
    sh "cd .. && Scripts/archive.sh"
    sh "cd .. && Scripts/export_ipa.sh"
    sh "cd .. && Scripts/upload_testflight.sh"
  end

  desc "CI build (no signing)"
  lane :ci do
    sh "cd .. && tuist generate"
    sh "cd .. && SKIP_SIGNING=1 Scripts/archive.sh"
  end
end
```

## SwiftLint integration

The included Fastfile has a `lint` lane. See `references/swiftlint.md` for setup.

## Native Fastlane actions

Replace shell scripts with native actions for better error handling:

```ruby
platform :ios do
  lane :beta do
    # Generate project
    sh "cd .. && tuist generate"

    # Build and archive
    build_app(
      scheme: "MyApp",
      configuration: "Release",
      export_method: "app-store"
    )

    # Upload to TestFlight
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end
end
```

## Environment variables

Fastlane reads from `.env` files:

```bash
# fastlane/.env
APP_IDENTIFIER=com.example.myapp
APPLE_ID=your@email.com
TEAM_ID=XXXXXXXXXX
MATCH_GIT_URL=git@github.com:yourorg/certificates.git
```

## CI integration

For GitHub Actions:

```yaml
- name: Install Fastlane
  run: brew install fastlane

- name: Run Fastlane
  env:
    MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
    APP_STORE_CONNECT_API_KEY_ID: ${{ secrets.ASC_KEY_ID }}
    APP_STORE_CONNECT_API_KEY_ISSUER_ID: ${{ secrets.ASC_ISSUER_ID }}
    APP_STORE_CONNECT_API_KEY_CONTENT: ${{ secrets.ASC_KEY_CONTENT }}
  run: fastlane beta
```

## GitHub releases

The included Fastfile has a `release` lane for automated GitHub releases with IPA upload:

```bash
bundle exec fastlane release version:1.2.0
bundle exec fastlane release version:1.2.0 testflight:true
```

Required environment variables: `GITHUB_TOKEN`, `GITHUB_REPOSITORY`.

## When to use Fastlane

| Scenario | Recommendation |
|----------|----------------|
| Solo dev, manual releases | Shell scripts are sufficient |
| Team with shared signing | Use `match` for certificate management |
| CI/CD pipeline | Use Fastlane lanes for reproducibility |
| Frequent TestFlight builds | Fastlane reduces manual steps |
| Automated GitHub releases | Use `release` lane for one-command releases |

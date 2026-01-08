---
name: ios-spm-app-packaging
description: Scaffold, build, and package SwiftPM-based iOS apps using Tuist. Use when you need a from-scratch iOS app layout, SwiftPM dependencies, automated project generation, or signing/archiving/distribution steps outside manual Xcode project management.
---

# iOS SwiftPM App Packaging (Tuist)

## Overview

Bootstrap a SwiftPM-based iOS app using Tuist to generate the Xcode project. Build, archive, and distribute without manually managing xcodeproj files. Tuist uses Swift-based manifests for type-safe configuration with IDE autocomplete.

## Two-Step Workflow

1) Bootstrap the project folder
   - Copy `assets/templates/bootstrap/` into a new repo.
   - Rename `MyApp` in `Package.swift`, `Sources/MyApp/`, and `Project.swift`.
   - Customize `APP_NAME`, `BUNDLE_ID`, and versions in `Project.swift`.

2) Build, archive, and distribute
   - Install Tuist: `brew install --cask tuist`.
   - Generate project: `tuist generate`.
   - Build: `tuist xcodebuild build -scheme MyApp -sdk iphonesimulator`.
   - Archive: `Scripts/archive.sh`.
   - Export IPA: `Scripts/export_ipa.sh`.
   - Upload to TestFlight: `Scripts/upload_testflight.sh`.

## Templates

- `assets/templates/bootstrap/`: Minimal SwiftPM iOS app skeleton with CI configuration, Gemfile, and SwiftLint config.
- `assets/templates/archive.sh`: Create a release archive (supports `SKIP_SIGNING=1`).
- `assets/templates/export_ipa.sh`: Export IPA from archive for distribution.
- `assets/templates/upload_testflight.sh`: Upload IPA to App Store Connect.
- `assets/templates/release.sh`: Complete release workflow (version bump, build, GitHub release, TestFlight).
- `assets/templates/ExportOptions.plist`: Export options for app-store or ad-hoc distribution.
- `assets/templates/fastlane/`: Fastfile and Appfile for optional Fastlane automation.

## Notes

- Tuist regenerates the xcodeproj from `Project.swift`; never edit xcodeproj manually.
- Add `*.xcodeproj` to `.gitignore` since it's generated.
- Provisioning requires Apple Developer account and certificates configured in Keychain.
- For CI without signing, use `SKIP_SIGNING=1 Scripts/archive.sh`.
- Optional: Use `tuist cache warm` for faster builds via caching.

## Signing

Tuist defines build settings but doesn't manage certificates. Options:
- **Manual**: Download certificates/profiles from Apple Developer portal.
- **Automatic**: Let Xcode manage signing (local dev only).
- **Fastlane match**: Automated certificate management via git repo (recommended for teams/CI).

## Reference material

- See `references/scaffold.md` for project setup details.
- See `references/packaging.md` for build and archive configuration.
- See `references/release.md` for TestFlight and App Store distribution.
- See `references/fastlane.md` for optional Fastlane automation and `match` signing.
- See `references/swiftlint.md` for code style enforcement and linting integration.

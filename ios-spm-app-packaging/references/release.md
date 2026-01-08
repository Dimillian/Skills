# Release and distribution notes

## TestFlight upload

Using `xcrun altool` (legacy):
```bash
xcrun altool --upload-app \
  --type ios \
  --file build/export/MyApp.ipa \
  --apiKey $APP_STORE_CONNECT_KEY_ID \
  --apiIssuer $APP_STORE_CONNECT_ISSUER_ID
```

Using `xcrun notarytool` with App Store Connect API:
```bash
xcodebuild -exportArchive \
  -archivePath build/MyApp.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist \
  -allowProvisioningUpdates \
  -authenticationKeyPath $APP_STORE_CONNECT_API_KEY_P8 \
  -authenticationKeyID $APP_STORE_CONNECT_KEY_ID \
  -authenticationKeyIssuerID $APP_STORE_CONNECT_ISSUER_ID
```

## App Store Connect API credentials

Required environment variables:
- `APP_STORE_CONNECT_API_KEY_P8`: Path to .p8 key file
- `APP_STORE_CONNECT_KEY_ID`: Key ID from App Store Connect
- `APP_STORE_CONNECT_ISSUER_ID`: Issuer ID from App Store Connect

Generate API key at: App Store Connect > Users and Access > Keys

## Version management

Update in `Project.swift`:
```swift
settings: .settings(base: [
    "MARKETING_VERSION": "1.2.0",        // User-facing version
    "CURRENT_PROJECT_VERSION": "42"      // Build number (must increment)
])
```

Regenerate project after changes:
```bash
tuist generate
```

## Tag and GitHub release

```bash
VERSION="1.2.0"
git tag "v$VERSION"
git push origin "v$VERSION"

gh release create "v$VERSION" \
  --title "MyApp $VERSION" \
  --generate-notes \
  build/export/MyApp.ipa
```

Release notes options: `--notes-file CHANGELOG.md`, `--generate-notes`, or `--notes "text"`.

**Automated:** Use `Scripts/release.sh 1.2.0` for the complete workflow (version bump, build, GitHub release, TestFlight).

## Ad-hoc distribution

For internal testing without TestFlight:

1) Create ad-hoc provisioning profile in Apple Developer portal
2) Use `ExportOptions.plist` with `method: ad-hoc`
3) Distribute IPA via MDM, web link, or direct install

## Fastlane releases (optional)

Single-command release with Fastlane:

```bash
# Gemfile is in bootstrap/, copy fastlane/ for lanes:
mkdir -p fastlane
cp assets/templates/fastlane/* fastlane/
bundle install
bundle exec fastlane beta
```

Minimal Fastfile for TestFlight:
```ruby
lane :beta do
  build_app(scheme: "MyApp", configuration: "Release")
  upload_to_testflight(skip_waiting_for_build_processing: true)
end
```

See `references/fastlane.md` for full setup including `match` for automated signing.

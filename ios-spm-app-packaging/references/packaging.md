# Packaging notes

## Build commands

Generate project with Tuist:
```bash
tuist generate
```

Build with tuist xcodebuild wrapper:
```bash
# Simulator build
tuist xcodebuild build -scheme MyApp -sdk iphonesimulator -configuration Debug

# Device build (requires signing)
tuist xcodebuild build -scheme MyApp -sdk iphoneos -configuration Release
```

## Archive for distribution

```bash
tuist generate
tuist xcodebuild archive \
  -scheme MyApp \
  -sdk iphoneos \
  -configuration Release \
  -archivePath build/MyApp.xcarchive
```

## Export IPA

Create `ExportOptions.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>destination</key>
    <string>upload</string>
</dict>
</plist>
```

Export:
```bash
xcodebuild -exportArchive \
  -archivePath build/MyApp.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist
```

## Common environment variables

- `APP_NAME`: App/target name.
- `BUNDLE_ID`: Bundle identifier.
- `TEAM_ID`: Apple Developer Team ID.
- `SCHEME`: Xcode scheme name.
- `CONFIGURATION`: `Debug`, `Release`, or `CI`.
- `SKIP_SIGNING`: Set to `1` to use CI configuration (no code signing).

## Signing modes

| Method | Use Case |
|--------|----------|
| Automatic | Local dev with Xcode managing profiles |
| Manual | CI with exported provisioning profiles |
| Ad-hoc | Internal testing outside TestFlight |
| App Store | TestFlight and App Store distribution |

## CI / no-signing environments

Archive commands fail without valid signing certificates. The project includes a `CI` configuration and `MyApp-CI` scheme for testing the archive pipeline without signing.

**Why archive fails without certs:**
- `xcodebuild archive` requires code signing even for test builds
- CI environments often lack provisioning profiles

**Use the CI configuration:**
```bash
# Archive without signing (uses CI config)
SKIP_SIGNING=1 Scripts/archive.sh

# Or manually:
tuist xcodebuild archive \
  -scheme MyApp-CI \
  -sdk iphoneos \
  -configuration CI \
  -archivePath build/MyApp.xcarchive
```

**For real distribution** (requires Apple Developer account):
```bash
tuist generate
tuist xcodebuild archive \
  -scheme MyApp \
  -sdk iphoneos \
  -configuration Release \
  -allowProvisioningUpdates
```

## Tuist caching (optional)

Speed up builds by caching dependencies:
```bash
tuist cache warm
tuist generate
tuist xcodebuild build
```

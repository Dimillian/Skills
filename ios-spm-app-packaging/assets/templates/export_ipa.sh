#!/bin/bash
set -euo pipefail

# Export IPA from archive
# Usage: ./export_ipa.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

APP_NAME="${APP_NAME:-MyApp}"
BUILD_DIR="${BUILD_DIR:-build}"
EXPORT_OPTIONS="${EXPORT_OPTIONS:-ExportOptions.plist}"

if [ ! -f "$EXPORT_OPTIONS" ]; then
  echo "Creating default ExportOptions.plist for App Store..."
  cat > "$EXPORT_OPTIONS" << 'EOF'
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
EOF
fi

echo "Exporting IPA..."
xcodebuild -exportArchive \
  -archivePath "$BUILD_DIR/$APP_NAME.xcarchive" \
  -exportPath "$BUILD_DIR/export" \
  -exportOptionsPlist "$EXPORT_OPTIONS" \
  -allowProvisioningUpdates

echo "IPA exported to: $BUILD_DIR/export/"

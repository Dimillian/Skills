#!/bin/bash
set -euo pipefail

# Archive iOS app for distribution
# Usage: ./archive.sh
#
# Environment variables:
#   SKIP_SIGNING=1  - Use CI configuration (no code signing)
#   APP_NAME        - App name (default: MyApp)
#   SCHEME          - Xcode scheme (default: APP_NAME or APP_NAME-CI if SKIP_SIGNING)
#   CONFIGURATION   - Build configuration (default: Release or CI if SKIP_SIGNING)
#   BUILD_DIR       - Output directory (default: build)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

APP_NAME="${APP_NAME:-MyApp}"
BUILD_DIR="${BUILD_DIR:-build}"

# Use CI config/scheme when SKIP_SIGNING is set
if [ "${SKIP_SIGNING:-0}" = "1" ]; then
  CONFIGURATION="${CONFIGURATION:-CI}"
  SCHEME="${SCHEME:-$APP_NAME-CI}"
  echo "Running in CI mode (no code signing)..."
else
  CONFIGURATION="${CONFIGURATION:-Release}"
  SCHEME="${SCHEME:-$APP_NAME}"
fi

echo "Regenerating Xcode project..."
tuist generate

echo "Archiving $APP_NAME (scheme: $SCHEME, config: $CONFIGURATION)..."
tuist xcodebuild archive \
  -scheme "$SCHEME" \
  -sdk iphoneos \
  -configuration "$CONFIGURATION" \
  -archivePath "$BUILD_DIR/$APP_NAME.xcarchive" \
  -allowProvisioningUpdates

echo "Archive created: $BUILD_DIR/$APP_NAME.xcarchive"

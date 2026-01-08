#!/bin/bash
set -euo pipefail

# Upload IPA to TestFlight via App Store Connect API
# Usage: ./upload_testflight.sh
#
# Required environment variables:
#   APP_STORE_CONNECT_API_KEY_P8  - Path to .p8 API key file
#   APP_STORE_CONNECT_KEY_ID      - API Key ID
#   APP_STORE_CONNECT_ISSUER_ID   - Issuer ID

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

APP_NAME="${APP_NAME:-MyApp}"
BUILD_DIR="${BUILD_DIR:-build}"

# Validate required env vars
: "${APP_STORE_CONNECT_API_KEY_P8:?Set APP_STORE_CONNECT_API_KEY_P8}"
: "${APP_STORE_CONNECT_KEY_ID:?Set APP_STORE_CONNECT_KEY_ID}"
: "${APP_STORE_CONNECT_ISSUER_ID:?Set APP_STORE_CONNECT_ISSUER_ID}"

IPA_PATH=$(find "$BUILD_DIR/export" -name "*.ipa" | head -1)

if [ -z "$IPA_PATH" ]; then
  echo "Error: No IPA found in $BUILD_DIR/export/"
  exit 1
fi

echo "Uploading $IPA_PATH to TestFlight..."
xcrun altool --upload-app \
  --type ios \
  --file "$IPA_PATH" \
  --apiKey "$APP_STORE_CONNECT_KEY_ID" \
  --apiIssuer "$APP_STORE_CONNECT_ISSUER_ID"

echo "Upload complete!"

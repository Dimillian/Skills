#!/bin/bash
set -euo pipefail

# Usage: ./Scripts/release.sh 1.2.0 [--skip-testflight] [--skip-github]

VERSION="${1:-}"
SKIP_TESTFLIGHT=false
SKIP_GITHUB=false

shift || true
for arg in "$@"; do
  case $arg in
    --skip-testflight) SKIP_TESTFLIGHT=true ;;
    --skip-github) SKIP_GITHUB=true ;;
  esac
done

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version> [--skip-testflight] [--skip-github]"
  exit 1
fi

APP_NAME=$(grep -o 'name: "[^"]*"' Project.swift | head -1 | sed 's/name: "\(.*\)"/\1/')
BUILD_DIR="build"
IPA_PATH="$BUILD_DIR/export/$APP_NAME.ipa"

echo "Releasing $APP_NAME $VERSION..."

# Update version
sed -i '' "s/\"MARKETING_VERSION\": \"[^\"]*\"/\"MARKETING_VERSION\": \"$VERSION\"/" Project.swift

# Build
tuist generate
./Scripts/archive.sh
./Scripts/export_ipa.sh

# Commit
git add Project.swift
git diff --cached --quiet || git commit -m "Bump version to $VERSION" && git push

# GitHub release
if [ "$SKIP_GITHUB" = false ]; then
  git tag "v$VERSION"
  git push origin "v$VERSION"
  if [ -f "CHANGELOG.md" ]; then
    gh release create "v$VERSION" --title "$APP_NAME $VERSION" --notes-file CHANGELOG.md "$IPA_PATH"
  else
    gh release create "v$VERSION" --title "$APP_NAME $VERSION" --generate-notes "$IPA_PATH"
  fi
fi

# TestFlight
if [ "$SKIP_TESTFLIGHT" = false ]; then
  ./Scripts/upload_testflight.sh
fi

echo "Release $VERSION complete."

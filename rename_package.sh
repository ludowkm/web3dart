#!/bin/bash

# Usage: ./rename_package.sh old_name new_name

set -e

OLD_NAME=$1
NEW_NAME=$2

if [[ -z "$OLD_NAME" || -z "$NEW_NAME" ]]; then
  echo "❌ Usage: $0 <old_name> <new_name>"
  exit 1
fi

echo "🔄 Renaming package from '$OLD_NAME' to '$NEW_NAME'..."

# 1. Update pubspec.yaml
echo "📦 Updating pubspec.yaml..."
sed -i '' "s/^name: $OLD_NAME/name: $NEW_NAME/" pubspec.yaml

# 2. Replace imports in Dart files
echo "🔍 Updating imports in .dart files..."
find . -type f -name "*.dart" -print0 | xargs -0 sed -i '' "s/package:$OLD_NAME\//package:$NEW_NAME\//g"

echo "✅ Done! Don't forget to run 'flutter pub get'."
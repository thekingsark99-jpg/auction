#!/bin/bash

PLIST_PATH="ios/Runner/Info.plist"
PLIST_BUDDY=/usr/libexec/PlistBuddy

# Check if Info.plist exists before modifying
if [ ! -f "$PLIST_PATH" ]; then
    echo "⚠️ Info.plist not found. Skipping cleanup."
    exit 0
fi

# Check if CFBundleURLTypes exists before attempting to delete
if $PLIST_BUDDY -c "Print :CFBundleURLTypes" "$PLIST_PATH" &>/dev/null; then
    echo "🗑️ Removing CFBundleURLTypes from Info.plist..."
    $PLIST_BUDDY -c "Delete :CFBundleURLTypes" "$PLIST_PATH" 2>/dev/null
    echo "✅ CFBundleURLTypes removed successfully."
else
    echo "⚠️ CFBundleURLTypes not found in Info.plist. No changes needed."
fi

echo "🚀 Info.plist cleanup complete!"

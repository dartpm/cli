#!/bin/bash

export DART_ENV='production'

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Define the new publish_to value
NEW_PUBLISH_TO="https://dartpm.com"

# Path to the pubspec.yaml file
PUBSPEC_FILE="$SCRIPT_DIR/../pubspec.yaml"

# Check if the publish_to field exists
if grep -q "publish_to" "$PUBSPEC_FILE"; then
  # Update the publish_to field if it exists
  sed -i.bak "s|publish_to:.*|publish_to: $NEW_PUBLISH_TO|" "$PUBSPEC_FILE"
  echo "Updated publish_to to $NEW_PUBLISH_TO in $PUBSPEC_FILE"
else
  # If publish_to doesn't exist, append it to the file
  echo "publish_to: $NEW_PUBLISH_TO" >> "$PUBSPEC_FILE"
  echo "Added publish_to to $PUBSPEC_FILE"
fi

dart pub publish -C "$SCRIPT_DIR/.."  --force 
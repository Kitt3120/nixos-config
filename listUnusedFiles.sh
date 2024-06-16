#!/usr/bin/env bash

# List all .nix files that are not referenced in any other .nix file

ALL_NIX_FILES=$(find . -name "*.nix" | sort)
ALL_CONTENTS=$(cat $ALL_NIX_FILES)

UNUSED_FILES=()
for FILE in $ALL_NIX_FILES; do
    BASENAME=$(basename $FILE)
    if ! echo "$ALL_CONTENTS" | grep -q "$BASENAME"; then
        UNUSED_FILES+=("$FILE")
    fi
done

echo "Unused files:"
for FILE in "${UNUSED_FILES[@]}"; do
    echo "$FILE"
done

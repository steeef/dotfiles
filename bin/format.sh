#!/usr/bin/env bash

# Format files with appropriate formatters

# Usage: Called by Claude Code PostToolUse hook
# Receives JSON via stdin with tool operation details

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required but not found. Please install jq to use format.sh" >&2
  exit 1
fi

# Read JSON from stdin and extract file path
JSON=$(cat)
FILE_PATH=$(echo "$JSON" | jq -r '.tool_input.file_path')

# Fix end-of-file newline (only for text files)
if file "$FILE_PATH" 2>/dev/null | grep -q "text"; then
  # Add newline at end of file if missing
  if [ -s "$FILE_PATH" ] && [ "$(tail -c 1 "$FILE_PATH" | wc -l)" -eq 0 ]; then
    echo >>"$FILE_PATH"
  fi

  # Remove trailing whitespace (safe for most files)
  case "$FILE_PATH" in
  *.patch | *.diff)
    # Skip patch files where whitespace might be significant
    ;;
  *)
    # Remove trailing whitespace
    sed -i 's/[ \t]*$//' "$FILE_PATH" 2>/dev/null || true
    ;;
  esac
fi

#!/usr/bin/env bash
# Bootstraps a writable Vale config from this skill's bundled vale.ini,
# then runs vale against whatever paths are passed in.
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/vale-check"
CONFIG="$CONFIG_DIR/.vale.ini"

mkdir -p "$CONFIG_DIR"
if [ ! -f "$CONFIG" ]; then
  cp "$SKILL_DIR/vale.ini" "$CONFIG"
fi

if [ ! -d "$CONFIG_DIR/styles/write-good" ] || [ ! -d "$CONFIG_DIR/styles/Google" ]; then
  vale sync --config "$CONFIG"
fi

# Findings are advisory, never a gate.
vale --config "$CONFIG" --output=line "$@" || true

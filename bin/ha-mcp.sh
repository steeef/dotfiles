#!/usr/bin/env bash
set -euo pipefail

export HOMEASSISTANT_TOKEN
HOMEASSISTANT_TOKEN="$(security find-generic-password -a "$USER" -s "ha-mcp-token" -w)"
export HOMEASSISTANT_URL="https://ha.steeef.net"

exec uvx --python 3.13 ha-mcp@latest

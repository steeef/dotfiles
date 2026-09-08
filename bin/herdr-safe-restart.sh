#!/usr/bin/env bash
# Restart herdr after a brew upgrade without silently killing live panes.
set -euo pipefail

if [ "${HERDR_ENV:-}" = "1" ]; then
  echo "ERROR: refusing to run from inside a herdr-managed pane." >&2
  echo "Run this from a plain terminal window instead." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required." >&2
  exit 1
fi

status_json="$(herdr status --json)"
restart_needed="$(jq -r '.server.restart_needed' <<<"$status_json")"

if [ "$restart_needed" != "true" ]; then
  echo "herdr server already up to date, nothing to do."
  herdr status
  exit 0
fi

echo "Update available:"
jq -r '"  client: \(.client.version) (protocol \(.client.protocol))\n  server: \(.server.version) (protocol \(.server.protocol))"' <<<"$status_json"

echo "Live sessions:"
herdr session list
echo "Restarting will exit every pane's process (agents, shells, servers)."

read -r -p "Restart herdr now? [y/N] " reply
case "$reply" in
  [yY]*) ;;
  *)
    echo "Aborted."
    exit 1
    ;;
esac

brew services restart herdr

ok=false
for _ in $(seq 1 15); do
  sleep 1
  status_json="$(herdr status --json 2>/dev/null || echo '{}')"
  if [ "$(jq -r '.server.compatible' <<<"$status_json")" = "true" ] &&
    [ "$(jq -r '.server.restart_needed' <<<"$status_json")" = "false" ]; then
    ok=true
    break
  fi
done

herdr status

if [ "$ok" != "true" ]; then
  echo "WARNING: herdr did not come back up compatible/clean." >&2
  exit 1
fi

echo "herdr restarted and compatible."

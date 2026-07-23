#!/bin/bash
set -eu

action="${1:-}"
hook_input_file="$(mktemp "${TMPDIR:-/tmp}/herdr-ticket-rename.XXXXXX")" || exit 0
trap 'rm -f "$hook_input_file"' EXIT HUP INT TERM
cat >"$hook_input_file" 2>/dev/null || true

case "$action" in
  session|prompt) ;;
  *) exit 0 ;;
esac

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

snapshot="$(herdr api snapshot 2>/dev/null)" || exit 0
[ -n "$snapshot" ] || exit 0

workspace_id="$(printf '%s' "$snapshot" | jq -r --arg pane "$HERDR_PANE_ID" \
  '.result.snapshot.agents[]? | select(.pane_id == $pane) | .workspace_id // empty')"
[ -n "$workspace_id" ] || exit 0

candidate=""
case "$action" in
  session)
    cwd="$(jq -r '.cwd // empty' "$hook_input_file" 2>/dev/null || true)"
    [ -n "$cwd" ] || exit 0
    candidate="$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
    ;;
  prompt)
    candidate="$(jq -r '.prompt // empty' "$hook_input_file" 2>/dev/null || true)"
    ;;
esac
[ -n "$candidate" ] || exit 0

ticket="$(printf '%s' "$candidate" \
  | grep -oE '\b[A-Za-z]{2,4}-[0-9]{1,5}\b' | head -1 | tr '[:lower:]' '[:upper:]')"
[ -n "$ticket" ] || exit 0

current_label="$(printf '%s' "$snapshot" | jq -r --arg ws "$workspace_id" \
  '.result.snapshot.workspaces[]? | select(.workspace_id == $ws) | .label // empty')"
[ "$current_label" = "$ticket" ] && exit 0

herdr workspace rename "$workspace_id" "$ticket" >/dev/null 2>&1 || true

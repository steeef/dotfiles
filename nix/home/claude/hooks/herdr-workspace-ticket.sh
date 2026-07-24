#!/bin/bash
set -eu

action="${1:-}"
hook_input="$(cat)"

case "$action" in
  session | prompt) ;;
  *) exit 0 ;;
esac

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

snapshot="$(herdr api snapshot 2>/dev/null)" || exit 0
[ -n "$snapshot" ] || exit 0

IFS=$'\t' read -r workspace_id workspace_cwd <<EOF
$(printf '%s' "$snapshot" | jq -r --arg pane "$HERDR_PANE_ID" \
  '.result.snapshot.agents[]? | select(.pane_id == $pane) | [(.workspace_id // ""), (.cwd // "")] | @tsv')
EOF
[ -n "$workspace_id" ] || exit 0

candidate=""
case "$action" in
  session)
    cwd="$(printf '%s' "$hook_input" | jq -r '.cwd // empty' 2>/dev/null || true)"
    [ -n "$cwd" ] || exit 0
    candidate="$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
    ;;
  prompt)
    candidate="$(printf '%s' "$hook_input" | jq -r '.prompt // empty' 2>/dev/null || true)"
    ;;
esac
[ -n "$candidate" ] || exit 0

ticket="$(printf '%s' "$candidate" |
  grep -oE '\b[A-Za-z]{2,4}-[0-9]{2,5}\b' | head -1 | tr '[:lower:]' '[:upper:]')"
[ -n "$ticket" ] || exit 0

current_label="$(printf '%s' "$snapshot" | jq -r --arg ws "$workspace_id" \
  '.result.snapshot.workspaces[]? | select(.workspace_id == $ws) | .label // empty')"

[ -n "$workspace_cwd" ] || exit 0
original_label="$(basename "$workspace_cwd")"

if [ "$current_label" != "$original_label" ]; then
  case "$action:$current_label" in
    session:[A-Za-z][A-Za-z]-[0-9]*) ;;
    *) exit 0 ;;
  esac
fi

[ "$current_label" = "$ticket" ] && exit 0

herdr workspace rename "$workspace_id" "$ticket" >/dev/null 2>&1 || true

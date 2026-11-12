#!/bin/bash
set -eu

cat >/dev/null

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

snapshot="$(herdr api snapshot 2>/dev/null)" || exit 0
[ -n "$snapshot" ] || exit 0

workspace_id="$(printf '%s' "$snapshot" | jq -r --arg pane "$HERDR_PANE_ID" \
  '.result.snapshot.panes[]? | select(.pane_id == $pane) | .workspace_id // empty' | head -1)"
[ -n "$workspace_id" ] || exit 0

label="$(printf '%s' "$snapshot" | jq -r --arg ws "$workspace_id" \
  '.result.snapshot.workspaces[]? | select(.workspace_id == $ws) | .label // empty')" || exit 0

key="$(printf '%s' "$label" |
  grep -oE '(^|[^A-Za-z0-9])[A-Za-z]{2,4}-[0-9]{2,5}($|[^A-Za-z0-9])' | head -1 |
  grep -oE '[A-Za-z]{2,4}-[0-9]{2,5}' | tr '[:lower:]' '[:upper:]' || true)"
[ -n "$key" ] || exit 0

jq -n --arg key "$key" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: ("This herdr workspace is named for Jira ticket " + $key + ". Before anything else, call AskUserQuestion once: \"Use this session to continue work on " + $key + "?\" Options: (1) Yes, resume it: then invoke Skill checkpoint in resume mode for " + $key + ". (2) No, unrelated work: proceed normally and do not mention the ticket again. If the user already gave a task in their first message, still ask first.")
  }
}'

#!/bin/bash
set -eu

hook_input="$(cat)"

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

prompt="$(printf '%s' "$hook_input" | jq -r '.prompt // empty' 2>/dev/null || true)"
[ -n "$prompt" ] || exit 0

# Only the session's first user prompt may set the name. Whether
# UserPromptSubmit fires before or after this prompt lands in
# transcript_path isn't guaranteed, so compare against the transcript's
# earliest recorded user entry instead of counting turns: a match (or no
# user entries yet) means this is turn #1; anything else means it's later.
transcript_path="$(printf '%s' "$hook_input" | jq -r '.transcript_path // empty' 2>/dev/null || true)"
first_prompt="$(jq -rs '
  ([.[] | select(.type=="user")] | .[0].message.content) as $c
  | if ($c | type) == "string" then $c else "" end
' "$transcript_path" 2>/dev/null || true)"
[ -z "$first_prompt" ] || [ "$first_prompt" = "$prompt" ] || exit 0

ticket="$(printf '%s' "$prompt" |
  grep -oE '\b[A-Za-z]{2,4}-[0-9]{2,5}\b' | head -1 | tr '[:lower:]' '[:upper:]')"
[ -n "$ticket" ] || exit 0

snapshot="$(herdr api snapshot 2>/dev/null)" || exit 0
[ -n "$snapshot" ] || exit 0

workspace_id="$(printf '%s' "$snapshot" | jq -r --arg pane "$HERDR_PANE_ID" \
  '.result.snapshot.agents[]? | select(.pane_id == $pane) | .workspace_id // empty' | head -1)"
[ -n "$workspace_id" ] || exit 0

current_label="$(printf '%s' "$snapshot" | jq -r --arg ws "$workspace_id" \
  '.result.snapshot.workspaces[]? | select(.workspace_id == $ws) | .label // empty')"
[ "$current_label" = "$ticket" ] && exit 0

herdr workspace rename "$workspace_id" "$ticket" >/dev/null 2>&1 || true

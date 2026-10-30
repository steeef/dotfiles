#!/bin/bash
set -eu

hook_input="$(cat)"

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

event="$(printf '%s' "$hook_input" | jq -r '.hook_event_name // empty' 2>/dev/null || true)"
if [ "$event" = "UserPromptSubmit" ]; then
  prompt="$(printf '%s' "$hook_input" | jq -r '.prompt // empty' 2>/dev/null || true)"
  [ -n "$prompt" ] || exit 0
fi

# PostToolUse cwd may predate the switch; prefer the worktree path in the result
cwd="$(printf '%s' "$hook_input" | jq -r '
  if .hook_event_name == "PostToolUse"
  then ([.tool_response | tostring | scan("/[^\" ]*/wt/[^/\" ]+/[^/\" ]+")] | .[0]) // .cwd // empty
  else .cwd // empty end' 2>/dev/null || true)"
[ -n "$cwd" ] || exit 0

# ~/wt/<repo>/<worktree>[/sub] -> worktree name; else the cwd's basename
case "$cwd" in
  "$HOME"/wt/*/*)
    rest="${cwd#"$HOME"/wt/*/}"
    name="${rest%%/*}"
    ;;
  *) name="$(basename "$cwd")" ;;
esac
[ -n "$name" ] || exit 0

# KEY-123-some-long-slug -> KEY-123 some-long
if [[ "$name" =~ ^([A-Za-z]{2,4}-[0-9]{2,5})(-(.*))?$ ]]; then
  key="$(printf '%s' "${BASH_REMATCH[1]}" | tr '[:lower:]' '[:upper:]')"
  slug="$(printf '%s' "${BASH_REMATCH[3]}" | cut -d- -f1-2)"
  name="${key}${slug:+ $slug}"
fi

# plan commands name the ticket worked on
plan_key="$(printf '%s' "${prompt:-}" |
  grep -E '^/(do-plan|mk-plan)([[:space:]]|$)' |
  grep -oE '[A-Za-z]{2,4}-[0-9]{2,5}' | head -1 | tr '[:lower:]' '[:upper:]' || true)"
if [ -n "$plan_key" ] && [[ "$name" != "$plan_key"* ]]; then
  name="$plan_key"
fi

snapshot="$(herdr api snapshot 2>/dev/null)" || exit 0
[ -n "$snapshot" ] || exit 0

workspace_id="$(printf '%s' "$snapshot" | jq -r --arg pane "$HERDR_PANE_ID" \
  '.result.snapshot.agents[]? | select(.pane_id == $pane) | .workspace_id // empty' | head -1)"
[ -n "$workspace_id" ] || exit 0

current_label="$(printf '%s' "$snapshot" | jq -r --arg ws "$workspace_id" \
  '.result.snapshot.workspaces[]? | select(.workspace_id == $ws) | .label // empty')"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/herdr-workspace-name"
state_file="$state_dir/$workspace_id"
mkdir -p "$state_dir"
# keep ticket label over cwd name
key_re='^[A-Za-z]{2,4}-[0-9]{2,5}( |$)'
if [[ "$current_label" =~ $key_re ]] && ! [[ "$name" =~ $key_re ]]; then
  exit 0
fi
if [ "$current_label" = "$name" ]; then
  printf '%s' "$name" >"$state_file"
  exit 0
fi

# a label we didn't set means a manual rename; leave it alone
if [ -f "$state_file" ] && [ "$current_label" != "$(cat "$state_file")" ]; then
  exit 0
fi

herdr workspace rename "$workspace_id" "$name" >/dev/null 2>&1 || exit 0
printf '%s' "$name" >"$state_file"

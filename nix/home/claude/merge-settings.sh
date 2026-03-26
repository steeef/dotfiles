#!/usr/bin/env bash
set -euo pipefail

# Three-way merge for Claude Code settings.
#
# Nix base settings are merged into the mutable settings.json on every `hms`.
# If a key existed in the previous Nix base but was removed from the current
# one, it is stripped from the mutable file first. This ensures `hms` can
# both add AND remove settings.
#
# Usage: merge-settings.sh <jq-path> <base> <prev> <target>

jq="$1"
base="$2"
prev="$3"
target="$4"

# Transition: remove symlink from previous Nix management
if [ -L "$target" ]; then
  rm "$target"
fi

if [ -f "$target" ]; then
  # Strip keys that were in previous Nix base but removed from current
  if [ -f "$prev" ]; then
    # shellcheck disable=SC2016 # jq expressions use $ for variables, not shell
    "$jq" --slurpfile prev "$prev" --slurpfile base "$base" '
      def remove_stale($old; $new):
        if (type == "object") and ($old | type == "object") and ($new | type == "object") then
          [to_entries[] | .key as $k |
            if ($old | has($k)) and ($new | has($k) | not) then empty
            elif (.value | type == "object") and ($old | has($k)) and ($old[$k] | type == "object")
                 and ($new | has($k)) and ($new[$k] | type == "object") then
              {key: $k, value: (.value | remove_stale($old[$k]; $new[$k]))}
            else .
            end
          ] | from_entries
        else .
        end;
      remove_stale($prev[0]; $base[0])
    ' "$target" >"$target.tmp"
    mv "$target.tmp" "$target"
  fi

  # Deep merge: existing + Nix base (Nix wins for scalar conflicts)
  "$jq" -s '.[0] * .[1]' "$target" "$base" >"$target.tmp"
  mv "$target.tmp" "$target"
else
  # No existing settings — copy base as mutable file
  cp "$base" "$target"
  chmod 644 "$target"
fi

# Snapshot current Nix base for next run's stale-key detection
rm -f "$prev"
cp "$base" "$prev"

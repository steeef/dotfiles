#!/usr/bin/env bash
# Usage: sync_ticket_thoughts.sh <dir-in-thoughts-repo> <TICKET> <message>
set -euo pipefail

cd "$(git -C "$1" rev-parse --show-toplevel)"

# boundaries keep ABC-1 from matching ABC-10
mapfile -t files < <(
  git ls-files --modified --others --exclude-standard |
    grep -E "(^|[^A-Za-z0-9])$2([^0-9]|$)" || true
)
[ "${#files[@]}" -gt 0 ] || {
  echo "No changed files for $2"
  exit 0
}

git add -- "${files[@]}"
git diff --cached --quiet -- "${files[@]}" || git commit -m "$3" -- "${files[@]}"
git pull --rebase --autostash
git push

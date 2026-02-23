#!/usr/bin/env bash
set -uo pipefail
# Auto-detect and install project dependencies in new worktrees.
# Best-effort: continues past failures (no set -e).
# Fires on EnterWorktree and agent isolation: worktree.
# Logs to /tmp/worktree-setup.log for troubleshooting.

LOG="/tmp/worktree-setup.log"

log() { printf '%s [%s] %s\n' "$(date '+%H:%M:%S')" "$1" "$2" >>"$LOG"; }

run_cmd() {
  local label="$1"
  shift
  log "RUN" "$label: $*"
  if output=$("$@" 2>&1); then
    log "OK" "$label"
  else
    local rc=$?
    log "FAIL" "$label (exit $rc)"
    printf '%s\n' "$output" >>"$LOG"
  fi
}

log "START" "worktree-setup in $(pwd)"

# -- Node.js: init fnm, then lockfile determines package manager --
if [ -f package.json ] || [ -f pnpm-lock.yaml ] || [ -f yarn.lock ] || [ -f package-lock.json ]; then
  eval "$(fnm env 2>/dev/null)"
  fnm use --install-if-missing 2>/dev/null
  if [ -f pnpm-lock.yaml ]; then
    run_cmd "pnpm" pnpm install
  elif [ -f yarn.lock ]; then
    run_cmd "yarn" yarn install
  elif [ -f package-lock.json ]; then
    run_cmd "npm-ci" npm ci
  else
    run_cmd "npm-install" npm install
  fi
fi

# -- Rust --
if [ -f Cargo.toml ]; then
  run_cmd "cargo" cargo build
fi

# -- Python: uv > poetry --
if [ -f uv.lock ]; then
  run_cmd "uv" uv sync
elif [ -f poetry.lock ]; then
  run_cmd "poetry" poetry install
elif [ -f pyproject.toml ] && grep -qE '\[tool\.poetry\]|poetry\.core\.masonry' pyproject.toml 2>/dev/null; then
  run_cmd "poetry" poetry install
fi

# -- Go --
if [ -f go.mod ]; then
  run_cmd "go" go mod download
fi

log "END" "worktree-setup"

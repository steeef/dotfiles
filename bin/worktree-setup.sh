#!/usr/bin/env bash
set -uo pipefail
# Auto-detect and install project dependencies in new worktrees.
# Best-effort: continues past failures (no set -e).
# Fires on EnterWorktree and agent isolation: worktree.

# -- Node.js: init fnm, then lockfile determines package manager --
if [ -f package.json ] || [ -f pnpm-lock.yaml ] || [ -f yarn.lock ] || [ -f package-lock.json ]; then
  eval "$(fnm env 2>/dev/null)"
  fnm use --install-if-missing 2>/dev/null
  if [ -f pnpm-lock.yaml ]; then
    pnpm install 2>/dev/null
  elif [ -f yarn.lock ]; then
    yarn install 2>/dev/null
  elif [ -f package-lock.json ]; then
    npm ci 2>/dev/null
  else
    npm install 2>/dev/null
  fi
fi

# -- Rust --
if [ -f Cargo.toml ]; then
  cargo build 2>/dev/null
fi

# -- Python: lockfile > pyproject.toml section > requirements.txt --
if [ -f uv.lock ]; then
  uv sync 2>/dev/null
elif [ -f poetry.lock ]; then
  poetry install 2>/dev/null
elif [ -f pyproject.toml ] && grep -q '\[tool\.poetry\]' pyproject.toml 2>/dev/null; then
  poetry install 2>/dev/null
elif [ -f requirements.txt ]; then
  pip install -r requirements.txt 2>/dev/null
elif [ -f setup.py ] || [ -f setup.cfg ]; then
  pip install -e . 2>/dev/null
fi

# -- Go --
if [ -f go.mod ]; then
  go mod download 2>/dev/null
fi

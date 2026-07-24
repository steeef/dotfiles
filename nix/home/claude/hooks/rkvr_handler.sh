#!/usr/bin/env bash
# rm-block guidance for command-safety@claude-hooks, invoked as the
# CLAUDE_HOOKS_RM_HANDLER when that plugin's rm_check.py denies an `rm` call.
# Receives the blocked target paths as argv; stdout becomes the hook's
# "how to fix it" guidance shown to Claude.
set -euo pipefail

targets="$*"

cat <<EOF
rm is blocked, use rkvr to manage files to remove and it will archive them for possible retrieval later.

  rkvr $targets          # archive + remove (drop-in for \`rm -rf\`)
  rkvr ls-rmrf           # list archived bundles (each one is a timestamp ID)
  rkvr rcvr <timestamp>  # restore a bundle by the ID shown in ls-rmrf - NOT by filename
EOF

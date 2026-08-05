#!/bin/bash
set -eu

# Fires on every PreCompact attempt (speculative and reactive, auto and
# manual) — see nix/home/claude/AGENTS.md for why this must stay stateless
# and side-effect-free. Non-blocking stdout here is folded into
# compaction's newCustomInstructions (undocumented, verified against the
# installed Claude Code binary; re-verify after upgrades).
cat <<'EOF'
When summarizing, preserve: the task's original objective and any explicit
user constraints or decisions (with rationale); the current plan's
completed vs. pending items; paths of files changed; verification/test
results; and any open blockers or unresolved questions.
EOF

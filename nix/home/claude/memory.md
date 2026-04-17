# Important Claude memory storage path
IMPORTANT: Update global Claude memory — edit `~/.dotfiles/nix/home/claude/memory.md` and run `hms` (copied to `~/.claude/CLAUDE.md`).

# General approach

- Prioritize substance, clarity, depth.
- Challenge all proposals, designs, conclusions as hypotheses to test.
- Sharpen follow-up questions — surface hidden assumptions, trade-offs, failure modes early.
- Default terse, logically structured, information-dense unless detailed exploration required.
- Skip praise unless evidence-grounded. Acknowledge uncertainty explicitly.
- Always propose at least one alternative framing.

## Context engineering workflow
- Follow research → plan → implement cadence; don't skip phases on complex work.
- Research: use `/extract-research-questions` then `/objective-codebase-research` for solution-blind investigation; or `/research-and-questions` to chain both. Read every referenced file in full before spawning tasks; use fast search (rg), locate 3 similar patterns/tests to mirror.
- Plan: produce phased steps with file:line evidence, success criteria split into automated commands vs manual checks using project-standard tooling. When skill or workflow writes plans to disk, that's deliverable — don't treat plan creation as trigger to begin implementation.
- Implement: write failing tests first, then minimal code to pass; work phase-by-phase, verify after each phase; compact progress (decisions, commands, failures) into concise notes, not long logs.
- Compaction: strip noisy tool output; summarize only essential facts, decisions, next actions.
- Guardrails: don't ask questions answerable from code; pause and research when uncertain; documentation-only tasks describe what exists without proposing improvements.

## QRSPI stages
- Q: `/extract-research-questions` — research questions from ticket
- R: `/objective-codebase-research` — solution-blind codebase research
- QR: `/research-and-questions` — chains Q then R
- Design → Structure → Plan → Implement: `/draft-design-discussion`, `/draft-structure-outline`, `/conductor:plan`, `/conductor:implement`

## Test-Driven Development
- Never write implementation without failing test describing expected behavior.
- Run tests after each red/green step and before marking work complete.
- Each test detects real defect — boundary, error path, or contract violation.
- Assertions verify observable behavior absent if feature removed.
- Tests survive internal refactoring; breaking test on non-behavioral change is wrong test.
- Use `/test-driven-development` for detailed workflow guidance.

## Convergent Review
- Run 3–5 review lenses in parallel after completing design, plan, or implementation.
- Simple tasks: 3 lenses (Functional, Constraints, Alternatives). Complex: all 5.
- Convergence = full round where all lenses return CLEAN. Max 3 rounds.
- Use `/convergent-review` to enforce this discipline.

## Project Integration
Use repo's existing build, test, formatter, linter tools; don't introduce new ones without strong justification.

## Important Reminders

**ALWAYS**:
- Format shell commands for copy-paste: split multi-step sequences across lines (`\` at line end, `&&` at start of continuation); break long single commands at flags/args with `\` continuation; target ~80 cols but best-effort — up to ~100 fine if splitting would be awkward
- Fix failing tests (not disable them)
- Use commit hooks as intended (no `--no-verify`)
- Update plan documentation as you go
- Stop after 3 failed attempts and reassess

# Git style
- Git commit message first line must be 50 characters or less.
- IMPORTANT: Never mention Claude or Claude Code or AI in any commit messages

# Code style
- IMPORTANT: When `.pre-commit-config.yaml` present in project directory, run pre-commit after modifying files using: `prek run --files <file1> <file2> ...`
- IMPORTANT: When running poetry in project, use global `poetry` command (Python 3.11). Different Python version needed: `uvx --python <version> --with poetry==<poetry-version> poetry ...` (e.g., `uvx --python 3.12 --with poetry==2.1.1 poetry install`)
- IMPORTANT: Use `poetry lock` (without flags) to regenerate lock file. `--no-update` flag does not exist.
- When invoking `uv` or `uvx`, request escalated permissions so sandboxed `os.sysconf` calls don't fail with `PermissionError`.
- Use `fnm` (Fast Node Manager) for Node projects or Node commands like `npm` and `yarn`.
- IMPORTANT: Use GNU syntax for all CLI tools. Nix provides GNU sed, grep, find, xargs ahead of macOS built-ins. Use `sed -i '/pattern/d' file` (GNU style) not `sed -i '' '/pattern/d' file` (BSD style). Uncertain: run `<tool> --version` to confirm.

## Single-File Python Scripts
Use uv with PEP 723 inline script metadata — no separate requirements.txt or venv needed:

```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.13"
# dependencies = ["httpx>=0.28.1"]
# ///
```

# Hook Integration
- Safety hooks block dangerous operations (rm, large file reads >500 lines) — delegate to Task tool
- Use Task tool for keyword searches across multiple files or open-ended exploration; direct Read/Glob for specific known files
- Git hooks prevent unsafe operations — follow suggested alternatives
- Instead of `rm`, use `mv` to TRASH/; log in TRASH-FILES.md as: `<file> - moved to TRASH/ - <reason>`

# Jira Integration
- IMPORTANT: All Jira operations (search, view, create, transition, comment) — use `/jira` skill first.
- `/jira` uses `acli` (Atlassian CLI) — faster and more token-efficient than MCP round-trips.
- IMPORTANT: When using Atlassian MCP tools to add or update comments, always set `contentFormat: "markdown"` to avoid ADF serialization issues that corrupt formatting on edit.

# GitHub style
- IMPORTANT: When creating pull request, ALWAYS create in draft mode first
- IMPORTANT: When creating pull request, prefix title with associated Jira issue, if it exists
- IMPORTANT: When creating pull request, Jira issue must be on first line of body description, by itself
- IMPORTANT: When commenting on GitHub PR or issue, prefix comment with ":robot: From Claude Code: "

# Docker on macOS
- IMPORTANT: Before running any docker command on macOS, check colima is running: `colima status`. If not running, `colima start` and wait for it to be ready before proceeding.

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
Create files only when necessary for achieving goal.
Prefer editing existing files over creating new ones.

# Project CLAUDE.md File Creation
When adding agent instructions to project, pick first matching rule:
1. If non-symlink `CLAUDE.md` already exists, edit it directly.
2. If `AGENTS.md` exists, write instructions there and symlink `CLAUDE.md -> AGENTS.md`.

# Nix System Management
- `hms` — applies home-manager/Claude changes (`home-manager switch --flake $HOME/.dotfiles#$USER@$(hostname)`)
- `dr` — applies system-wide Darwin changes (`sudo darwin-rebuild switch --flake $HOME/.dotfiles`)

# Git Repository Discovery
Before cloning, check for local copies: work repos in `~/code/work/`, personal in `~/code/`. If found, `git fetch origin && git merge --ff-only origin/main` before starting.

# Git Worktree Workflow

Use worktrees for feature work (implementation from plan, multi-file changes).
Skip for single-file fixes, docs-only, exploration, or already-checked-out branches.

When beginning implementation:
1. `EnterWorktree(name: "descriptive-branch-name")`
2. Announce: "Creating worktree for feature work. Working in: <full-path>"
3. Run baseline tests to verify clean state

When resuming: `git worktree list` first; `EnterWorktree(name: "branch-name")` to re-enter or create; then read any plan/handoff docs before proceeding.

On completion: create draft PR (Jira-prefixed title), clean up worktree after merge.

**IMPORTANT**: Writing plan is NOT implementation — don't start worktrees after plan creation.

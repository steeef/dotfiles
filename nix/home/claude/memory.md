# Important Claude memory storage path
IMPORTANT: Update global Claude memory — edit `~/.dotfiles/nix/home/claude/memory.md` and run `hms` (copied to `~/.claude/CLAUDE.md`).

# Git commits

- IMPORTANT: First line of commit message must be 50 characters or less.
- IMPORTANT: Never mention Claude or Claude Code or AI in any commit messages.

# GitHub pull requests

- IMPORTANT: For GitHub remotes, always create PRs in draft mode first (`--draft`). For Forgejo remotes, draft mode is unsupported via CLI — create as open.
- IMPORTANT: Prefix PR title with associated Jira issue if it exists.
- IMPORTANT: First line of PR body is the Jira issue, by itself.
- IMPORTANT: Prefix comments on GitHub PRs or issues with `:robot: From Claude Code:`.

# Commit hooks

- IMPORTANT: Use commit hooks as intended — never `--no-verify`. Fix failing checks, don't bypass.
- IMPORTANT: When `.pre-commit-config.yaml` present, run pre-commit after modifying files: `prek run --files <file1> <file2> ...`.

# File deletion

- Instead of `rm`, `mv` to `TRASH/` and log in `TRASH-FILES.md` as: `<file> - moved to TRASH/ - <reason>`.

# Tool conventions

- IMPORTANT: Use global `poetry` command (Python 3.11). Different Python: `uvx --python <ver> --with poetry==<ver> poetry ...` (e.g. `uvx --python 3.12 --with poetry==2.1.1 poetry install`).
- IMPORTANT: `poetry lock` (no flags) regenerates lock file. `--no-update` flag does not exist.
- When invoking `uv` or `uvx`, request escalated permissions so sandboxed `os.sysconf` calls don't fail with `PermissionError`.
- Use `fnm` (Fast Node Manager) for Node projects or commands like `npm`, `yarn`, `npx`.
- IMPORTANT: Use GNU syntax for CLI tools. Nix provides GNU sed/grep/find/xargs ahead of macOS built-ins. Use `sed -i '/pattern/d' file` (GNU) not `sed -i '' '/pattern/d' file` (BSD). Confirm with `<tool> --version`.
- Single-file Python: use `uv` with PEP 723 inline script metadata (`#!/usr/bin/env -S uv run --script` + `# /// script ... # ///` block). See <https://docs.astral.sh/uv/guides/scripts/>.

# Working approach
- Default terse, logically structured, information-dense. Acknowledge uncertainty explicitly. Skip praise unless evidence-grounded. Propose at least one alternative framing.
- State assumptions explicitly before coding; ask if ambiguous.
- Research → plan → implement; don't skip phases on complex work.
- Writing a plan is the deliverable — do NOT treat plan creation as trigger to start implementation.
- Stop after 3 failed attempts and reassess.
- Surgical edit test: every changed line must trace directly to the user's request.
- Format shell commands for copy-paste: `\` line continuation, `&&` at start of continuation, target ~80 cols.
- Use repo's existing build/test/format/lint tools; don't introduce new ones without strong justification.

# Workflow skills
- Research: `/extract-research-questions` (Q), `/objective-codebase-research` (R), `/research-and-questions` (chains Q+R).
- Plan: `/draft-design-discussion` → `/draft-structure-outline` → `/conductor:plan` → `/conductor:implement`.
- TDD: `/test-driven-development` — failing test before impl; assertions verify observable behavior; tests survive refactors.
- Review: `/convergent-review` — 3-5 parallel lenses (Functional/Constraints/Alternatives + Risk/Performance for complex); convergence = full clean round; max 3 rounds.

# Jira integration
- IMPORTANT: All Jira operations (search, view, create, transition, comment) — use `/jira` skill first. `/jira` uses `acli` (Atlassian CLI), faster + more token-efficient than MCP.
- IMPORTANT: When using Atlassian MCP tools for comments, always set `contentFormat: "markdown"` to avoid ADF serialization corruption.

# Nix system management
- `hms` — Home Manager switch (`home-manager switch --flake $HOME/.dotfiles#$USER@$(hostname)`).
- `dr` — Darwin system switch (`sudo darwin-rebuild switch --flake $HOME/.dotfiles`).

# Git repository discovery
Before cloning, check local copies: work repos in `~/code/work/`, personal in `~/code/`. If found, `git fetch origin && git merge --ff-only origin/main` before starting.

# Git worktree workflow
Use for feature work (implementation from plan, multi-file changes). Skip for single-file fixes, docs-only, exploration, or already-checked-out branches.
- Start: `EnterWorktree(name: "descriptive-branch-name")` → announce path → run baseline tests.
- Resume: `git worktree list` first; `EnterWorktree(name: "branch-name")` to re-enter or create; read any plan/handoff docs before proceeding.
- Done: create PR (draft if GitHub, open if Forgejo; Jira-prefixed title); clean up worktree after merge.

# Docker on macOS
- IMPORTANT: Before any docker command, check `colima status`. If not running, `colima start` and wait until ready before proceeding.

# Hooks + Task tool
- Safety hooks block dangerous ops (rm, large file reads >500 lines) — delegate to the Task tool.
- Task tool for keyword searches across multiple files or open-ended exploration; direct Read/Glob for specific known files.
- Git hooks prevent unsafe operations — follow suggested alternatives, do not bypass.
- ALWAYS: Never read `.jsonl` session transcripts directly (10MB+). If a skill passes a transcript path, ignore it or summarize via `ctx_execute_file` with a line-count limit.

# Project CLAUDE.md creation
First matching rule:
1. If non-symlink `CLAUDE.md` already exists, edit it directly.
2. If `AGENTS.md` exists, write instructions there and symlink `CLAUDE.md -> AGENTS.md`.

# Final reminders
Do what has been asked — nothing more, nothing less. Create files only when necessary. Prefer editing existing files. Fix failing tests, never disable them. Update plan documentation as you go.

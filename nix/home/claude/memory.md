# Important Claude memory storage path
IMPORTANT: Update global Claude memory — edit `~/.dotfiles/nix/home/claude/memory.md` and run `hms` (copied to `~/.claude/CLAUDE.md`).

# Git commits

- IMPORTANT: First line of commit message must be 50 characters or less.
- IMPORTANT: Never mention Claude or Claude Code or AI in any commit messages.

# GitHub pull requests

- IMPORTANT: For GitHub remotes, always create PRs in draft mode first (`--draft`). For Forgejo remotes, draft mode is unsupported via CLI — create as open.
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
- TDD: `/test-driven-development` — failing test before impl; assertions verify observable behavior; tests survive refactors.
- Review: `/convergent-review` — 3-5 parallel lenses (Functional/Constraints/Alternatives + Risk/Performance for complex); convergence = full clean round; max 3 rounds.

# Nix system management
- `hms` — Home Manager switch (`home-manager switch --flake $HOME/.dotfiles#$USER@$(hostname)`).
- `dr` — Darwin system switch (`sudo darwin-rebuild switch --flake $HOME/.dotfiles`).

# Git repository discovery
IMPORTANT: Claude works in bare-container worktrees under `~/wt`, NEVER in the user's clones (`~/code/work/`, `~/code/`) — those are the human's, leave them untouched. To start work: `cd` into any clone of the target repo (its `origin` URL is read, read-only, to derive the container) and use `EnterWorktree`; it clones `--bare` on demand into `~/wt/<repo>/.bare` and creates a worktree. Do not `git fetch`/edit/commit inside `~/code/work` or `~/code` clones.

# Git worktree workflow
`EnterWorktree` is the default before modifying files in any repo. It bootstraps a bare container under `~/wt` (override the base with `$CLAUDE_WORKTREE_BASE`), so every worktree is a peer with no privileged main checkout. Editing a human clone directly is the opt-out (the worktree guard will prompt).
- Start: `EnterWorktree(name: "descriptive-branch-name")` → announce path → run baseline tests. In work repos, prefix the name with the ticket/issue key.
- Resume: `git worktree list` first; `EnterWorktree(name: "branch-name")` to re-enter (idempotent) or create; read any plan/handoff docs before proceeding.
- NEVER `EnterWorktree(path: ~/wt/...)` to adopt a bare-container worktree — the builtin validates `path` against the *current clone's* `git worktree list`, which never lists `~/wt` worktrees (different repo), so it rejects. Always re-enter with `name:`; it is idempotent and adopts an existing `~/wt/<repo>/<name>`.
- NEVER hand-roll `git worktree add` then edit via absolute paths to "satisfy the guard's intent." If a `~/wt/<repo>/<name>` worktree exists, `EnterWorktree(name:)` adopts it; if not, it creates it. The tool is the path, not a workaround.
- Done: create PR (draft if GitHub, open if Forgejo) → clean up the worktree (`ExitWorktree`) after merge.
- IMPORTANT: `EnterWorktree` FIRST — before any clone-resident work. If you `cd` around `~/code/work/*` clones first and only later enter a worktree, `ExitWorktree` returns the session to that clone AND leaves a residual cwd pin: every later `cd` snaps back ("Shell cwd was reset to …") and you are stuck in a forbidden clone. If that happens, re-`EnterWorktree(name:)` to re-pin into the worktree, or start a fresh session — do not keep fighting `cd`. (Diagnosed: session f358f1ef.)

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

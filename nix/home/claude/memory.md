# Important Claude memory storage path
IMPORTANT: Update global Claude memory — edit `~/.dotfiles/nix/home/claude/memory.md` and run `hms` (copied to `~/.claude/CLAUDE.md`).

# Git commits

- IMPORTANT: First line of commit message must be 50 characters or less.
- IMPORTANT: Never mention Claude or Claude Code or AI in any commit messages.

# GitHub pull requests

- IMPORTANT: For GitHub remotes, always create PRs in draft mode first (`--draft`). For Forgejo remotes, draft mode is unsupported via CLI — create as open.
- IMPORTANT: Prefix comments on GitHub PRs or issues with `:robot: From Claude Code:`.
- IMPORTANT: Don't hard-wrap PR/issue description or comment body prose. One paragraph = one line — GitHub renders in-paragraph newlines as `<br>` in these fields, so column-wrapping shows as broken lines.
- IMPORTANT: Always include the full PR URL (never just "PR #123") whenever creating, updating, or referencing a PR — surface it directly in chat as a clickable link, don't make the user dig for it.
- IMPORTANT: Keep PR descriptions brief — short summary and the essentials only, no padding sections, no restating the diff line-by-line.

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
- IMPORTANT: Use `tenv` for Terraform version management (NOT `tfenv` — not installed). `tenv tf install <ver>` / `tenv tf use <ver>`; respects `.terraform-version` / `.tool-versions`. `tenv` also manages tofu/terragrunt/atmos via `tenv tofu|tg|atmos`.
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

# Git worktrees — modify only in ~/wt; the human's clones are read-only
- Modify files only in `~/wt`; the human's clones (wherever they live) are a read-only origin-URL source. Reading them is fine — research the human's **local state** (branch, uncommitted work, failing build) via Read/Grep/Glob on the clone directly. Anything needing **canonical `origin/main`** (compare-to-main, ignore local drift) or any write (`fetch`/edit/commit) → `EnterWorktree` first.
- `EnterWorktree(name:)` — idempotent adopt-or-create; clones `--bare` into `~/wt/<repo>/.bare` (override base `$CLAUDE_WORKTREE_BASE`), fetches origin, bases the branch on `origin/HEAD` (so clone staleness can't reach the worktree). In work repos prefix `name` with the ticket key; announce the path and run baseline tests. Never pass `path:` — it is builtin-only (skips the worktree hook), needs a git-repo cwd, so it fails after `ExitWorktree` (cwd resets to a non-git dir); re-enter with `name:`, which reuses the existing worktree from any cwd. (git-worktree-hooks ≥1.6.0 denies a non-git-cwd `path:` with that guidance.) Never hand-roll `git worktree add`.
- Reference a repo by name with no local clone: `cd ~/wt/<repo>` (existing or not), THEN `EnterWorktree(name:)`. The hook reuses `~/wt/<repo>/.bare` or infers the clone URL from your existing `~/wt` repos' origins (majority org/host) and clones on demand — asking rather than guessing if the org can't be inferred. A clone under `~/code/work` is no longer required to name the repo. (git-worktree-hooks ≥1.5.0)
- Targeting the right repo: the `cwd_tracker` hook (git-worktree-hooks) records each `cd <clone>` as intent *before* the harness snaps cwd back, and `EnterWorktree` derives its repo from the most-recent such cd-intent (falling back to the cwd's `origin`). So:
  - Already inside the target clone (single-repo session) → call `EnterWorktree(name:)` directly; cwd carries the right `origin`.
  - From a non-clone parent dir, or any multi-repo session → `cd` into the target clone, THEN `EnterWorktree(name:)` in the same/next action. Without a fresh `cd` the hook reuses a stale earlier intent and lands the worktree in the wrong repo. Verify the returned `~/wt/<repo>/…` path is the intended repo before editing. (f358f1ef)
  - After `ExitWorktree` the harness resets cwd to a fallback dir (deleted worktree out from under the shell) — re-`cd` into the next target clone before the next `EnterWorktree`. To re-enter the *same* worktree, `EnterWorktree(name:)` reuses it from that non-git cwd (the cd-intent is still recorded); `path:` would fail there. (a5b66c2b)
- One worktree per repo, but a session **can** re-target another repo: `cd` into B's clone (registers a fresh most-recent cd-intent even though the harness snaps cwd back), THEN `EnterWorktree(name:)` lands in B (git-worktree-hooks ≥1.6.0; mirrors the multi-repo bullet above). Fall back to a **fresh session in B's clone** only when the residual-cwd-pin keeps snapping `cd` back to A — typically after you've already entered A's worktree — so the new B intent won't stick. For cross-repo *research* (no writes), read `origin` directly via `gh api repos/<org>/<repo>/contents/…` / `gh search code` instead of switching worktrees. (bebc56f7)
- `ExitWorktree(remove)` may refuse when it can't verify worktree state — re-invoke with `discard_changes: true` (or `action: "keep"` to preserve it). This is the safety guard, not an error.
- The `read_clone_warn` hook (git-worktree-hooks) warns when you Read/Grep/Glob a human clone instead of a worktree — both when a `~/wt` worktree already exists AND (≥1.5.0) on the first research read of a not-yet-worktreed repo while the `~/wt` workflow is in use (deduped per session). A cue to switch to a worktree or read `origin` via `gh api`/`gh search`; never a block. (cf94a602)
- Done: PR (draft GitHub / open Forgejo) → `ExitWorktree` after merge.

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

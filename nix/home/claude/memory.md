# Important Claude memory storage path
IMPORTANT: Update global Claude memory: cross-cutting instructions → edit `~/.dotfiles/nix/home/claude/memory.md`; file-type/tool-specific conventions → add a rule under `~/.dotfiles/nix/home/claude/rules/`. Run `hms` after either (memory.md copies to `~/.claude/CLAUDE.md`; rules/ symlinks into `~/.claude/rules/`).

# Git commits

- IMPORTANT: First line of commit message must be 50 characters or less.
- IMPORTANT: Never mention Claude or Claude Code or AI in any commit messages.

# GitHub pull requests

- IMPORTANT: For GitHub remotes, always create PRs in draft mode first (`--draft`). For Forgejo remotes, draft mode is unsupported via CLI — create as open.
- IMPORTANT: Prefix comments on GitHub PRs or issues with `:robot: From Claude Code:`.
- IMPORTANT: Don't hard-wrap PR/issue description or comment body prose. One paragraph = one line — GitHub renders in-paragraph newlines as `<br>` in these fields, so column-wrapping shows as broken lines.
- IMPORTANT: Always include the full PR URL (never just "PR #123") whenever creating, updating, or referencing a PR — surface it directly in chat as a clickable link, don't make the user dig for it.
- IMPORTANT: Keep PR descriptions brief — short summary and the essentials only, no padding sections, no restating the diff line-by-line.
- IMPORTANT: If a Jira ticket is associated with the work, put it on the first line of the PR description by itself.
- Tailor tone and detail to the audience reading the PR — a reviewing SRE IC needs different context/detail than a CODEOWNER doing a merge-gate review.

# Commit hooks

- IMPORTANT: Use commit hooks as intended — never `--no-verify`. Fix failing checks, don't bypass.
- IMPORTANT: When `.pre-commit-config.yaml` present, run pre-commit after modifying files: `prek run --files <file1> <file2> ...`.

# File deletion

- Instead of `rm`, use `rkvr <path>` — archives to a tar.gz then removes. Recover with `rkvr ls-rmrf` to find the timestamp-ID bundle, then `rkvr rcvr <timestamp-id>` (recovery is by bundle ID, not by filename).

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
- Second-opinion review: on "review/consult/ask fable", invoke the `fable-reviewer` subagent (Agent tool, model pinned to fable). On "review/consult/ask opus", or when no model is named — including proactively, unasked, before committing to a nontrivial approach, after a recurring error, or before declaring a task/plan done — invoke `opus-reviewer` (model pinned to opus; now the default). Either way, fill in the input template (decision point, approach, what's been tried, errors, files touched, specific question) with real context, not a bare "review this file".

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

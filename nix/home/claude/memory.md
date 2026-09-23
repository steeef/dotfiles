# Important Claude memory storage path
Update global Claude memory: cross-cutting instructions → edit `~/.dotfiles/nix/home/claude/memory.md`; file-type/tool-specific conventions → add a rule under `~/.dotfiles/nix/home/claude/rules/`. Run `hms` after either (memory.md copies to `~/.claude/CLAUDE.md`; rules/ symlinks into `~/.claude/rules/`).

# Git commits

- First line of commit message must be 50 characters or less.
- Write commit messages as if a person wrote them — no mention of Claude, Claude Code, or AI.

# GitHub pull requests

- For GitHub remotes, always create PRs in draft mode first (`--draft`). For Forgejo remotes, draft mode is unsupported via CLI — create as open.
- Leave a PR in draft through any blocked/pending state; surface the blocker and ask before doing anything (`gh pr ready`, merging) to route around it. Draft status is a deliberate gate.
- Prefix comments on GitHub PRs or issues with `:robot: From Claude Code:`.
- Write PR/issue description and comment body prose one paragraph per line — GitHub renders in-paragraph newlines as `<br>` in these fields, so column-wrapping shows as broken lines.
- Always include the full PR URL, not just "PR #123", whenever creating, updating, or referencing a PR — surface it directly in chat as a clickable link the user doesn't have to dig for.
- Keep PR descriptions to a short summary plus the essentials — skip padding sections and diff-by-diff restatement.
- If a Jira ticket is associated with the work, put it on the first line of the PR description by itself.
- Tailor tone and detail to the audience reading the PR — a reviewing SRE IC needs different context/detail than a CODEOWNER doing a merge-gate review.

# Commit hooks

- Use commit hooks as intended: fix failing checks rather than bypassing them with `--no-verify`.
- When `.pre-commit-config.yaml` present, run pre-commit after modifying files. Use `prek run --files <file1> <file2> ...` if `prek` is installed, else `pre-commit run --files <file1> <file2> ...`.

# File deletion

- Instead of `rm`, use `rkvr <path>` — archives to a tar.gz then removes. Recover with `rkvr ls-rmrf` to find the timestamp-ID bundle, then `rkvr rcvr <timestamp-id>` (recovery is by bundle ID, not by filename).

# Working approach
- Default terse, logically structured, information-dense. Acknowledge uncertainty explicitly. Skip praise unless evidence-grounded. Propose at least one alternative framing.
- State assumptions explicitly before coding; ask if ambiguous.
- Research → plan → implement; don't skip phases on complex work.
- Writing a plan is the deliverable — stop there; implementation is a separate step.
- Get a second-model review (`opus-reviewer`) of any plan before presenting it as final.
- Stop after 3 failed attempts and reassess.
- Surgical edit test: every changed line must trace directly to the user's request.
- Format shell commands for copy-paste: `\` line continuation, `&&` at start of continuation, target ~80 cols.
- Use the repo's existing build/test/format/lint tools; introduce a new one only with strong justification.

# Workflow skills
- Research: `/extract-research-questions` (Q), `/objective-codebase-research` (R), `/research-and-questions` (chains Q+R).
- TDD: `/test-driven-development` — failing test before impl; assertions verify observable behavior; tests survive refactors.
- Review: `/convergent-review` — 3-5 parallel lenses (Functional/Constraints/Alternatives + Risk/Performance for complex); convergence = full clean round; max 3 rounds.
- Second-opinion review: invoke the `opus-reviewer` subagent (Agent tool, model pinned to opus) before committing to a nontrivial approach, after a recurring error, or before declaring a task/plan done. Fill in the input template (decision point, approach, what's been tried, errors, files touched, specific question) with real context, not a bare "review this file".

# Hooks + Task tool
- Safety hooks block dangerous ops (rm, large file reads >500 lines) — delegate to the Task tool.
- Task tool for keyword searches across multiple files or open-ended exploration; direct Read/Glob for specific known files.
- Git hooks prevent unsafe operations — follow the suggested alternative.
- `.jsonl` session transcripts (10MB+) are too large to read directly — ignore a passed transcript path, or summarize it via `ctx_execute_file` with a line-count limit.

# Project CLAUDE.md creation
First matching rule:
1. If non-symlink `CLAUDE.md` already exists, edit it directly.
2. If `AGENTS.md` exists, write instructions there and symlink `CLAUDE.md -> AGENTS.md`.

# Final reminders
Do what has been asked — nothing more, nothing less. Create files only when necessary. Prefer editing existing files. Fix failing tests rather than disabling them. Update plan documentation as you go.

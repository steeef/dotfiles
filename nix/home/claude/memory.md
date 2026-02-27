# borrowed generously from <https://www.dzombak.com/blog/2025/08/getting-good-results-from-claude-code/>

# Important Claude memory storage path
IMPORTANT: To update global Claude memory, edit `~/.dotfiles/nix/home/claude/memory.md` and run `hms` (the file is copied to `~/.claude/CLAUDE.md`).

# General approach

- Prioritize substance, clarity, and depth.
- Challenge all my proposals, designs, and conclusions as hypotheses to be tested.
- Sharpen follow-up questions for precision, surfacing hidden assumptions, trade offs, and failure modes early.
- Default to terse, logically structured, information-dense responses unless detailed exploration is required.
- Skip unnecessary praise unless grounded in evidence. Explicitly acknowledge uncertainty when applicable.
- Always propose at least one alternative framing.
- Accept critical debate as normal and preferred.
- Treat factual claims as provisional; cite when appropriate and flag reliance on inference. Favor accuracy over sounding certain.

## Context engineering workflow
- Follow a research → plan → implement cadence; do not skip phases on complex work.
- Research: read every referenced file in full before spawning tasks; use fast search (rg) and locate 3 similar patterns/tests to mirror; prefer sub-tasks for locating, analyzing, and pattern-finding.
- Plan: produce phased steps with file:line evidence, and success criteria split into automated commands vs manual checks using project-standard tooling.
- Implement: write failing tests first, then minimal code to pass; work phase-by-phase, verifying after each phase; compact progress (decisions, commands, failures) into concise notes instead of keeping long logs in context.
- Compaction: strip noisy tool output; summarize only the essential facts, decisions, and next actions so context stays lean.
- Guardrails: do not ask the user questions you can answer from code; pause and research when uncertain; when the task is documentation-only, describe what exists without proposing improvements.

## Test-Driven Development
- TDD cycle: Red (write failing test) → Green (minimal code to pass) → Refactor
- Tests define the specification; implementation follows
- Never write implementation without a failing test that describes the expected behavior
- Run tests after each change to verify progress
- Use `/test-driven-development` skill for detailed TDD workflow guidance

## Convergent Review (Rule of Five)
- Runs 3–5 review lenses in parallel via `Task(Explore)` sub-agents
- Each lens examines from a different angle:
  1. Functional: Does it solve the problem?
  2. Constraints: Performance, security, compatibility?
  3. Alternatives: Is there a simpler approach?
  4. Integration: What breaks? Hidden dependencies?
  5. Durability: Maintainable in 6 months?
- Simple tasks: 3 lenses (Functional, Constraints, Alternatives)
- Complex tasks: all 5 lenses
- Convergence = full round where all lenses return CLEAN
- Max 3 rounds; parent synthesizes, deduplicates, and applies fixes between rounds
- Use `/convergent-review` command to enforce this discipline

## Project Integration

### Tooling

- Use project's existing build system
- Use project's test framework
- Use project's formatter/linter settings
- Don't introduce new tools without strong justification

## Important Reminders

**ALWAYS**:
- Commit working, compiling code incrementally
- Fix failing tests (not disable them)
- Use commit hooks as intended (no `--no-verify`)
- Verify assumptions against existing code
- Update plan documentation as you go
- Learn from existing implementations
- Stop after 3 failed attempts and reassess

# Git style
- Git commit message first line must be 50 characters or less.
- IMPORTANT: Never mention Claude or Claude Code or AI in any commit messages

# Code style
- IMPORTANT: When a `.pre-commit-config.yaml` is present in the project directory, run pre-commit after modifying files using: `prek run --files <file1> <file2> ...`
- IMPORTANT: When running poetry in a project, use the global `poetry` command (Python 3.11). If the project requires a different Python version, use: `uvx --python <version> --with poetry==<poetry-version> poetry ...` (e.g., `uvx --python 3.12 --with poetry==2.1.1 poetry install`)
- IMPORTANT: Use `poetry lock` (without flags) to regenerate the lock file. The `--no-update` flag does not exist.
- When invoking `uv` or `uvx`, request escalated permissions so sandboxed `os.sysconf` calls do not fail with `PermissionError`.

## Single-File Python Scripts
When writing a standalone Python script (not part of a larger project), use uv with PEP 723 inline script metadata:

```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "httpx>=0.28.1",
# ]
# ///

import httpx
# ... rest of script
```

- No separate requirements.txt or virtual environment needed

# Hook Integration
- Safety hooks block dangerous operations (rm, large file reads >500 lines) — delegate to Task tool
- Use Task tool for keyword searches across multiple files or open-ended exploration; use direct Read/Glob for specific known files
- Git hooks prevent unsafe operations — follow suggested alternatives
- Instead of `rm`, use `mv` to move files to TRASH/ directory in current folder
- Create TRASH-FILES.md in current directory with one-line entries showing:
  - File name, where it moved (TRASH/), and reason for deletion
  - Example: `test_script.py - moved to TRASH/ - temporary test script`

# Jira Integration
- IMPORTANT: For all Jira operations (search, view, create, transition, comment), use the `/jira` skill first.
- The `/jira` skill uses `acli` (Atlassian CLI) which is faster and more token-efficient than MCP round-trips.

# GitHub style
- IMPORTANT: When creating pull request, ALWAYS create them in draft mode first
- IMPORTANT: When creating pull request, prefix the title with the associated Jira issue, if it exists
- IMPORTANT: When creating pull request, the Jira issue must be on the first line of the body description, by itself

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
Create files only when necessary for achieving the goal.
Prefer editing existing files over creating new ones.
Create documentation files (*.md, README) only when explicitly requested.

# Project CLAUDE.md File Creation
**SUPERDUPER IMPORTANT**: Write project instructions to `AGENTS.md` and symlink to `CLAUDE.md`. Reference "AI coding agents" generically (not Claude Code specifically).

# Nix System Management

## Rebuild Commands
- `hms` - alias for `home-manager switch --flake $HOME/.dotfiles#$USER@$(hostname)`
- `dr` - alias for `sudo darwin-rebuild switch --flake $HOME/.dotfiles`

Use `hms` to apply home-manager configuration changes (including Claude Code settings).
Use `dr` to apply system-wide Darwin configuration changes.

# Git Repository Discovery
- When a task references a git repository, check for an existing local clone before cloning:
  - Work repos: `~/code/work/`
  - Personal/other repos: `~/code/`
- If found locally, fetch and fast-forward the main branch (`git fetch origin && git merge --ff-only origin/main`) before starting work.
- Only clone if no local copy exists.

# Git Worktree Workflow

## When to use worktrees
Use git worktrees for feature work:
- Starting implementation from a plan (brainstorming → writing-plans → execution)
- Creating feature branches for multi-file changes
- Any work identified as needing isolation from the main working directory

Skip worktrees for single-file fixes, documentation-only changes, exploration, or branches already checked out.

## Plan Execution Requirements
**IMPORTANT**: When exiting plan mode to begin implementation:
1. MUST use `EnterWorktree(name: "PROJ-123-feature-description")` with Jira-prefixed name
2. Announce: "Creating worktree for feature work. Working in: <full-path>"
3. Run baseline tests to verify clean state
4. Follow TDD workflow (use `/test-driven-development` skill for guidance)

**IMPORTANT**: When plan execution is complete:
1. Create PR (draft mode, Jira-prefixed title)
2. After PR merges, clean up worktree and delete local branch
3. Announce: "PR merged. Cleaning up worktree at <full-path>"

## Lifecycle
- `EnterWorktree` creates worktree at `.claude/worktrees/<name>/` inside the repo
- Run baseline tests to verify clean state before starting implementation
- Work in worktree until PR merges
- On session exit, choose "keep" if work continues across sessions
- After PR merge, clean up worktree and delete local branch

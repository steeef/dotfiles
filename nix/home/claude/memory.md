# borrowed generously from https://www.dzombak.com/blog/2025/08/getting-good-results-from-claude-code/

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
- Treat all factual claims as provisional unless cited or clearly justified. Cite when appropriate.
- Acknowledge when claims rely on inference or incomplete information. Favor accuracy over sounding certain.

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
- Apply 4-5 review passes on complex work until output stabilizes
- Each pass examines from a different angle:
  1. Functional: Does it solve the problem?
  2. Constraints: Performance, security, compatibility?
  3. Alternatives: Is there a simpler approach?
  4. Integration: What breaks? Hidden dependencies?
  5. Durability: Maintainable in 6 months?
- 2-3 passes for simple tasks, 4-5 for complex
- Convergence = 2 consecutive passes with no significant issues
- After Pass 5, cycle back to Pass 1 if issues remain
- Use `/convergent_review` command to enforce this discipline

## Project Integration

### Learning the Codebase

- Find 3 similar features/components
- Identify common patterns and conventions
- Use same libraries/utilities when possible
- Follow existing test patterns

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
- Write failing tests before implementation code (TDD)

# Git style
- Git commit message first line must be 50 characters or less.
- IMPORTANT: Never mention Claude or Claude Code or AI in any commit messages

# Code style
* IMPORTANT: When a `.pre-commit-config.yaml` is present in the project directory, run pre-commit after modifying files using: `prek run --files <file1> <file2> ...`
* IMPORTANT: When running poetry in a project, use the global `poetry` command (Python 3.11). If the project requires a different Python version, use: `uvx --python <version> --with poetry==<poetry-version> poetry ...` (e.g., `uvx --python 3.12 --with poetry==2.1.1 poetry install`)
* IMPORTANT: Use `poetry lock` (without flags) to regenerate the lock file. The `--no-update` flag does not exist.
* When invoking `uv` or `uvx`, request escalated permissions so sandboxed `os.sysconf` calls do not fail with `PermissionError`.

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

- Shebang enables direct execution: `./script.py` (after `chmod +x`)
- Metadata block declares Python version and dependencies inline
- No separate requirements.txt or virtual environment needed

# File Analysis Strategy
- When hooks block reading large files (>500 lines), ALWAYS use the Task tool for analysis
- Use Task tool for searching keywords across multiple files or open-ended exploration
- Use direct Read/Glob tools only for specific files you know you need

# Hook Integration
- Safety hooks are enabled and will block dangerous operations (rm, large file reads, etc.)
- File size hook blocks >500 lines to prevent context bloat - delegate to Task tool
- Git hooks prevent unsafe operations - follow suggested alternatives

# GitHub style
* IMPORTANT: When creating pull request, ALWAYS create them in draft mode first
* IMPORTANT: When creating pull request, prefix the title with the associated Jira issue, if it exists
* IMPORTANT: When creating pull request, the Jira issue must be on the first line of the body description, by itself

## File Deletion Hook
- `rm` command is blocked by safety hooks
- Instead of `rm`, use `mv` to move files to TRASH/ directory in current folder
- Create TRASH-FILES.md in current directory with one-line entries showing:
  - File name
  - Where it moved (TRASH/)
  - Reason for deletion
- Example format: `test_script.py - moved to TRASH/ - temporary test script`

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

# Git Worktree Workflow

## When to use worktrees
Use git worktrees for feature work:
- Starting implementation from a plan (brainstorming → writing-plans → execution)
- Creating feature branches for multi-file changes
- Any work identified as needing isolation from the main working directory

Skip worktrees for single-file fixes, documentation-only changes, exploration, or branches already checked out.

## Plan Execution Requirements
**IMPORTANT**: When exiting plan mode to begin implementation:
1. MUST create a Jira-prefixed branch (e.g., `PROJ-123-feature-description`)
2. MUST create a worktree for that branch before any code changes
3. MUST announce: "Creating worktree for plan execution. Working in: <full-path>"
4. Follow TDD workflow (use `/test-driven-development` skill for guidance)

**IMPORTANT**: When plan execution is complete:
1. Create PR (draft mode, Jira-prefixed title)
2. After PR merges, clean up worktree and delete local branch
3. MUST announce: "Plan complete. Cleaning up worktree at <full-path>"

## Worktree locations
- Work repos (under `~/code/work/`): `~/code/work/.worktrees/<repo>/<branch>/`
- Other repos: `~/code/.worktrees/<repo>/<branch>/`

## Communication requirements
- ALWAYS announce when creating a worktree: "Creating worktree for feature work. Working in: <full-path>"
- ALWAYS announce when cleaning up: "PR merged. Cleaning up worktree at <full-path>"
- Status line shows `⧉` indicator when in a worktree (with repo name)

## Lifecycle
- Create worktree at start of feature work
- After creation, auto-detect and run project setup (npm install, cargo build, pip install, poetry install, go mod download)
- Run baseline tests to verify clean state before starting implementation
- Work in worktree until PR merges
- Auto-cleanup worktree after successful merge to main/master
- Delete local branch after cleanup

## Decision Docs in Worktrees
- Store plans, research, and handoffs in `ai_docs/` within the current working directory (worktree or main repo)
- **Commit decision docs** so they merge with the feature branch
- When resuming handoffs, skill searches current directory first, falls back to main repo for legacy docs
- On PR merge, decision docs naturally flow to main with the branch

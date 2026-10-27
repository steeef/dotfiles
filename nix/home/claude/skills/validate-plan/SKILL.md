---
name: validate-plan
description: Verify an implementation matches its plan - run each phase's Verify checks in the plan's target repos and report gaps. Use before marking a plan complete or opening a PR.
allowed-tools:
- Read
- Grep
- Glob
- Task(Explore)
- Bash(git:*)
- Bash(just:*)
- Bash(prek:*)
- Bash(pre-commit:*)
- Bash(pytest:*)
- Bash(npm:*)
- Bash(cargo:*)
- Bash(nix:*)
- Bash(go:*)
- Bash(hms:*)
- Bash(home-manager:*)
---

# Validate Plan

`/validate-plan <plan-path>`

Plan format: `references/plan-schema.md`. Legacy `### Task N` plans validate the same way, treating each task as a phase.

## Process

1. Read the plan fully. Resolve each `repos:` entry (`org/repo`) to a worktree under `~/wt/<repo>/` (`~/wt/<repo>` itself is a bare container; list its worktrees with `git -C ~/wt/<repo>/.bare worktree list`) whose branch contains the plan's ticket key or slug; else a clone whose `origin` matches (`~/code/work/<repo>`; `steeef/dotfiles` is `~/.dotfiles`); else ask. Without `repos:`, use the git repo containing the plan and say so. Check files and run commands only in those repos, never in the thoughts repo.
2. Per phase, run each backticked `Verify:` command in its repo. Use `git -C <path>` and `just --working-directory <path> <recipe>`; one plain command per call, no `cd` or `&&`. Capture exit code, the last 50 lines, and lines containing "error" or "fail". A command outside the allowed tools: report "not run: tool not permitted".
3. Check that files the phase names exist and changed, via `git -C <repo> diff --stat <base>`.
4. List `manual:` items as pending. Never mark them passed.
5. Apply the evidence standard from `verification-before-completion`.

## Report

```markdown
## Validation Summary

**Plan:** <plan-path>
**Repos:** <resolved paths>
**Phases:** N/M complete
**Verify commands:** X/Y passing

### Per phase
Phase N: <title> — COMPLETE | INCOMPLETE — <file/command evidence, exit code>

### Issues Found
<None, or issues with file:line>

### Manual Checks Required
<manual: items>

### Recommendation
<Ready to merge | Fix N issues first | Needs manual verification> (advisory only)
```

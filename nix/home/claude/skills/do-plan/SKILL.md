---
name: do-plan
description: Implement a saved phased plan phase by phase with tests, verification, and per-phase commits. Use when the user wants to execute or resume a plan, e.g. "implement this plan" or "continue the plan". Pass `auto` to skip manual-verification pauses.
allowed-tools:
- Read
- Edit
- Write
- Glob
- Grep
- Skill
- EnterWorktree
- Bash(git:*)
- Bash(just:*)
- Bash(prek:*)
- Bash(pre-commit:*)
- Bash(sed:*)
---

# Do Plan

`/do-plan <plan path | ticket key> [auto]`

Plan format: `~/.claude/skills/validate-plan/references/plan-schema.md`.

## Steps

1. **Load.** Read the plan fully (a ticket key: find its plan with `thoughts:discover`). Resume at the first phase with an unticked automated item. Set `status: in-progress`. Work in the repos named in `repos:` (no `repos:`: the repo containing the plan, and say so) via `EnterWorktree(name: <ticket-slug>)`. A plan spanning several repos: one repo per session.
2. **Per phase**, in order:
   1. Write a failing test with `test-driven-development`, then implement. For config-only phases, the `Verify:` command is the failing check.
   2. Run the phase's `Verify:` commands via `repo:test-runner` and the repo's lint tools. Apply `verification-before-completion`.
   3. Tick the phase's automated checkboxes with `sed -i` (the thoughts clone rejects Edit under a worktree pin).
   4. Commit locally with the global and repo commit rules (50-char subject; fix failing hooks, never bypass).
   5. Pause for the phase's `manual:` items and wait for the user, unless invoked with `auto`. Never tick a manual item unconfirmed; in `auto`, list them as pending.
3. **Drift.** If the codebase differs from what a phase assumes, stop and report expected vs found.
4. **After the last phase:** run `mattpocock-skills:code-review` once, fix findings, rerun the phase checks and commit, then run `validate-plan`. Set `status: done`, sync with `thoughts:sync`, and offer `pr:create` (draft), reporting the full PR URL.

`repo:test-runner` asks two questions on first use in a repo, which stalls `auto`. Run it interactively once per repo before using `auto` there.

Done when every phase's automated checks are ticked and `validate-plan` shows Issues Found: None with every phase COMPLETE, with manual items confirmed or listed pending.

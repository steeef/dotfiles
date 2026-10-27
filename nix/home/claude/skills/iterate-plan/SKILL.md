---
name: iterate-plan
description: Make targeted edits to an implementation plan - add, modify, or remove a phase or step, or update context. Use when a plan needs refinement after review or during execution, e.g. "add a phase to the plan" or "update the plan after review".
allowed-tools:
- Read
- Edit
- Glob
- Grep
---

# Iterate Plan

`/iterate-plan [plan-path] [edit-instructions]`

## Resolve the plan

No path given: Glob `plans/` in the thoughts project (`.thoughts.json` `THOUGHTS_ROOT`, walk up from cwd). Several matches: ask the user to pick. None: ask for a path.

## Process

1. Read the whole plan. Format is in `~/.claude/skills/validate-plan/references/plan-schema.md` (`### Phase N` or legacy `### Task N`). An unrecognized format: propose a minimal diff and ask before editing.
2. Apply only the requested edit with Edit:
   - Add or remove a phase or task: renumber the rest, and keep each phase's `Verify:` lines with it.
   - Modify a step: touch only that step.
   - Update context: touch no phases.
   - Keep frontmatter intact. If an edit adds or removes a target repo, ask first, then update `repos:`.
3. Grep the plan for each phase or task number you renumbered and fix stale references. Confirm numbering is sequential and frontmatter is intact.
4. Report what changed. Do not commit; the user commits, or runs `thoughts:sync`.

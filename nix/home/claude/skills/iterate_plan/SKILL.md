---
name: iterate_plan
description: Make targeted edits to implementation plans - add tasks, modify steps, update context. Use when plan needs refinement after review or during execution.
allowed-tools:

- Read
- Edit
- Glob
- Task(Explore)

---

# Iterate Plan

## Usage

`/iterate_plan [plan-path] [edit-instructions]`

## Plan Resolution

If no path provided, search in order:

1. `$HOME/.claude/plans/`
2. `docs/plans/`
3. `thoughts/shared/plans/`

**Multiple matches:** Present numbered list, ask user to select.
**No matches:** Ask user for explicit path.

## Supported Plan Formats

This command supports plans with:
- `### Task N:` headings (e.g., `### Task 1: Create module`)
- Numbered markdown lists (`1. First task`, `2. Second task`)
- YAML task blocks under `## Tasks` or `## Implementation Tasks`

**Unrecognized format:** Propose minimal diff and ask user to confirm before editing.

## Process

### 1. Load Plan
- Read the entire plan file
- Parse YAML frontmatter (preserve all fields)
- Detect task numbering format
- Note current task count

### 2. Understand Edit Request
- What type of edit? (add task, modify step, remove task, update context)
- Where in the plan does it apply?
- Does it affect task dependencies or numbering?

### 3. Apply Surgical Edit
Use Edit tool for precise changes:
- Add task: Insert at correct position, renumber subsequent tasks
- Modify step: Update only the affected step content
- Remove task: Delete task, renumber subsequent tasks
- Update context: Modify relevant section without touching tasks

### 4. Verify Structure
After edit, verify:
- [ ] YAML frontmatter intact
- [ ] Task numbering sequential (no gaps)
- [ ] No broken cross-references
- [ ] Plan still coherent

### 5. Report Changes
Summarize what was changed. Do NOT commit - user will commit when ready.

## Edit Type Examples

### Add Task
```
Add task after Task 3: "Add input validation"
→ Insert Task 4, renumber 4→5, 5→6, etc.
```

### Modify Step
```
In Task 2, Step 3: change pytest command to include -v flag
→ Edit only that step, preserve everything else
```

### Remove Task
```
Remove Task 4
→ Delete task, renumber 5→4, 6→5, etc.
```

### Update Context
```
Update Architecture section to mention new dependency
→ Edit Architecture section only
```

## Key Principles

- **Surgical:** Change only what's needed
- **Preserve:** Keep existing structure, frontmatter, formatting
- **Sequential:** Maintain correct task numbering
- **No auto-commit:** User controls when to commit

---
name: validate_plan
description: Verify implementation matches plan requirements - check success criteria, run verification commands, report gaps. Use before marking plan complete or creating PR.
allowed-tools:

- Read
- Grep
- Glob
- Task(Explore)
- Bash(git:*)
- Bash(pytest:*)
- Bash(npm:*)
- Bash(cargo:*)
- Bash(nix:*)
- Bash(go:*)
- Bash(hms:*)
- Bash(home-manager:*)

---

# Validate Plan

## Usage

`/validate_plan <plan-path>`

## Supported Plan Schemas

This command works with plans that have ANY of:

1. `## Files to Modify` table with Create/Modify columns
2. `### Task N:` sections with `- Create:` / `- Modify:` bullets
3. `## Verification Checklist` with `- [ ]` items
4. `## Success Criteria` section

**Minimal fallback:** If none found, infer from:
- `## Implementation Tasks` section → check mentioned file paths exist
- Prompt user: "What command verifies this plan is complete?"

## Process

### 1. Locate Repo Root
- If plan is in a git repo, use repo root
- Otherwise, use plan's parent directory
- Verify with user if ambiguous

### 2. Load Plan and Parse Schema
- Read the plan file completely
- Identify which schema elements are present
- Build verification checklist from available information

### 3. Task-by-Task Verification

For each identified task:

**Check Files Exist:**
- [ ] All "Create:" files exist
- [ ] All "Modify:" files show expected changes (via grep for key terms)

**Run Verification Commands:**
- Execute commands from plan's verification section
- Capture: exit code + last 50 lines + any lines containing "error"/"fail"
- Timeout: 60s per command (warn if exceeded)

**Report Status:**
```
### Task N: [Name]
- Files: ✓ all present
- Verification: ✓ passing (exit 0)
- Status: COMPLETE
```

OR

```
### Task N: [Name]
- Files: ✗ missing src/module.py
- Verification: ✗ failing (exit 1)
  └─ Error: test_validation AssertionError line 45
- Status: INCOMPLETE
```

### 4. Success Criteria Check

If plan has "Success Criteria" or "Verification Checklist":
- Run each checkable criterion
- Note criteria requiring manual verification

### 5. Summary Report

```
## Validation Summary

**Plan:** [plan-path]
**Repo:** [repo-root]
**Tasks:** N/M complete
**Verification Commands:** X/Y passing

### Issues Found
[None / List of issues with locations]

### Manual Checks Required
[List any criteria that couldn't be automated]

### Recommendation
[Ready to merge / Fix N issues first / Needs manual verification]
```

## Key Principles

- **Evidence-based:** Run commands, don't assume
- **Complete:** Check every task, not just tests
- **Actionable:** Report specific issues with file:line locations
- **Honest:** Report actual state, not hoped state
- **Graceful degradation:** Work with partial schemas

---
description: Use when completing a design, plan, or implementation draft that needs quality validation - forces 4-5 review passes until output stabilizes
allowed-tools:
  - Read
  - Edit
  - Glob
  - Task(Explore)
---

# Convergent Review (Rule of Five)

## Overview

Force 4-5 review passes on any artifact until it converges. Each pass examines from a different angle. Convergence = 2 consecutive clean passes.

**Announce at start:** "Using /convergent_review to validate this [design/plan/implementation]."

## The Five Lenses

Run passes in order (1→2→3→4→5). After Pass 5, cycle back to Pass 1 if needed.

### Pass 1: Functional
- Does this actually solve the stated problem?
- What requirements are missing or incomplete?
- Are there gaps in the logic?

### Pass 2: Constraints
- Performance implications?
- Security vulnerabilities?
- Compatibility issues?
- Resource consumption?

### Pass 3: Alternatives
- Is there a simpler approach we didn't consider?
- Are we over-engineering?
- What would a 10x simpler version look like?

### Pass 4: Integration
- How does this interact with existing systems?
- What might break?
- Are there hidden dependencies?

### Pass 5: Durability
- Can someone else understand this in 6 months?
- Is it maintainable?
- What happens when requirements change?

## Convergence Rules

**Pass cycling:** After Pass 5, if issues remain, cycle back to Pass 1 (→2→3→4→5→1→...).

**For simple tasks (single component, <100 lines):**
- Minimum 2 passes
- Stop when 2 consecutive passes find no significant issues

**For complex tasks (multi-component, architectural):**
- Minimum 4 passes
- Stop when 2 consecutive passes find no significant issues

**If pass reveals issues:**
1. Record issues in plan file
2. Fix issues (or note them for user if outside scope)
3. Re-run THAT SAME pass to verify fix
4. Update plan file with results
5. STOP and report to user
6. Wait for user before proceeding to next pass

## Pass Execution Protocol

**Each pass is a discrete unit.** Do NOT run multiple passes in one turn.

**After completing each pass:**
1. Update the plan file with findings under `## Convergent Review Log`
2. **STOP** and report to user:
   - What issues were found
   - What fixes were applied (if any)
   - Current pass status
3. **Wait** for user to say "continue" or give other direction

**Plan file format:**
```
## Convergent Review Log

### Pass 1: Functional
**Issues Found:** N
- [Issue with file:line]
**Fixes Applied:**
- [Fix description]
**Status:** Clean / Needs fixes

[User continued after review]

### Pass 2: Constraints
...
```

**Why stop between passes:**
- Prevents rushed analysis
- User can redirect focus
- Creates audit trail in plan file
- Allows course correction before next lens

## Output Format

**Write to plan file first, then report to user.**

After each pass, add to plan file:
```
### Pass N: [Lens Name]
**Issues Found:** [count]
- [Issue 1 with file:line]
- [Issue 2 with file:line]
**Fixes Applied:**
- [Fix description]
**Status:** Clean / Needs fixes
```

Then tell user: "Pass N complete. [Summary of findings]. Updated plan file. Say 'continue' for next pass."

After convergence, add to plan file:
```
### Convergence Achieved
**Total Passes:** N (including re-runs)
**Final Status:** Ready for [next step]
**Key Improvements Made:**
- [Improvement 1]
- [Improvement 2]
```

## When to Use

**Best for:**
- After brainstorming produces a design
- After writing-plans produces a plan
- After drafting significant documentation
- When reviewing architectural decisions

**Not for:**
- Final verification (use `verification-before-completion`)
- External review (use `requesting-code-review`)
- Simple bug fixes or typos

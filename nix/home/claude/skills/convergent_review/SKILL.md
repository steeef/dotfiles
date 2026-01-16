---
name: convergent_review
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

## Session Workflow

**Each pass runs in a separate session.** This is intentional—fresh context prevents confirmation bias.

**The cycle:**
1. Run `/convergent_review` in a session
2. Execute one pass, write findings to plan file
3. Report to user and **end the session**
4. User clears context (`/clear` command or restart Claude)
5. User runs `/convergent_review` again in fresh session
6. Read plan file to determine next pass, continue

**The plan file is your persistent memory.** Everything relevant must be written there—the next session won't remember this one.

**Why clear context?**
- Fresh perspective catches issues you became blind to
- Prevents building on flawed reasoning from earlier passes
- Forces each pass to stand on its own analysis

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

**One pass per session.** Do NOT run multiple passes without context clearing.

**During a pass:**
1. Read the plan/design document under review
2. Apply the lens for this pass (see The Five Lenses)
3. Document all issues found with `file:line` references
4. Apply fixes if within scope (or note for user if not)

**After completing the pass:**
1. Update plan file under `## Convergent Review Log`
2. Report summary to user:
   - Issues found and fixed
   - Issues noted for user
   - Pass status (Clean / Needs fixes)
3. **End the session.** Say: "Pass N complete. Clear context and run `/convergent_review` to continue."

**Do not proceed to the next pass.** Wait for user to clear context and start fresh.

**Plan file format:**
```
## Convergent Review Log

### Pass 1: Functional
**Issues Found:** N
- [Issue with file:line]
**Fixes Applied:**
- [Fix description]
**Status:** Clean / Needs fixes

### Pass 2: Constraints
...
```

## Resuming a Review

When starting a new session after context was cleared:

1. Read the plan file's `## Convergent Review Log`
2. Find the last completed pass
3. Determine next action:
   - If last pass was **Clean** → proceed to next pass number
   - If last pass had **Needs fixes** and fixes applied → re-run same pass
   - If 2 consecutive **Clean** passes → announce convergence achieved
4. Announce: "Resuming convergent review at Pass N: [Lens Name]"
5. Execute that pass

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

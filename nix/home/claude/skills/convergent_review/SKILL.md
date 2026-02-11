---
name: convergent_review
description: Use when completing a design, plan, or implementation draft that needs quality validation - runs parallel review agents across 5 lenses until output converges
allowed-tools:
- Read
- Edit
- Glob
- Grep
- Task(Explore)
---

# Convergent Review (Rule of Five) — Parallel Sub-Agent Edition

## Overview

Run 3–5 review lenses in parallel using `Task(Explore)` sub-agents, synthesize findings, fix issues, and repeat until a full round returns clean. Max 3 rounds.

**Announce at start:** "Using /convergent_review to validate this [design/plan/implementation]."

## The Five Lenses

### 1. Functional

- Does this actually solve the stated problem?
- What requirements are missing or incomplete?
- Are there gaps in the logic?

### 2. Constraints
- Performance implications?
- Security vulnerabilities?
- Compatibility issues?
- Resource consumption?

### 3. Alternatives
- Is there a simpler approach we didn't consider?
- Are we over-engineering?
- What would a 10x simpler version look like?

### 4. Integration
- How does this interact with existing systems?
- What might break?
- Are there hidden dependencies?

### 5. Durability
- Can someone else understand this in 6 months?
- Is it maintainable?
- What happens when requirements change?

## Workflow

### Step 1: Read Artifact and Classify Complexity

Read all files under review. Classify:

- **Simple** (single file, <100 total lines in the artifact): use 3 lenses — Functional, Constraints, Alternatives
- **Complex** (multi-file, or single file ≥100 lines, or architectural): use all 5 lenses

Announce: "Classified as [simple/complex]. Running [3/5] lenses in parallel."

### Step 2: Launch Parallel Review Sub-Agents

Launch all selected lenses as `Task(Explore)` sub-agents **in a single message** (parallel execution). Each sub-agent receives:

1. The artifact path(s) to read
2. Its specific lens questions
3. A structured output format

**Sub-agent prompt template** (adapt per lens):

```
Review the following artifact through the **[LENS NAME]** lens.

Artifact files:
- [path1]
- [path2]

Questions to evaluate:
- [lens question 1]
- [lens question 2]
- [lens question 3]

Read each file completely. Cite file:line for every finding. Report using EXACTLY this format:

LENS: [Lens Name]
STATUS: CLEAN | ISSUES_FOUND
ISSUES:
- [severity: HIGH|MEDIUM|LOW] [file:line] [description]
- ...
SUMMARY: [1-2 sentence summary of findings]

If no issues found, use STATUS: CLEAN and ISSUES: none.
```

**Error handling:** If a sub-agent returns malformed output or fails, re-launch that single lens. After 2 failures for the same lens, skip it and note in the review log.

### Step 3: Synthesize Findings

After all sub-agents complete:

1. Collect all ISSUES from every lens
2. Deduplicate — same file:line referenced by multiple lenses counts once (note which lenses flagged it)
3. Detect conflicts — if two lenses disagree (e.g., Alternatives says "remove X", Integration says "X is critical"), flag as CONFLICT
4. Sort by severity: HIGH → MEDIUM → LOW

### Step 4: Apply Fixes or Escalate

- **Fixable issues** (clear, unambiguous): apply fixes using Edit
- **Conflicts between lenses**: escalate to user with both perspectives — do NOT auto-resolve
- **Out-of-scope issues**: note for user

After applying fixes, list what changed.

### Step 5: Re-Review (If Fixes Applied)

If fixes were applied in Step 4:

1. Select lenses to re-run:
   - **Default**: re-run ALL lenses that returned ISSUES_FOUND in the previous round
   - **Narrow fixes** (single file, <10 lines changed): re-run only the lenses that flagged those specific issues
2. Launch only those lenses as parallel sub-agents (same prompt template)
3. Synthesize again (back to Step 3)

### Step 6: Convergence Check

- **Converged**: a round where ALL selected lenses return CLEAN → done
- **Not converged**: repeat from Step 5 with only lenses that returned ISSUES_FOUND
- **Max 3 rounds**: after 3 rounds without convergence, stop and present remaining issues sorted by severity. User decides whether to accept, fix manually, or extend review.

Announce: "Round N complete. [Converged / N issues remain, starting round N+1 / Max rounds reached, reporting remaining issues]."

### Step 7: Write Review Log

Update the plan file under `## Convergent Review Log`. If no plan file exists, output the review log directly in the conversation instead.

```markdown
## Convergent Review Log

### Round 1
**Lenses Run:** Functional, Constraints, Alternatives, Integration, Durability
**Issues Found:** N
- [HIGH] [file:line] [description] (flagged by: Functional, Integration)
- [MEDIUM] [file:line] [description] (flagged by: Constraints)
**Fixes Applied:**
- [description of fix]
**Conflicts Escalated:**
- [lens A] vs [lens B]: [description]

### Round 2 (Re-Review)
**Lenses Re-Run:** Functional, Integration
**Issues Found:** 0
**Status:** All lenses CLEAN

### Convergence Achieved
**Total Rounds:** 2
**Final Status:** Ready for [next step]
**Key Improvements Made:**
- [Improvement 1]
- [Improvement 2]
```

Then report summary to user.

## Convergence Rules Summary

| Complexity | Lenses | Converged When | Max Rounds |
|------------|--------|----------------|------------|
| Simple | 3 (Functional, Constraints, Alternatives) | Full round* all CLEAN | 3 |
| Complex | 5 (all) | Full round* all CLEAN | 3 |

*Full round = all selected lenses run and return results.

## When to Use

**Best for:**
- After brainstorming produces a design
- After writing-plans produces a plan
- After drafting significant documentation
- When reviewing architectural decisions

**Not for:**
- Final verification (use `verification-before-completion`)
- Standard code review or PR review processes
- Simple bug fixes or typos

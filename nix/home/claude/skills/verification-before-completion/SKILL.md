---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs
---

# Verification Before Completion

**Core principle:** Evidence before claims, always.

## The Gate

Before claiming any status (complete, fixed, passing, done):

1. **Pick** the command that proves the claim (test suite, linter, build)
2. **Run** it fresh in this session and read the full output and exit code
3. **Claim** with the command and key output (e.g. "Ran `npm test`: 34/34 pass, exit 0"). If the output doesn't confirm it, state the actual status with evidence.

Skipping a step leaves the claim unverified. That includes satisfaction language ("Great!", "Done!") and implied success, not just explicit completion statements.

## What Counts as Verification

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, "looks good" |
| Bug fixed | Reproduce original symptom: passes | Code changed, assumed fixed |
| Requirements met | Line-by-line checklist verified | Tests passing alone |

## Red Flags — Stop and Verify

- Using "should", "probably", "seems to"
- Expressing satisfaction before running commands
- About to commit/push/PR without fresh output
- Relying on partial verification

## Regression Tests

Prove a regression test by seeing it fail: revert the fix, run (must fail), restore, run (must pass). See `test-driven-development`.

## Agent Delegation

When delegating to sub-agents: verify via VCS diff + running commands yourself. Agent success reports are claims, not evidence.

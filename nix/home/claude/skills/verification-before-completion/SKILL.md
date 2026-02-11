---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims
---

# Verification Before Completion

**Core principle:** Evidence before claims, always.

## The Gate

Before claiming any status (complete, fixed, passing, done):

1. **IDENTIFY** — What command proves this claim? (test suite, linter, build, etc.)
2. **RUN** — Execute the full command fresh in this session
3. **READ** — Check full output and exit code
4. **VERIFY** — Does output confirm the claim?
   - NO: State actual status with evidence
   - YES: State claim with evidence
5. **THEN** — Make the claim, citing command + key output (e.g. "Ran `npm test`: 34/34 pass, exit 0")

Skip any step = unverified claim. This includes satisfaction language ("Great!", "Done!", "Perfect!") and implications of success — not just explicit completion statements.

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
- Trusting agent success reports without independent check
- Relying on partial verification

## Regression Tests (TDD Red-Green)

```text
Write test -> Run (pass) -> Revert fix -> Run (MUST FAIL) -> Restore -> Run (pass)
```

A regression test that was never seen to fail proves nothing.

## Agent Delegation

When delegating to sub-agents: verify via VCS diff + running commands yourself. Agent success reports are claims, not evidence.

## Bottom Line

Run the command. Read the output. Then claim the result. No shortcuts.

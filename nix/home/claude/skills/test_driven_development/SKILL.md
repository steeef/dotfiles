---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

# Test-Driven Development

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

## When to Use

**Always:** New features, bug fixes, refactoring, behavior changes.

**Exceptions (require human permission):** Throwaway prototypes, generated code, configuration-only changes.

## The Iron Law

No production code without a failing test first.

Wrote code before the test? Delete it. Start over. No "reference", no "adapting".

## Red-Green-Refactor

### RED — Write Failing Test

Write one minimal test showing what should happen:
- One behavior per test
- Clear name describing the behavior
- Real code, not mocks (unless unavoidable)

### Verify RED — Watch It Fail

Run the test. Confirm:
- Test fails (not errors from typos/imports)
- Failure message matches expected missing behavior
- Test passes when feature exists? You're testing existing behavior — fix the test

### GREEN — Minimal Code

Write the simplest code that makes the test pass.
- Don't add features beyond the test
- Don't refactor other code
- Don't over-engineer (YAGNI)

### Verify GREEN — Watch It Pass

Run the test. Confirm:
- New test passes
- All other tests still pass
- No errors or warnings in output

Test fails? Fix code, not test. Other tests fail? Fix now.

### REFACTOR — Clean Up

Only after green:
- Remove duplication
- Improve names
- Extract helpers

Keep tests green throughout. Don't add behavior.

### Repeat

Next failing test for next behavior.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Need to explore first" | Fine. Throw away exploration, start with TDD. |
| "Test hard = skip" | Hard to test = hard to use. Listen to the test. |
| "Already manually tested" | Ad-hoc != systematic. No record, can't re-run. |

## When Stuck

| Problem | Solution |
|---------|----------|
| Don't know how to test | Write the assertion first. Design the API you wish existed. |
| Test too complicated | Design too complicated. Simplify the interface. |
| Must mock everything | Code too coupled. Use dependency injection. |
| Test setup huge | Extract helpers. Still complex? Simplify design. |

## Anti-Patterns

When introducing mocks or test helpers, watch for: testing mock behavior instead of real behavior, adding test-only methods to production classes, mocking without understanding the dependency.

## Verification Checklist

Before marking work complete:
- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason (feature missing, not typo)
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass with clean output
- [ ] Edge cases and errors covered

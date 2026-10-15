---
name: test-driven-development
description: Test-driven development, strict red-green-refactor: write a failing test before any production code. Use when implementing a feature, fixing a bug, refactoring, or changing behavior
---

# Test-Driven Development

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

## When to Use

**Always:** New features, bug fixes, behavior changes, refactors that change behavior.

**Ask the user before skipping:** Throwaway prototypes, generated code, configuration-only changes.

## The Iron Law

No production code without a failing test first.

Wrote code before the test? Delete it. Start over. No "reference", no "adapting".

## Red-Green-Refactor

### RED — Write Failing Test

Write one minimal test showing what should happen:

- One behavior per test
- Clear name describing the behavior
- Real code, not mocks. If a mock is unavoidable, test real behavior through it, keep test-only methods out of production classes, and understand the dependency first.

### Verify RED — Watch It Fail

Run the test. Confirm:
- Test fails (not errors from typos/imports)
- Failure message matches expected missing behavior
- Test passes when feature exists? You're testing existing behavior — fix the test

### GREEN — Minimal Code

Write only what the failing test demands: the simplest code that makes it pass.

### Verify GREEN — Watch It Pass

Run the test. Confirm:
- New test passes
- All other tests still pass
- Output is clean, no errors or warnings

Test fails? Fix code, not test. Other tests fail? Fix now.

### Verify Strength — Mutation Check

Target the changed files only.

- **Repo has a mutation tool** (mutmut, Stryker, PITest): run it on those files.
- **No tool:** plant 3-5 small bugs by hand in the changed code (flip a condition, shift a boundary, drop a return value). Run the tests after each; at least one must fail. Revert each bug before the next. Do not install a tool.

Done when every surviving mutant is either killed by a new assertion (re-run to confirm) or is equivalent (no observable change) and noted in the final summary.

### REFACTOR — Clean Up

Only after green. Refactoring changes structure only; tests stay green throughout:
- Remove duplication
- Improve names
- Extract helpers

Then return to RED for the next behavior.

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

## Before Marking Work Complete

Every new function/method has a test, and edge cases and errors are covered.

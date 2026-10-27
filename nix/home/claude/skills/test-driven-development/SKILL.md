---
name: test-driven-development
description: Test-driven development, strict red-green-refactor: write a failing test before any production code. Use when implementing a feature, fixing a bug, or making a behavior-changing refactor. Ask the user before skipping for throwaway prototypes, generated code, or config-only changes
---

# Test-Driven Development

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing. So no production code without a failing test first. Wrote code before the test? Delete it and start over.

## Red-Green-Refactor

### RED — Write Failing Test

Write one minimal test showing what should happen:

- One behavior per test, with a name describing it
- Assert observable behavior, not what the code under test just computed (a tautological assertion passes for any implementation)
- Real code, not mocks. If a mock is unavoidable, assert real behavior through it, not the mock itself, and keep test-only methods out of production classes.

### Verify RED — Watch It Fail

Run the test. Confirm:
- Test fails (not errors from typos/imports)
- Failure message matches expected missing behavior
- Test passes when feature exists? You're testing existing behavior — fix the test

### GREEN — Minimal Code

Write only what the failing test demands: the simplest code that makes it pass.

### Verify GREEN — Watch It Pass

Run the test. Confirm the new test passes and all other tests still pass. Test fails? Fix code, not test. Other tests fail? Fix now.

### Verify Strength — Mutation Check

Target the changed files only.

- **Repo has a mutation tool** (mutmut, Stryker, PITest): run it on those files.
- **No tool:** plant 3-5 small bugs by hand in the changed code (flip a condition, shift a boundary, drop a return value). Run the tests after each; at least one must fail. Revert each bug before the next. Do not install a tool.

Done when every surviving mutant is either killed by a new assertion (re-run to confirm) or is equivalent (no observable change) and noted in the final summary.

### REFACTOR — Clean Up

Only after green. Refactoring changes structure only; tests stay green throughout: remove duplication, improve names, extract helpers. Then return to RED for the next behavior.

## Rationalizations and Blockers

| Excuse or problem | Response |
|--------|---------|
| "I'll test after" | Tests passing immediately prove nothing. |
| "Need to explore first" | Fine. Throw away the exploration, start with TDD. |
| Don't know how to test | Write the assertion first. Design the API you wish existed. |
| Test too complicated, setup huge | The design is too complicated. Simplify the interface, extract helpers. |
| Must mock everything | Code too coupled. Use dependency injection. |

## Before Marking Work Complete

Every new function has a test that failed first, and every error path in the diff has an assertion.

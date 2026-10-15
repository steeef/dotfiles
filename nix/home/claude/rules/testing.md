---
paths:
  - "**/test_*.py"
  - "**/*_test.py"
  - "**/tests/**"
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.spec.ts"
---

# Mutation testing for AI-written tests

- Coverage proves lines ran, not that tests catch bugs. After writing or changing tests, run the repo's mutation tool on the changed files only. Full runs take minutes to hours.
- Tools: `mutmut` (Python), Stryker (JS/TS), PITest (Java). Use what the repo already configures; don't add one without asking.
- Don't call the work done with surviving mutants you can't explain. Kill each with a new assertion, or note it as equivalent (no observable change).
- No tool configured: plant 3-5 small bugs by hand in the changed code, confirm the tests fail on each, revert each. Never put mutation runs in pre-commit or `prek`; too slow.

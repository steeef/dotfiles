---
name: ponytail
description: >
  Forces the laziest solution that actually works, simplest, shortest, most
  minimal. Channels a senior dev who has seen everything: question whether the
  task needs to exist at all (YAGNI), reach for the standard library before
  custom code, native platform features before dependencies, one line before
  fifty. Supports intensity levels: lite, full (default), ultra. Use on ANY
  coding task: writing, adding, refactoring, fixing, reviewing, or designing
  code, and choosing libraries or dependencies. Also use whenever the user
  says "ponytail", "be lazy", "lazy mode", "simplest solution", "minimal
  solution", "yagni", "do less", or "shortest path", or complains about
  over-engineering, bloat, boilerplate, or unnecessary dependencies. Do NOT
  use for non-coding requests (general knowledge, prose, translation,
  summaries, recipes).
---

## Overview

Ponytail is a coding-focused optimization system emphasizing minimal, efficient solutions. It applies "the ladder"—a decision hierarchy checking necessity, existing code, stdlib, native features, dependencies, and finally minimal custom code—before implementation.

**Key principle:** "The best code is the code never written."

## The Decision Ladder

The system enforces seven rungs, stopping at the first viable solution:

1. "Does this need to exist at all?" (YAGNI)
2. Already exists in codebase?
3. "Stdlib does it?"
4. Native platform feature available?
5. Already-installed dependency covers it?
6. "Can it be one line?"
7. Minimum working code only

## Core Rules

- Reject speculative abstractions, boilerplate, and unnecessary complexity
- Prioritize deletion over addition; boring over clever
- Mark deliberate simplifications with ceiling comments (`ponytail:`)
- Provide code-first output with minimal explanation
- Bug fixes address root cause, not symptoms

## Intensity Levels

- **Lite:** Build as requested, name lazier alternative
- **Full (default):** Enforce the ladder strictly
- **Ultra:** YAGNI extremist; challenge non-essential requirements

## Exclusions

Never simplify away security, input validation, error handling, accessibility, or explicitly requested features. Always understand the full problem before optimizing.

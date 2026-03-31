# Design Discussion Template

Use this structure for the design discussion document.

```markdown
---
date: YYYY-MM-DD
author: <user name or claude>
status: draft
ticket: <ticket-id if applicable>
research: <path to research document>
---

# Design Discussion: <Topic>

## Current State

What exists today, grounded in research findings. Include file:line references.

- How the relevant system works now
- Key components and their relationships
- Current limitations or pain points (factual, not opinion)

## Desired End State

What we are building toward. Derived from ticket acceptance criteria and user input.

- Target behavior
- Success criteria
- Scope boundaries (what is explicitly out of scope)

## Patterns to Follow

Existing codebase patterns that this change should mirror. Each with file:line reference.

- **Pattern name**: Description. See `path/to/file.ext:42`
- **Pattern name**: Description. See `path/to/file.ext:87`

## Resolved Decisions

Choices made during this discussion, with rationale.

| Decision | Choice | Rationale |
|----------|--------|-----------|
| <what was decided> | <chosen option> | <why> |

## Open Questions

Remaining unknowns that need resolution before planning.

- <question> — impact if unresolved: <what breaks or blocks>
```

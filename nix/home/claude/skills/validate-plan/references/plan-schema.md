# Plan Schema

Shared by `mk-plan`, `do-plan`, `iterate-plan`, and `validate-plan`. This file is the single source of truth.

Path: `<thoughts project>/plans/YYYY-MM-DD-[KEY-]slug.md`.

## Frontmatter

```yaml
---
title: "Plan: <title>"
created: YYYY-MM-DD
status: draft | in-progress | done
type: implementation-plan
repos:              # target repos; file and command checks run here, not in the thoughts repo
  - org/repo
ticket: KEY-123     # optional
---
```

## Phases

Each phase is a `### Phase N: Title` heading, a short prose scope, then a `Verify:` list:

```markdown
### Phase 1: Title

What changes and why.

Verify:

- [ ] `just check` passes
- [ ] manual: dashboard shows the new panel
```

- A backticked command is an automated check. Run it in the target repo.
- A `manual:` prefix marks a human check. Never tick it without the user's confirmation.
- Number phases from 0 or 1 with no gaps. Renumber on insert or remove, and keep each phase's `Verify:` lines with it.

## Legacy

`### Task N:` plans stay supported. Treat each task like a phase.

# Structure Outline Schema

Use this structure for the outline document.

```markdown
---
date: YYYY-MM-DD
author: <user name or claude>
status: draft
ticket: <ticket-id if applicable>
design: <path to design discussion document>
---

# Structure Outline: <Topic>

## Overview

1-2 sentences describing the total scope and number of slices.

## Vertical Slices

### Slice 1: <Name — describes user-visible value>

**Delivers**: What the user can do after this slice is complete.

**Layers touched**:
- Data: <schema changes, migrations>
- Logic: <business rules, services>
- API: <endpoints, contracts>
- UI: <components, pages>

**Key files**:
- `path/to/file.ext` — <what changes>

**Checkpoint**: How to verify this slice works independently.
- <concrete verification step>

### Slice 2: <Name>

(Same structure as Slice 1)

### Slice N: <Name>

(Continue for each slice)

## Dependencies

Which slices must complete before others can start.

```
Slice 1 (no dependencies)
Slice 2 → depends on Slice 1
Slice 3 → depends on Slice 1
Slice 4 → depends on Slice 2 + 3
```

## Verification Checkpoints

Summary of how to confirm the full implementation is complete.

| Slice | Checkpoint | Method |
|-------|-----------|--------|
| 1 | <what to verify> | <how: test, manual, command> |
| 2 | <what to verify> | <how> |
```

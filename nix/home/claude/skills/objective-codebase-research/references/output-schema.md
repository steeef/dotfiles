# Research Document Output Schema

Use this template for the research output document.

```markdown
---
date: YYYY-MM-DD
researcher: claude
git_commit: <short-sha>
branch: <branch>
repository: <repo-name>
topic: <research-topic>
tags: [<relevant>, <tags>]
status: complete
---

# Research: <Topic>

## Problem Statement

<Problem statement from input — what is broken or missing>

## Acceptance Criteria

<Acceptance criteria from input — what "done" looks like>

## Research Questions

1. <Original question>
2. <Original question>
...

## Summary

<2-3 paragraph overview of key findings across all questions>

## Detailed Findings

### Q1: <Research Question>

<Findings with file:line references. Trace code flows. Document what exists.>

### Q2: <Research Question>

<Findings with file:line references.>

(Continue for each question)

## Code References

| File | Lines | Purpose |
|------|-------|---------|
| path/to/file.ext | 10-50 | Description of relevance |

## Open Questions

- <Unresolved questions discovered during research>
- <Areas that need further investigation>
```

---
description: Resume work from previous handoff documents in new sessions
allowed-tools:
  - Read
  - Bash(git:*)
  - TodoWrite
---

# Resume Work from Handoff Document

> Based on: https://github.com/humanlayer/humanlayer/blob/main/.claude/commands/resume_handoff.md

This command resumes work based on a handoff document containing prior context and learnings.

## Input

The handoff file path is provided as: `$ARGUMENTS`

If no path is provided, prompt the user to provide one:
- Ask for the path to the handoff file (e.g., `thoughts/shared/handoffs/2025-01-08_13-55-22_add-auth.md`)

## Three-Phase Process

### Phase 1: Analysis

1. **Read the complete handoff document** - Do NOT use a sub-agent to read critical files
2. **Read all referenced artifacts** - Any documents, plans, or specs mentioned in the handoff
3. **Extract key information**:
   - Task statuses (completed, in progress, planned)
   - Learnings and insights
   - Recent changes made
   - Next steps identified
4. **Verify current state** - Check that the codebase state matches what's documented:
   - Run `git status` to see current branch and changes
   - Run `git log -1` to verify commit matches
   - Spot-check a few of the documented changes exist

### Phase 2: Presentation

Present a synthesized analysis to the user covering:

```markdown
## Handoff Analysis

### Original Tasks
{List of tasks from handoff with their documented statuses}

### Validated Learnings
{Key learnings that still apply, verified against current codebase state}

### Verified Changes
{Recent changes that were confirmed to exist in the codebase}

### Artifact Review
{Summary of referenced documents/plans that were read}

### Recommended Actions
{Prioritized list of next steps based on handoff guidance}

### Potential Issues
{Any discrepancies between handoff state and current state, or blockers identified}
```

**Wait for user confirmation before proceeding to implementation.**

### Phase 3: Implementation

After user confirmation:

1. **Create a prioritized todo list** using TodoWrite based on the Action Items & Next Steps
2. **Begin work** on the highest priority items
3. **Continuously reference** the handoff document for:
   - Documented patterns and approaches
   - Known pitfalls to avoid
   - Architectural decisions to follow

---

## Key Principles

- **Always verify** - Don't assume the handoff state matches current reality
- **Present before acting** - Get user buy-in before starting work
- **Apply learnings** - The handoff contains valuable context; use it
- **Read directly** - Do NOT delegate critical file reading to sub-agents
- **Maintain continuity** - Use todo list to track progress against handoff goals

---

## Common Scenarios

### Clean Continuation
Handoff state matches current state exactly. Proceed with documented next steps.

### Diverged Codebase
Changes have been made since handoff. Note differences, ask user how to reconcile.

### Incomplete Work
Previous work was interrupted. Identify where to resume based on task statuses.

### Stale Handoff
Handoff is outdated. Recommend creating a fresh assessment rather than following old guidance.

---
name: checkpoint
description: Checkpoint the active ticket mid-session (write mode) or resume from a prior checkpoint (resume mode). Write - update its in-progress thoughts doc, post a Jira progress comment, and sync that ticket's thoughts files; use when the user says "checkpoint this", "save progress", "log where we are", or "add jira comment, update thoughts, sync thoughts". Resume - read the ticket, all its comments, and its linked thoughts; use when the user says "continue from checkpoint", "resume from checkpoint", or "pick up from the checkpoint" and names or implies a Jira ticket. A lone comment goes to conductor:jira-management, a lone sync to conductor:thoughts-sync, an end-of-session handoff to conductor:create-handoff.
allowed-tools:
- Skill
- Read
- Bash
- Grep
- Glob
---

# Checkpoint

Two modes: **resume** ("continue from checkpoint") and **write** (everything
else). Resume is read-only.

## Resume workflow

1. Detect the ticket: key in the user's message, else session context or
   branch name. If ambiguous, ask.
2. Read the ticket and every comment via
   `Skill(skill='conductor:jira-management')` (read operation, comments
   included). Checkpoint comments are the `Done/Findings/Next` log.
3. Collect thoughts: follow thoughts links in the description and comments,
   and find docs whose path contains the ticket key via
   `Skill(skill='conductor:thoughts-discovery')`. Read the active
   plan/research/tech-plan in full.
4. Report in 5 lines or fewer: latest `Next:` from the newest checkpoint
   comment, open decisions, active thoughts doc path. Then stop and wait; do
   not start implementing.

## Write workflow

### Step 1: Detect the ticket

Use session context (injected at startup), branch name, or a `[A-Z]+-\d+`
pattern already present in the conversation. If ambiguous, ask before
proceeding.

### Step 2: Draft the progress summary

Summarize this session's work on the ticket in this shape, under 1,500
characters (Jira comments are a short log):

```text
Done: ...
Findings/decisions: ...
Next: ...
```

Reuse it as-is for Steps 3 and 4 - don't draft two different summaries.

### Step 3: Update the active thoughts doc

Identify whichever plan/research/tech-plan doc is already the active
artifact for this ticket in the thoughts repo (the doc already open or being
worked on this session - not a new handoff or session-log doc). Search file
paths and file contents for the ticket key, and read the ticket description
and comments for thoughts links. Only when all three come up empty, say none
exists, skip this step, and continue. Edit it in place via `Bash`
(`sed -i`, `printf '…' >>`; no heredocs or `&&` chains, the guard rejects
them as too complex), not `Edit`/`Write`: in a worktree session the built-in
isolation rejects `Edit`/`Write` on the thoughts clone. Check off completed
items, append a status/progress note under the relevant phase. The doc's
path must contain the ticket key so Step 5 picks it up.

### Step 4: Add the Jira comment

Call `Skill(skill='conductor:jira-management')` with an add-comment operation
for the detected ticket, using the summary from Step 2. This is a
Conductor-originated comment - prefix it `🤖 From Conductor:` per this
project's convention. If the call fails, stop and report; skip Step 5 so
the thoughts doc and Jira stay in step.

### Step 5: Sync thoughts

Run the bundled script with the thoughts dir from session context, the
ticket key, and a commit message. `projectId` is the top-level thoughts
subdir holding the Step 3 doc (e.g. `tatari-skills` for
`<thoughts>/tatari-skills/plans/...`):

```bash
"${CLAUDE_SKILL_DIR}/scripts/sync_ticket_thoughts.sh" <thoughts-dir> <TICKET> "[<projectId>] <TICKET>: <short summary>"
```

The script commits every changed thoughts file whose path contains the ticket
key, then runs `pull --rebase --autostash` and `push`. Other uncommitted
files stay in the working tree. On a rebase conflict it exits nonzero;
report the conflict to the user.

Ticket-scoped, unlike `conductor:thoughts-sync`, which commits the whole
thoughts repo.

### Step 6: Report

State what completed: comment posted (link), thoughts files committed and
pushed (paths). Name any skipped or failed step.

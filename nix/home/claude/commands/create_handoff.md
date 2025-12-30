# Create Handoff

> Based on: https://github.com/humanlayer/humanlayer/blob/main/.claude/commands/create_handoff.md

You are tasked with writing a handoff document to hand off your work to another agent in a new session. You will create a handoff document that is thorough, but also **concise**. The goal is to compact and summarize your context without losing any of the key details of what you're working on.

## Process

### 1. Filepath & Metadata

Create your file under `thoughts/shared/handoffs/YYYY-MM-DD_HH-MM-SS_description.md`, where:
- YYYY-MM-DD is today's date
- HH-MM-SS is the hours, minutes and seconds based on the current time, in 24-hour format
- description is a brief kebab-case description of the work

Example: `thoughts/shared/handoffs/2025-01-08_13-55-22_add-user-authentication.md`

Gather git metadata using these commands:
- Branch: `git branch --show-current`
- Commit: `git rev-parse --short HEAD`
- Repository: `basename $(git rev-parse --show-toplevel)`

### 2. Write the Handoff Document

Structure the document with YAML frontmatter followed by content:

```markdown
---
date: [Current date and time with timezone in ISO format]
git_commit: [Current commit hash]
branch: [Current branch name]
repository: [Repository name]
topic: "[Feature/Task Name] Implementation"
tags: [implementation, relevant-component-names]
status: complete
last_updated: [Current date in YYYY-MM-DD format]
type: handoff
---

# Handoff: {very concise description}

## Task(s)
{Description of the task(s) you were working on, along with the status of each (completed, work in progress, planned/discussed). If you are working on an implementation plan, make sure to call out which phase you are on. Reference the plan document and/or research documents you are working from, if applicable.}

## Critical References
{List any critical specification documents, architectural decisions, or design docs that must be followed. Include only 2-3 most important file paths. Leave blank if none.}

## Recent Changes
{Describe recent changes made to the codebase in file:line syntax}

## Learnings
{Describe important things that you learned - e.g. patterns, root causes of bugs, or other important pieces of information someone picking up your work should know. Consider listing explicit file paths.}

## Artifacts
{An exhaustive list of artifacts you produced or updated as filepaths and/or file:line references - e.g. paths to feature documents, implementation plans, etc that should be read in order to resume your work.}

## Action Items & Next Steps
{A list of action items and next steps for the next agent to accomplish based on your tasks and their statuses}

## Other Notes
{Other notes, references, or useful information - e.g. where relevant sections of the codebase are, where relevant documents are, or other important things you learned that you want to pass on but that don't fall into the above categories}
```

### 3. Create Directory and Save

1. Create the `thoughts/shared/handoffs/` directory if it doesn't exist
2. Write the handoff document to the filepath

---

## Response

Once completed, respond to the user with:

```
Handoff created! You can resume from this handoff in a new session with:

/resume_handoff thoughts/shared/handoffs/{filename}.md
```

---

## Additional Notes & Instructions

- **More information, not less**. This template defines the minimum of what a handoff should be. Always feel free to include more information if necessary.
- **Be thorough and precise**. Include both top-level objectives and lower-level details as necessary.
- **Avoid excessive code snippets**. While a brief snippet to describe some key change is important, avoid large code blocks or diffs. Prefer using `/path/to/file.ext:line` references that an agent can follow later.

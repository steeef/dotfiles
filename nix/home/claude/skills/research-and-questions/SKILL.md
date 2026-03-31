---
name: research-and-questions
description: Chain extract-research-questions into objective-codebase-research. Convenience wrapper for the Q+R phases of QRSPI.
allowed-tools:
- Skill
- Read
- Glob
- Grep
- Bash(acli:*)
---

# Research and Questions

Convenience wrapper that chains the Question and Research stages of the QRSPI workflow.

## Purpose

Reduces the workflow from 7 manual steps to 5 by combining:
1. `/extract-research-questions` — generates 5-10 research questions from a ticket
2. `/objective-codebase-research` — investigates those questions in the codebase

## Workflow

### Step 1: Accept Input

Determine input type:
- **Jira ID** (matches `[A-Z]+-\d+`): Fetch ticket via `acli jira workitem view <ID>` and use the output
- **File path** (exists on disk): Read the file
- **Pasted content / free text**: Use directly

### Step 2: Extract Questions

Call `Skill(skill='extract-research-questions')` with the user's input.

The skill will produce:
- Problem statement
- Acceptance criteria
- 5-10 numbered research questions

### Step 3: Run Codebase Research

Call `Skill(skill='objective-codebase-research')` with the output from Step 2.

Pass the problem statement and acceptance criteria — NOT any proposed solution from the ticket.

### Step 4: Report

Tell the user where the research document was saved and summarize the key findings.

The research document is now ready for `/draft-design-discussion`.

---
name: objective-codebase-research
description: Answer numbered research questions about how the current codebase works, with file:line evidence and no recommendations. Input is a problem statement, acceptance criteria, and questions.
context: fork
allowed-tools:
- Task(Explore)
- Read
- Glob
- Grep
- Write
- Bash(git:*)
- LSP
---

# Objective Codebase Research

Document what exists. The input is a problem statement, acceptance criteria, and 5-10 numbered questions, passed as the argument. Ignore any proposed solution; list it under Open Questions as out of scope.

Report only what the code does, with `file:line`. Describe, never prescribe: no critique, improvements, or recommendations.

## Steps

1. Read every file named in the input in full, paging if over the read limit.
2. Launch one `Explore` agent per question (group closely related ones), in parallel. Each prompt: the question, the problem statement (not a solution), and "Report file paths, code flows, and patterns with file:line. Describe only; no recommendations."
3. Use LSP to trace symbols the agents surface.
4. Get `git rev-parse --short HEAD`, the branch, and the repo name. Fill `references/output-schema.md`, and save it as `YYYY-MM-DD-topic-slug.md` under `research/` in the thoughts project found via `.thoughts.json` `THOUGHTS_ROOT` (walk up from cwd), else the repo's `docs/`. Sync with `thoughts:sync`.
5. Present the key findings, critical file references, and open questions.

Done when every question has a finding with at least one `file:line`, or is listed under Open Questions. Set `status: partial` if any question is open.

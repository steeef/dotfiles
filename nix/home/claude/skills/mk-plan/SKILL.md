---
name: mk-plan
description: Write a phased implementation plan from a Jira ticket, research doc, or free-text request. Use when the user wants a plan before any code is written, e.g. "plan this ticket" or "write an implementation plan". Writing the plan is the deliverable; it does not implement.
allowed-tools:
- Read
- Write
- Edit
- Glob
- Grep
- Skill
- Agent
- Bash(sed:*)
---

# Make Plan

`/mk-plan <ticket key | research doc path | description>`

`do-plan` implements; this skill stops at the written plan.

## Steps

1. **Resolve input.** A ticket key: read it with `jira:manage`. A path: read it fully. Free text: use as is. Find the thoughts project from `.thoughts.json` `THOUGHTS_ROOT` (walk up from cwd); if not found, ask.
2. **Settle open decisions.** Run `mattpocock-skills:grilling` on anything ambiguous. Skip when the request is already unambiguous.
3. **Gather facts.** Run `thoughts:discover` and cite existing research. Otherwise write numbered questions for what the plan must know, then run `objective-codebase-research` with the problem statement, acceptance criteria, and questions. Name the target repos.
4. **Write the plan** to `<thoughts project>/plans/YYYY-MM-DD-[KEY-]slug.md` in the format of `~/.claude/skills/validate-plan/references/plan-schema.md`, with `status: draft`. Schema frontmatter wins; take only `created` and git fields from `thoughts:spec-metadata`. Every phase ends with a `Verify:` list, or `Verify: none - <reason>`. Under a worktree pin, Write on the thoughts clone is rejected; write via Bash instead.
5. **Review.** Spawn the `llm:opus-reviewer` agent with the decision point, approach, and plan path. At most 2 rounds.
6. **Report** the plan path and open risks.

Done when the plan file exists, the count of `### Phase` headings equals the count of `Verify:` lines, `repos:` is set, and each review finding is fixed or listed under Open risks.

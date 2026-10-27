# GitHub pull requests

Applies whenever creating, editing, or referencing a PR (`pr:create`, `gh pr`, or the API).

## Process

- For GitHub remotes, always create PRs in draft mode first (`--draft`). For Forgejo remotes, draft mode is unsupported via CLI — create as open.
- Leave a PR in draft through any blocked/pending state; surface the blocker and ask before doing anything (`gh pr ready`, merging) to route around it. Draft status is a deliberate gate.
- Never request reviewers (`--reviewer`, `gh pr edit --add-reviewer`) unless asked. CODEOWNERS routes review; a plan or ticket listing reviewers is not an instruction to request them.
- Prefix comments on GitHub PRs or issues with ``:robot: From Claude `<skill>`:``, naming the skill that posts (e.g. ``:robot: From Claude `pr:review`:``). Use `:robot: From Claude Code:` when no skill is posting.
- Always include the full PR URL, not just "PR #123", whenever creating, updating, or referencing a PR — surface it directly in chat as a clickable link the user doesn't have to dig for.

## Description format

- Repo template wins: if the repo has one, use it as-is. Keep the Jira key on line 1 where the template has it.
- No template: Jira key alone on line 1 (omit if no ticket), blank line, then the sections `pr:create` enforces (Why / What changed / How to review / Validation / Risk). If the repo uses Terraform, include the plan in a `<details>` block; for Terraform, migrations, or other hard-to-undo changes, add one rollback line under Validation.
- Write for the audience, usually CODEOWNERS doing a merge-gate review. Tailor detail to who is reading (an SRE IC needs different context).
- Brief: short summary plus essentials. Skip padding sections and diff-by-diff restatement.
- Write PR/issue description and comment body prose one paragraph per line — GitHub renders in-paragraph newlines as `<br>` in these fields, so column-wrapping shows as broken lines.

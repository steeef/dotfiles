# GitHub pull requests

Applies whenever creating, editing, or referencing a PR (conductor's `pr` skill, `gh pr`, or the API).

## Process

- For GitHub remotes, always create PRs in draft mode first (`--draft`). For Forgejo remotes, draft mode is unsupported via CLI — create as open.
- Leave a PR in draft through any blocked/pending state; surface the blocker and ask before doing anything (`gh pr ready`, merging) to route around it. Draft status is a deliberate gate.
- Prefix comments on GitHub PRs or issues with `:robot: From Claude Code:`.
- Always include the full PR URL, not just "PR #123", whenever creating, updating, or referencing a PR — surface it directly in chat as a clickable link the user doesn't have to dig for.

## Description format

- Repo template wins: if the repo has one, use it as-is. Check both `.github/PULL_REQUEST_TEMPLATE.md` and lowercase `.github/pull_request_template.md` (conductor's `pr` skill only checks uppercase). Keep the Jira key on line 1 where the template has it.
- No template: Jira key alone on line 1 (omit if no ticket), blank line, then these sections in order:
  - **Why** — one or two sentences of purpose.
  - **What** — what changed; bulleted list when more than one change.
  - **Testing** — how it was tested and what was found, especially anything that deviated from expected. If the repo uses Terraform, include the plan in a `<details>` block.
  - **Validation** — what to check after merge. For Terraform, migrations, or other hard-to-undo changes, add one rollback line.
- Write for the audience, usually CODEOWNERS doing a merge-gate review. Tailor detail to who is reading (an SRE IC needs different context).
- Brief: short summary plus essentials. Skip padding sections and diff-by-diff restatement.
- Write PR/issue description and comment body prose one paragraph per line — GitHub renders in-paragraph newlines as `<br>` in these fields, so column-wrapping shows as broken lines.
- Conductor's `🤖 Created with Conductor` footer stays on PR bodies.

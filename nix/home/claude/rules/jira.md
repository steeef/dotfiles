# Writing Jira tickets

Applies whenever creating or editing a Jira ticket's title/description/comments
(conductor's jira-management skill, acli, or Atlassian MCP directly). Sources:
[How to write a useful Jira ticket](https://community.atlassian.com/forums/Jira-articles/How-to-write-a-useful-Jira-ticket/ba-p/2147004)
and [Good History Documentation](https://github.com/scottidler/devops/blob/main/docs/best-practices/good-history-documentation.md)
(Scott Idler) — where the two disagree, Scott's precedes. Naming guidelines
below are guidelines, not gates; don't rename existing tickets to match.

- **Title**: imperative verb, action-oriented, 4-7 words, Title Case. Test: "To
  complete this ticket, I need to [TITLE]" must read naturally and stay concise.
  Spike titles start with "Investigate" where it fits. A leading `service-name:`
  or `[Scope]` prefix is fine and keeps the service's actual casing.
- **Story (why)**: "We need to [TASK] from [RESOURCE] in order for [USER] to
  [ACTION]." State purpose and beneficiary, not just the task.
- **Acceptance criteria (what)**: SMART, descriptive, achievable — the Definition
  of Done. Omit implicit requirements (e.g. "write unit tests") that apply to
  every ticket.
- **Resources (how)**: link planning docs, designs (Figma), tech specs, Slack
  threads/email subjects, points of contact. Long material (runbooks, execution
  plans, agent transcripts) belongs here too, not pasted into the description or
  a comment — link it with a short summary.
- **Linked issues**: use Jira's link-issues feature for `blocks`/`is blocked by`;
  surface dependencies up front, don't bury them in the description. Check the
  ticket's existing links first and dedupe: don't add a link that already
  exists (either direction) or a second link type covering the same relation
  (e.g. both `relates to` and `blocks` between the same pair) — pick the one
  link type that's actually true and drop the rest.
- **Epic**: assign to the relevant epic for context.
- **Blocked tickets**: flag/label clearly so they're visible in board swimlanes.
- **Keep the description current**: when the plan, root cause, or status
  changes, edit the description — don't add a comment saying it's wrong. Never
  stack a correction (a comment reversing an earlier one, both left live); fix
  the description, then collapse the obsolete comment to one line ("Superseded;
  see description") or delete it. No edit-history notes in ticket text either
  (e.g. "kept numbered this way so earlier comments still line up") — that's a
  sign the ticket needs a rewrite, not a workaround.
- **Comments are a short log**: decisions, blockers, PR links — a few sentences
  each, not a session transcript.
- **Rough size guide**: description under ~3,500 characters, any single comment
  under ~1,500 — reader gives up before your last paragraph. AI-drafted text
  doesn't get a pass: whoever posts it owns trimming it to what the next reader
  needs.

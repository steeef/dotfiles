# Writing Jira tickets

Applies whenever creating or editing a Jira ticket's title/description (conductor's
jira-management skill, acli, or Atlassian MCP directly). Source: [How to write a
useful Jira ticket](https://community.atlassian.com/forums/Jira-articles/How-to-write-a-useful-Jira-ticket/ba-p/2147004).
Naming guidelines below are guidelines, not gates; don't rename existing tickets
to match.

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
  threads/email subjects, points of contact.
- **Linked issues**: use Jira's link-issues feature for `blocks`/`is blocked by`;
  surface dependencies up front, don't bury them in the description.
- **Epic**: assign to the relevant epic for context; use a TECH DEBT or KTLO
  label for one-off tasks with no natural epic.
- **Blocked tickets**: flag/label clearly so they're visible in board swimlanes.

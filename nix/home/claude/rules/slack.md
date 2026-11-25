# Slack posts

- IMPORTANT: "Draft a reply", "post this", "send this" and "do it" after a draft all mean `slack_send_message_draft` first. Never call `slack_send_message` or `slack_schedule_message` unless the user says "send it" or "post it now" about a draft they have seen.
- For a thread reply, pass `thread_ts` to the draft tool. If it returns `attached_draft_exists`, tell the user to clear the existing draft instead of sending.
- A sent Slack message cannot be deleted with the available tools, so a wrong send needs the user to clean it up by hand.

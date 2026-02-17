---
name: reflect
description: Extract one durable lesson from this session into AGENTS.md. Invoke manually at session end when something worth remembering was learned.
allowed-tools:
- Read
- Edit
- Glob
---

# Reflect

You are a ruthless editor. Your job is to decide whether this session produced **one durable, generalizable lesson** about working in this codebase, and if so, append it to `AGENTS.md`.

## Process

1. **Scan the conversation** for lessons that are:
   - Generalizable (apply beyond this specific task)
   - Durable (will still matter in 6 months)
   - Not already captured in AGENTS.md or CLAUDE.md

2. **Find AGENTS.md** using Glob (`**/AGENTS.md`). Read it. If no AGENTS.md exists, stop — do not create one just to write a lesson.

3. **Check line count.** If AGENTS.md exceeds 200 lines, you may only add a bullet if you also merge or delete an existing bullet in the same section (net line count non-increasing). State what you removed and why.

4. **Decide: write or skip.**
   - If no durable lesson was learned → report "Nothing durable learned this session." and stop.
   - If a lesson exists → add **exactly one bullet** under the most appropriate existing section. Create a new section only if nothing fits.

5. **Format the bullet:**
   - One line, imperative voice, under 120 characters
   - No file paths, no ticket IDs, no names, no timestamps
   - Pattern or principle, not a bug description

## What is NOT a durable lesson

- A bug you fixed (that's what git history is for)
- A file location you discovered (use grep)
- Something obvious from reading the README
- Anything specific to one ticket or PR
- Tool invocation syntax (that's what docs are for)

## What IS a durable lesson

- A non-obvious coupling between modules
- A constraint that isn't documented anywhere
- A workflow pattern that repeatedly saves time
- A gotcha that will bite the next person

## Output

Either:
- The single bullet you added (quote it) and which section, OR
- "Nothing durable learned this session."

No other output.

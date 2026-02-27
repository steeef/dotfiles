---
name: reflect
description: Extract one durable lesson from a session into AGENTS.md. Invoke with a session ID to review a past session.
allowed-tools:
- Read
- Edit
- Glob
- Bash(python3:*)
---

# Reflect

You are a ruthless editor. Your job is to decide whether a session produced **one durable, generalizable lesson** about working in this codebase, and if so, append it to `AGENTS.md`.

## Usage

- `/reflect` — scan the current conversation
- `/reflect <session-id>` — load and scan a past session by UUID

## Mode detection

If an argument matching a UUID pattern (`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`) is provided, use **Historical Session Loading** below. Otherwise, skip straight to the **Process** section using the current conversation.

## Historical Session Loading

When a session ID is provided, load the transcript before proceeding to Process.

### Step 1 — Locate the session file

Find the JSONL file across all project directories:

```bash
python3 -c "
import glob, sys
sid = sys.argv[1]
matches = glob.glob(f'{__import__(\"os\").path.expanduser(\"~\")}/.claude/projects/*/{sid}.jsonl')
if matches:
    print(matches[0])
else:
    print('NOT_FOUND')
" SESSION_ID
```

If `NOT_FOUND`, report "Session SESSION_ID not found." and stop.

### Step 2 — Extract meaningful text

Extract only user text and assistant text blocks (skip thinking, tool_use, tool_result, progress, file-history-snapshot, and queue-operation entries):

```bash
python3 -c "
import json, sys, os
path = sys.argv[1]
texts = []
with open(path) as f:
    for line in f:
        entry = json.loads(line)
        t = entry.get('type')
        if t not in ('user', 'assistant'):
            continue
        msg = entry.get('message', {})
        if not isinstance(msg, dict):
            continue
        content = msg.get('content', [])
        if isinstance(content, str):
            texts.append(content)
        elif isinstance(content, list):
            for block in content:
                if isinstance(block, dict) and block.get('type') == 'text':
                    texts.append(block['text'])
combined = '\n---\n'.join(texts)
# Cap at 50K chars (keep tail — recent conversation is more relevant)
if len(combined) > 50000:
    combined = combined[-50000:]
print(combined)
" SESSION_FILE_PATH
```

If the output is empty, report "No text content in session SESSION_ID." and stop.

### Step 3 — Derive the project path

The session's `cwd` field tells you the project directory. Extract it:

```bash
python3 -c "
import json, sys
with open(sys.argv[1]) as f:
    for line in f:
        entry = json.loads(line)
        if entry.get('type') in ('user', 'assistant') and 'cwd' in entry:
            print(entry['cwd'])
            break
" SESSION_FILE_PATH
```

Use this path as the root for finding AGENTS.md in step 2 of Process (instead of the current working directory).

### Step 4 — Proceed to Process

Use the extracted text as the "conversation" to scan in Process step 1.

## Process

1. **Scan the conversation** (current session or loaded transcript) for lessons that are:
   - Generalizable (apply beyond this specific task)
   - Durable (will still matter in 6 months)
   - Not already captured in AGENTS.md or CLAUDE.md

2. **Find AGENTS.md** using Glob (`**/AGENTS.md`) starting from the project directory (current working directory, or the `cwd` from a historical session). Read it. If no AGENTS.md exists, stop — do not create one just to write a lesson.

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

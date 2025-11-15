# OpenCode Plugin Migration – Progress

## Current Focus
- Phase 1: Core safety plugin (`global-safety.ts`) for OpenCode.

## Work Completed
- Created `opencode/plugin/` directory for OpenCode plugins.
- Implemented `opencode/plugin/global-safety.ts` as a monolithic safety plugin that:
  - Hooks `tool.execute.before` and `tool.execute.after` using the real `@opencode-ai/plugin` types.
  - Enforces bash safety for `rm`, dangerous `git add`, `git checkout`, destructive `kubectl` and `terraform` commands, `.env` access, and `grep` (with `rg` suggestion).
  - Adds a file-size guard for the `read` tool using a streaming line-count with thresholds:
    - 500 lines for the main agent.
    - 10,000 lines when `.opencode_in_subtask.flag` exists.
  - Blocks writes/edits targeting `CLAUDE.md`, instructing to edit `AGENTS.md` and symlink instead.
  - Integrates with the existing `~/.bin/format.sh` via `tool.execute.after` for write/edit tools by:
    - Tracking per-call arguments using `callID`.
    - Deriving touched files from `filePath`/`file_path`/`files` arguments.
    - Streaming a JSON payload (`{"tool_input": {"file_path": "<fullPath>"}}`) into `format.sh` on stdin.
    - Treating formatting as best-effort (logs failures, does not block tools).

## Testing Status
- No automated tests written yet.
- No manual verification in a live opencode session has been done yet.
- Planned tests (not implemented yet):
  - Bash safety: verify blocking of `rm`, `git add .`, `kubectl delete`, `terraform apply`, `.env` usage, and `grep`.
  - File-size guard: verify 500-line and 10,000-line thresholds, including behavior with the subtask flag.
  - CLAUDE.md guard: verify that writes/edits to any `CLAUDE.md` path are blocked while `AGENTS.md` is allowed.
  - Auto-formatting: confirm `format.sh` runs after write/edit operations and does not throw even if it fails.

## Open Questions / Follow-Ups
- Confirm actual tool identifiers (`bash`, `read`, `write`, `edit`) via a small debug plugin or logging in a test project.
- Confirm shape of tool arguments for each tool in opencode (particularly bash and write/edit) to ensure we are reading `output.args` correctly.
- Decide whether to keep `.opencode_in_subtask.flag` as the long-term mechanism for sub-agent detection or to move to in-memory/plugin-level state once Phase 2 is implemented.

## Next Recommended Steps
- Phase 2: Implement `task-context.ts` to manage `.opencode_in_subtask.flag` creation/cleanup around the Task tool.
- Add a minimal debug plugin (or temporary logging in `global-safety.ts`) to log `input.tool` and `output.args` for common tools, validating assumptions from the migration plan.
- Once behavior is confirmed, add Bun-based unit tests under an appropriate test directory (e.g., `opencode/plugin/__tests__/`) to cover bash safety, file-size guarding, CLAUDE.md blocking, and format integration.
- After tests and validation, wire plugin enablement into the Home Manager module that renders `~/.config/opencode/opencode.json` and apply via `hms`.

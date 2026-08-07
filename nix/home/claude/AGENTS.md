# nix/home/claude

Home Manager module for Claude Code: generates `~/.claude/CLAUDE.md`, rules,
skills, agents, and settings from this directory.

## What

- `memory.md` → `~/.claude/CLAUDE.md` (symlink). Cross-cutting instructions
  loaded into every session.
- `rules/` → `~/.claude/rules/*.md` (symlinked individually via `rulesDir`).
  One topic per file; path-scoped files carry `paths:` frontmatter and only
  load when Claude reads a matching file (Terraform, Python, Node, Docker,
  Nix). Unconditional files (worktrees, CodeGraph, CLI gotchas, config/infra)
  load every session like `memory.md`.
- `agents/*.md` → `~/.claude/agents/*.md` (symlinked individually,
  `default.nix:40-51`).
- `output-styles/*.md` → `~/.claude/output-styles/*.md` via the module's
  native `outputStyles` attrset option (`default.nix`, near `context`). The
  attr name sets the destination filename; the active-style lookup key is
  the frontmatter `name` field inside the file, not the attr name — kept
  identical to avoid a silent, errorless name mismatch. Active style is
  chosen by `"outputStyle": "<name>"` in `settings.json`.
- `settings.json` — declarative base settings, merged (not symlinked) into
  the live, Claude-mutated `~/.claude/settings.json` on every `hms` via
  `home.activation.mergeClaudeSettings` (`default.nix:58-64`) running
  `merge-settings.sh`. A plain symlink would break because Claude Code writes
  to this file at runtime (plugin installs, MCP allowlist edits).

## Gotchas

- `merge-settings.sh` does a three-way merge (base/prev/target): strips keys
  removed from the Nix base since last run, deep-merges (Nix wins on scalar
  conflicts), snapshots the base for next time. It replaces arrays wholesale
  rather than merging elements — this is why `allowedMcpServers` entries for
  runtime-registered MCP servers can't live in the Nix base; they'd be
  clobbered.
- `programs.claude-code.mcpServers` emits a `--plugin-dir` plugin whose MCP
  server shows in `claude mcp list` but never loads into a real session
  (verified). A `~/.claude.json` user-scoped server entry does load. codegraph
  is therefore registered via the `home.activation.codegraphMcp` script
  (`default.nix:96-123`), not `mcpServers`: it jq-writes codegraph into
  `~/.claude.json` `.mcpServers` and add-if-absent's its `allowedMcpServers`
  entry into `settings.json`, keyed on the stable `~/.nix-profile/bin/codegraph`
  path (not the store path, which changes every version bump and would drop
  the allowlist entry).
- `allowedMcpServers` in the live `~/.claude/settings.json` is a strict
  allowlist — every MCP connector not listed (including claude.ai connectors
  and plugin-provided servers) is silently blocked in all directories.
  `serverName` does not match plugin-provided servers; match by `serverUrl`
  (HTTP) or exact `serverCommand` argv (stdio) instead.
- Two `claude` binaries can coexist on this machine: the native self-updating
  install at `~/.local/bin/claude` and this module's at
  `~/.nix-profile/bin/claude`. Only the nix one passes `--plugin-dir`, so if
  `~/.local/bin` is ahead on PATH, nix-managed plugin MCP servers silently
  vanish from `/mcp` even though config is correct. Check
  `readlink -f $(command -v claude)` if a nix-managed MCP disappears.
- Switching output style via `/config` or the picker writes to that project's
  `.claude/settings.local.json`, which outranks the user-scope
  `~/.claude/settings.json` this module manages — `hms` can never reclaim a
  repo pinned off the Nix-set style that way. Custom styles also silently
  disappear under `--safe-mode`/`CLAUDE_CODE_SIMPLE` (built-ins only, no
  error). Both are inherent to Claude Code, not bugs in this module.
- Auto-memory (`autoMemoryEnabled: false` in `settings.json`) is intentionally
  off — see the root `AGENTS.md` Doc Contract for why user-authored
  memory.md/rules were chosen over Claude-authored auto-memory for this setup.
- `autoCompactWindow: 533000` and `hooks.PreCompact` (`compact-instructions.sh`)
  tune when/how auto-compact fires — `533000` is a derived value, not round,
  and the hook relies on undocumented behavior verified against the
  installed binary. `hooks.PreCompact` is declared directly (unlike the
  `UserPromptSubmit` hook above) since no installed plugin currently owns
  that key — a future runtime-added `PreCompact` hook would be silently
  wiped on the next `hms` (same array-wholesale-replace mechanism as the
  `allowedMcpServers` gotcha above). Full derivation and re-verification
  steps: `docs/claude-code-autocompact.md`.

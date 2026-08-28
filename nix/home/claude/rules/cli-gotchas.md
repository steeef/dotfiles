# CLI tool gotchas

- IMPORTANT: Use GNU syntax for CLI tools. Nix provides GNU sed/grep/find/xargs ahead of macOS built-ins. Use `sed -i '/pattern/d' file` (GNU) not `sed -i '' '/pattern/d' file` (BSD). Confirm with `<tool> --version`.

## acli (Jira CLI)
- Works reliably on 1.3.19-stable+ (verified working 2026-06-10: `acli jira auth status` → Authenticated). Always try acli first for Jira operations — don't assume it's broken. If it errors, run `acli jira auth status` and `/conductor:setup-acli` to fix in-session; fall back to Atlassian MCP tools only if acli genuinely can't be fixed.
- `acli jira workitem comment create --body` mangles markdown/ADF formatting, same class of issue as Atlassian MCP tools without `contentFormat: "markdown"`. Prefer Atlassian MCP tools with `contentFormat: "markdown"` for Jira comments over acli's comment subcommand.

## gh (GitHub CLI)
- Two accounts are logged in: `stephen-tatari` (work, active by default) and `steeef` (personal). Personal repos (e.g. `steeef/dotfiles`, pushed via the `personal-github` SSH host alias) reject PR/issue creation under the work account with `GraphQL: must be a collaborator`.
- Before PR/issue ops on a personal (steeef-owned) repo: `gh auth switch --hostname github.com --user steeef`, do the operation, then restore with `gh auth switch --hostname github.com --user stephen-tatari`. `git push` is unaffected (SSH via the `personal-github` alias). Check with `gh auth status`.

## codex exec hangs when backgrounded
- `codex exec` *always* tries to read supplementary stdin before using the prompt argument (prints `Reading additional input from stdin...` — this is normal, not an error, even with a perfectly good prompt). The hang happens when stdin is inherited from a backgrounded/non-interactive parent that never sends EOF (the `subprocess` default, and the Bash tool's `run_in_background` behavior) — that read blocks forever, regardless of whether the prompt itself is valid.
- Fix: always close stdin on a `codex exec` call that might run backgrounded — append `< /dev/null` to a raw command. Verified live: `codex exec ... "prompt" < /dev/null` completes normally under `run_in_background`; the identical command without the redirect hangs on the stdin-read banner forever.
- Separately (a real but different bug): never inline a heredoc inside a command substitution as a CLI argument (`"$(cat <<'EOF' ... EOF)"`) — it can silently evaluate to an empty string, sending the wrong/missing prompt to codex. Fix: write the prompt to a scratch file first (Write tool), then pass it as `"$(cat /path/to/prompt.txt)"`.
- Prefer the `general:codex` skill's `codex-query.py` over a hand-rolled `codex exec` command — it closes stdin (`DEVNULL`) internally and accepts `"@/path/to/prompt.txt"` (same `@`-file convention as its `--instructions` flag) so neither failure mode applies. See the skill's Troubleshooting section ("Hung on Stdin") for the full mechanism.
- If a backgrounded command's output shows nothing but the stdin-wait banner with no further progress, don't wait it out — `TaskStop` it immediately and relaunch with stdin closed.

## Verifying backgrounded CLI calls before trusting them
- A clean launch (no error, no immediate exit) is not proof a backgrounded long-running command is doing anything — some tools silently wedge (e.g. falling back to stdin with nothing attached, per the codex case above) without ever erroring.
- After starting any CLI call expected to run long via `run_in_background`, check `TaskOutput` for real, tool-specific progress signals before telling the user it's "running, I'll report back." If output only shows a startup banner or a wait-for-input message with no further progress, `TaskStop` immediately, diagnose, and relaunch correctly — don't wait indefinitely on a hunch that it'll come good.

## Claude Code auto-compact tuning
- `autoCompactWindow: 533000` (settings.json) tunes the effective auto-compact
  trigger to ~500k tokens (was ~637k). A `PreCompact` hook
  (`compact-instructions.sh`) also shapes what compaction preserves, via an
  undocumented stdout→`newCustomInstructions` channel verified against the
  installed binary — it can silently stop working on a Claude Code upgrade
  with no error.
- If compaction seems to fire at the wrong point, or seems to lose context it
  shouldn't (especially right after upgrading Claude Code), see
  `~/.dotfiles/docs/claude-code-autocompact.md` for the full derivation and
  re-verification steps before assuming the config is wrong.

## claude binary shadowing
- Two Claude Code installs can coexist: the native self-updating one at `~/.local/bin/claude` (official install script) and the nix home-manager one at `~/.nix-profile/bin/claude`. `~/.local/bin` is ahead on PATH, so the native one wins `which claude` if present.
- Only the nix wrapper passes `--plugin-dir <hm-plugin>`, which is how nix-managed plugin MCP servers get injected. The native claude reads `~/.claude/settings.json` fine (so marketplace/`~/.claude.json` servers still show) but never loads the nix plugin — so a nix-managed MCP silently disappears from `/mcp` whenever the native binary is the one running, even though the nix config is correct.
- If a nix-managed MCP "disappears," check `type -a claude` / `readlink -f $(command -v claude)` first — a stray `claude update` or re-run of the native installer recreates `~/.local/bin/claude` and re-shadows nix. Fix: remove `~/.local/bin/claude` so bare `claude` resolves to the nix profile.

## Allowing a new MCP server (`allowedMcpServers`)
- `claude mcp add ... -> "Cannot add MCP server: not allowed by enterprise policy"` isn't necessarily an org/MDM block — it also fires purely from a populated `allowedMcpServers` in `~/.claude/settings.json` (user scope), no managed policy involved.
- Once that list has *any* `serverCommand` entry, every stdio server must match a `serverCommand` exactly — a `serverName` entry stops counting for stdio servers. Same split for remote servers: any `serverUrl` entry forces all HTTP/SSE servers to match by URL, `serverName` alone no longer works. Each transport type is poisoned independently.
- Fix: add a `serverCommand` (stdio) or `serverUrl` (HTTP/SSE) entry with the exact command/URL — `serverName` entries are then redundant for that transport and can be dropped. Commands must match every argument in order.
- Full mechanics: <https://code.claude.com/docs/en/managed-mcp>

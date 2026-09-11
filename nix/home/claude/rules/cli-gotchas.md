# CLI tool gotchas

- IMPORTANT: Use GNU syntax for CLI tools. Nix provides GNU sed/grep/find/xargs ahead of macOS built-ins. Use `sed -i '/pattern/d' file` (GNU) not `sed -i '' '/pattern/d' file` (BSD). Confirm with `<tool> --version`.

## acli (Jira CLI)
- Works reliably on 1.3.19-stable+ (verified working 2026-06-10: `acli jira auth status` → Authenticated). Always try acli first for Jira operations — don't assume it's broken. If it errors, run `acli jira auth status` and `/conductor:setup-acli` to fix in-session; fall back to Atlassian MCP tools only if acli genuinely can't be fixed.
- IMPORTANT: `acli jira workitem comment create --body` mangles markdown/ADF formatting (raw `## syntax`, bare URLs) — the same failure mode as calling the Atlassian MCP comment tool without `contentFormat: "markdown"`. Never call acli's comment subcommand or the MCP comment tool directly, even for a one-off note or as a fallback when a ticket transition isn't reachable — always route through `Skill(skill='conductor:jira-management')`'s add-comment operation (`add-comment.sh`), which converts markdown to ADF correctly before posting.

## gh (GitHub CLI)
- Two accounts are logged in: `stephen-tatari` (work, active by default) and `steeef` (personal). Personal repos (e.g. `steeef/dotfiles`, pushed via the `personal-github` SSH host alias) reject PR/issue creation under the work account with `GraphQL: must be a collaborator`.
- Before PR/issue ops on a personal (steeef-owned) repo: `gh auth switch --hostname github.com --user steeef`, do the operation, then restore with `gh auth switch --hostname github.com --user stephen-tatari`. `git push` is unaffected (SSH via the `personal-github` alias). Check with `gh auth status`.

## Claude Code / MCP troubleshooting
Full derivations: `~/.dotfiles/docs/cli-troubleshooting.md`.
- `codex exec` hangs when backgrounded (reads stdin, never gets EOF) — close stdin (`< /dev/null`) or use `codex-query.py`.
- A clean launch doesn't prove a backgrounded CLI call is progressing — check `TaskOutput` for real progress before trusting it.
- `claude` binary can be shadowed by a native `~/.local/bin/claude` install, silently dropping nix-managed MCP servers.
- `allowedMcpServers` in `~/.claude/settings.json` can block new MCP adds with no managed policy involved.
- `npx`-based stdio MCP servers can silently fail to spawn (PATH not inherited) — use absolute paths for both `npx` and `node`.
- `.claude.json` MCP config for worktree setups can live under an unexpected `projects.<key>` — verify the key before editing.

## Claude Code auto-compact tuning
- `autoCompactWindow: 533000` (settings.json) tunes the effective auto-compact
  trigger to ~500k tokens (was ~637k), plus a `PreCompact` hook shaping what's
  preserved — can silently break on a Claude Code upgrade with no error.
- Full derivation and re-verification steps: `~/.dotfiles/docs/claude-code-autocompact.md`.

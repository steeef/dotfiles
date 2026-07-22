# CLI tool gotchas

- IMPORTANT: Use GNU syntax for CLI tools. Nix provides GNU sed/grep/find/xargs ahead of macOS built-ins. Use `sed -i '/pattern/d' file` (GNU) not `sed -i '' '/pattern/d' file` (BSD). Confirm with `<tool> --version`.

## acli (Jira CLI)
- Works reliably on 1.3.19-stable+ (verified working 2026-06-10: `acli jira auth status` → Authenticated). Always try acli first for Jira operations — don't assume it's broken. If it errors, run `acli jira auth status` and `/conductor:setup-acli` to fix in-session; fall back to Atlassian MCP tools only if acli genuinely can't be fixed.
- `acli jira workitem comment create --body` mangles markdown/ADF formatting, same class of issue as Atlassian MCP tools without `contentFormat: "markdown"`. Prefer Atlassian MCP tools with `contentFormat: "markdown"` for Jira comments over acli's comment subcommand.

## gh (GitHub CLI)
- Two accounts are logged in: `stephen-tatari` (work, active by default) and `steeef` (personal). Personal repos (e.g. `steeef/dotfiles`, pushed via the `personal-github` SSH host alias) reject PR/issue creation under the work account with `GraphQL: must be a collaborator`.
- Before PR/issue ops on a personal (steeef-owned) repo: `gh auth switch --hostname github.com --user steeef`, do the operation, then restore with `gh auth switch --hostname github.com --user stephen-tatari`. `git push` is unaffected (SSH via the `personal-github` alias). Check with `gh auth status`.

## claude binary shadowing
- Two Claude Code installs can coexist: the native self-updating one at `~/.local/bin/claude` (official install script) and the nix home-manager one at `~/.nix-profile/bin/claude`. `~/.local/bin` is ahead on PATH, so the native one wins `which claude` if present.
- Only the nix wrapper passes `--plugin-dir <hm-plugin>`, which is how nix-managed plugin MCP servers get injected. The native claude reads `~/.claude/settings.json` fine (so marketplace/`~/.claude.json` servers still show) but never loads the nix plugin — so a nix-managed MCP silently disappears from `/mcp` whenever the native binary is the one running, even though the nix config is correct.
- If a nix-managed MCP "disappears," check `type -a claude` / `readlink -f $(command -v claude)` first — a stray `claude update` or re-run of the native installer recreates `~/.local/bin/claude` and re-shadows nix. Fix: remove `~/.local/bin/claude` so bare `claude` resolves to the nix profile.

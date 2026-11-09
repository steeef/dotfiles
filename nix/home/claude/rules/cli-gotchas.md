# CLI tool gotchas

- IMPORTANT: Use GNU syntax for CLI tools. Nix provides GNU sed/grep/find/xargs ahead of macOS built-ins. Use `sed -i '/pattern/d' file` (GNU) not `sed -i '' '/pattern/d' file` (BSD). Confirm with `<tool> --version`.

## acli (Jira CLI)
- IMPORTANT: While [homebrew-acli#76](https://github.com/atlassian/homebrew-acli/issues/76) is open (AIF-150, 2026-11-09), use the Atlassian MCP first for Jira reads, edits and creates. acli 1.3.40 `view`/`search` take 1-30s+ or stall, and `create` times out. Custom fields still go through `set_field.py` (REST, unaffected). acli stays for bulk and admin work.
- Revert acli-first when `timeout 30 acli jira workitem view <open ticket> --json` returns in under 10s on 3 runs in a row and `acli jira workitem create` succeeds. Then delete the #76 bullets. Before that, acli worked reliably on 1.3.19-stable+ (verified 2026-06-10); on an acli error run `acli jira auth status` and `/jira:setup`.
- IMPORTANT: `acli jira workitem comment create --body` mangles markdown/ADF formatting (raw `## syntax`, bare URLs). Never use acli's `--body`. Post comments through `Skill(skill='jira:comment')` (`add-comment.sh`), which converts markdown to ADF. If `comment create` stalls, the Atlassian MCP comment tool is fine with `contentFormat: "markdown"` (the plugin's comment guard only blocks Bash).
- Editing an existing comment is allowed: `acli jira workitem comment update` has no skill wrapper, so convert the markdown first (`markdown_to_adf.py file.md > c.json` in the jira plugin's `scripts/`; jira 0.2.2 has no `--comment` flag, so check `--help` after plugin upgrades), then `acli jira workitem comment update --key KEY --id ID --body-adf c.json`. Never use `--body` or `--body-file` (plain text). Find the id with `fetch_comments.py`. Verified 2026-11-06 on AIF-149.

## aws (AWS CLI)
- Run `aws` commands bare. The shell's `$AWS_PROFILE` is the right profile ~99% of the time, so `--profile` stays off the command line.
- On an auth or access error, run `aws sts get-caller-identity` and report the identity it returns.
- Ask about profiles only when the task names an account or environment the current identity can't reach.

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

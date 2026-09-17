# Repo mirrors — local cache for hot repos

- When a session hits the same repo with `gh api repos/...` or `gh search
  code` roughly 3+ times, run `~/.bin/repo-mirror sync <org>/<repo>` once and
  read from `~/.cache/repo-mirrors/<org>/<repo>` (via `git -C <path> show`/
  `grep`) for the rest of that work, instead of continuing per-call API
  lookups. No registry to maintain — just check whether the cache dir exists.
- `repo-mirror sync` clones over HTTPS, disables push (`no_push` remote),
  fails loudly on a fetch error rather than serving a stale tree, and prints
  the synced SHA — preserve those invariants if editing the script.
- Never `git clone --mirror`/`--bare` for this: a plain checkout lets
  Read/Grep/Glob-only agents (no Bash) use the cache too, and `--mirror` sets
  `remote.mirror=true`, so an argument-less `git push` there force-deletes
  remote branches.
- A PreToolUse hook (`repo-mirror-guard.py`) blocks `gh api`/`gh search code`
  calls against any repo that already has a mirror — sync and read from the
  cache instead of working around the block.
- Rebuildable cache, not a source of truth: safe to delete
  `~/.cache/repo-mirrors/` entirely if it ever gets into a bad state.

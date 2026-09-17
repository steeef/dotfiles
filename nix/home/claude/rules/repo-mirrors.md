# Repo mirrors — local cache for hot repos

- When a session hits the same repo with `gh api repos/...` or `gh search
  code` roughly 3+ times, run `~/.bin/repo-mirror sync <org>/<repo>` once and
  read from `~/.cache/repo-mirrors/<org>/<repo>` (via `git -C <path> show`/
  `grep`) for the rest of that work, instead of continuing per-call API
  lookups. No registry to maintain — just check whether the cache dir exists.
- `repo-mirror sync` clones over HTTPS, disables push (`no_push` remote),
  locks per-repo against concurrent syncs, validates the `<org>/<repo>` slug
  shape, fails loudly on a fetch error (the mirror's on-disk tree is left
  as-is; only the nonzero exit/stderr signals it didn't update), and prints
  the synced SHA — preserve those invariants if editing the script.
- Private repos need a working git credential helper for `github.com` (e.g.
  `gh auth git-credential`) — HTTPS clone has no other auth path here. A
  helper that needs first-time interactive authorization (e.g. a Keychain or
  browser/OAuth prompt) can still hang a sync; `GIT_TERMINAL_PROMPT`/
  `GIT_ASKPASS` only suppress git's own prompt fallback, not that.
- Stuck lock: a sync killed uncleanly (SIGKILL, crash, sleep) can leave
  `<org>/<repo>.lock` behind, permanently failing future syncs for that repo
  with "already in progress". Recover with `rm -rf
  ~/.cache/repo-mirrors/<org>/<repo>*` (the glob clears both the mirror and
  the lock) — deleting only `<org>/<repo>` is not enough.
- Never `git clone --mirror`/`--bare` for this: a plain checkout lets
  Read/Grep/Glob-only agents (no Bash) use the cache too, and `--mirror` sets
  `remote.mirror=true`, so an argument-less `git push` there force-deletes
  remote branches.
- A PreToolUse hook (`repo-mirror-guard.py`) blocks `gh api`/`gh search code`
  calls against any repo that already has a mirror — sync and read from the
  cache instead of working around the block. It matches on command text, so
  it fails open (never blocks, silently) for: a nested invocation like
  `bash -c "gh api ..."`; `gh api https://api.github.com/repos/...` (absolute
  URL form); `gh api graphql`/`gh search code` using concatenated short
  flags (`-Rorg/repo`, `-Fowner=x`) or `-f`/`--field`/`--raw-field` instead of
  `-F`; or if `~/.bin/repo-mirror` is missing/broken. Accepted gaps for a
  personal tool — not worth chasing further evasions.
- Full clones, no eviction: each mirror keeps its whole history and nothing
  prunes old mirrors automatically. Rebuildable cache, not a source of truth
  — safe to delete `~/.cache/repo-mirrors/` (or one `<org>/<repo>*`, see
  above) entirely if it ever gets into a bad state or grows too large.

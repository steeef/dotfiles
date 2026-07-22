# CodeGraph — code-structure MCP (macOS; index the worktree, never the clone)

- What: a local pre-indexed knowledge graph (`codegraph_explore`, `codegraph_node` MCP tools) answering structural questions — who-calls-X, blast-radius of Y, how-does-Z-fit — in one call. Prefer it over broad grep for those; fall back to built-in tools when it reports no index.
- Lazy build: only when a task genuinely needs structural / blast-radius understanding (NOT every worktree, NOT surgical edits), run `codegraph init "$WORKTREE"` in the **background** — the one full parse. It writes `.codegraph/` (gitignored, disposable).
- **Index the worktree you're in; never `codegraph init` a human clone** (read-only rule — it writes `.codegraph/` + would be stale for in-flight code). Pass `projectPath=<worktree root>` on MCP calls; don't rely on the server's cwd.
- Freshness: automatic on a fresh session (the server reconciles the index on connect). The file watcher is disabled (`--no-watch` + `CODEGRAPH_NO_DAEMON=1`, so nothing leaks per worktree), so mid-session — after you've made significant edits and need a structural query to reflect them — run `codegraph sync "$WORKTREE"` first. Rarely needed; you already know your own edits.
- The index persists for the worktree's life (idempotent `EnterWorktree` reuses the dir); it dies with `ExitWorktree(remove)`. No cleanup, no daemon to kill.

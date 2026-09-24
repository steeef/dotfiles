# ast-grep — structural code search (prefer over grep/rg for syntax-aware queries)

- What: `ast-grep` (`sg`) matches code by AST pattern, not text — finds calls/imports/definitions while ignoring matching text inside strings/comments, and does language-aware rewrites. Installed via nix (`nix/home/default.nix`); also available as the `ast-grep` Claude Code skill/plugin (marketplace in `nix/home/claude/settings.json`, enabled in `nix/home/claude/default.nix`).
- Prefer it over `Grep`/`rg` when the query is structural: "find all callers of X", "every import of Y", "rename this identifier but not the string literal that matches it". Plain text/string lookups still just want `Grep`.
- It won't get picked automatically — name it explicitly ("use ast-grep to find...") when a structural query calls for it.
- Pattern syntax: `sg run -p '<pattern>' -l <lang>` for search, `-r '<rewrite>'` to rewrite (dry-run by default without `-U`/`--update-all`).

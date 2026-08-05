# Claude Code auto-compact tuning

`nix/home/claude/settings.json` tunes when Claude Code auto-compacts
(`autoCompactWindow: 433000`) and adds a `PreCompact` hook
(`hooks/compact-instructions.sh`) that shapes what a compaction summary
preserves. Both were verified against the actual installed binary
(`~/.local/share/claude/versions/2.1.222`) via `strings`, not just the
official docs, because the load-bearing mechanism turned out to be
undocumented. Re-verify after Claude Code upgrades — see "Staying current"
below.

## Why 433000, not a round 400000

Claude Code used to also carry an env var,
`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: "65"`, in the same `env` block. That knob
composes **multiplicatively** with `autoCompactWindow`, not additively:
effective trigger = `floor((min(model_window, autoCompactWindow) - 20000) *
pct/100)`, capped at `that - 13000` (confirmed via `strings` against the
binary's minified source — the relevant functions are `qX`/`FTo`/`EEe`).
Concretely, with a 1M-token model:

| config | effective trigger |
|---|---|
| `autoCompactWindow` unset, pct=65 (old default) | ~637k |
| `autoCompactWindow: 400000`, pct=65 still set | ~247k (surprise undershoot) |
| `autoCompactWindow: 433000`, pct override removed | ~400k (intended) |

So the override was removed, and `433000` is a **derived** value tied to
Claude Code's internal ~20k reserve and ~13k margin constants — not a
timeless constant. If a future upgrade changes those, re-derive it (see
"Staying current").

## The PreCompact hook: undocumented stdout → summarizer channel

Official docs describe `PreCompact` as a pure gate: a hook can only `exit 0`
(allow) or return `{"decision":"block","reason":"..."}` / `exit 2` (block).
A block's `reason` is shown to the **user**, never fed back to Claude as
actionable context — so a design that blocks once and tells Claude (via the
reason) to take some action silently fails; Claude never sees it.

What the docs don't mention, but the installed binary does (function `$we`,
the `newCustomInstructions` string, the `reactive-compact` path): every
successful **non-blocking** `PreCompact` hook's stdout is joined across all
such hooks and passed into compaction as `newCustomInstructions` — the same
channel `/compact <custom instructions>` uses. That's what
`hooks/compact-instructions.sh` relies on: a stateless, side-effect-free
script that just prints fixed preservation instructions and exits 0, on
every invocation.

This talks to the **summarizer**, not to Claude — it shapes what the
compaction summary retains, and cannot instruct Claude to take an action
(e.g. "go run a skill"). Keeping a plan file current during normal work is
a separate, ongoing practice this hook can't substitute for.

Also confirmed via `strings`: Claude Code arms a *speculative* compaction
ahead of the real threshold, then re-arms or discards it
(`"precomputed compact: started / arm gated / re-arm capped / borrowed /
discarded"`), meaning `PreCompact` fires multiple times per real
compaction. This rules out any one-shot/marker-based hook design (it would
likely fire on a discarded speculative attempt, not the real one) — hence
the stateless design.

## Staying current

Both the `newCustomInstructions` stdout channel and the exact reserve/margin
constants behind `433000` are unverified by official docs and could change
silently (no error, just a quiet no-op) on a Claude Code upgrade. After
upgrading, re-check:

```sh
strings "$(readlink -f "$(command -v claude)")" | grep newCustomInstructions
```

If that string disappears, the `PreCompact` hook is a no-op and can be
removed. If `autoCompactWindow` starts behaving differently than expected,
re-derive the reserve/margin constants the same way (`strings` for
`function FTo`/`function qX`) rather than assuming `433000` still means
~400k.

## Statusline

`nix/home/claude/statusline.sh` shows the real context window in its `ctx`
segment unchanged (e.g. `180k/1.0m`) plus a separate `compact` segment —
only rendered when the auto-compact threshold is actually smaller than the
model's real window — showing proximity to the real trigger. This keeps
the two numbers from being conflated: `ctx` is always the true window, and
`compact` is a distinct, deliberately-labeled indicator of how close
auto-compact actually is.

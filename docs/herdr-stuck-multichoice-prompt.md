# Claude Code multiple-choice prompt hangs in herdr/tmux

**Status: open, root cause unproven, but a working theory is now
adopted.** A Claude Code `AskUserQuestion` prompt (arrow keys to
navigate, Enter to select, Esc to cancel) becomes completely
unresponsive — no key does anything, only Ctrl-C escapes, which aborts
the question instead of answering it. **Working theory:** repeatedly
switching focus away from and back to the pane (herdr space and/or OS
app) while the prompt sits open cumulatively raises the odds of hitting
a terminal-focus-report race that desyncs Ink's input parser — a single
switch-cycle rarely triggers it, but several cycles in a row reliably
does. Mitigation until fixed: avoid repeatedly switching away/back while
a multiple-choice prompt is open; if it locks up, Ctrl-C is the only
escape. See "Isolation attempts" for the evidence behind this theory —
it's adopted by decision, not proven by elimination.

## Isolation attempts (2026-08-13)

Starting point: a preview-panel `AskUserQuestion` (side-by-side layout, 3
options) hung once when, before touching any key, the reporter clicked to
another herdr space, clicked away from WezTerm to a browser window, then
clicked back through both (browser → WezTerm → original herdr space).
Dead keys, only Ctrl-C escaped — matched every real occurrence.

Follow-up tests, each with a fresh preview-panel question:

| Test | Action | Result |
|---|---|---|
| (a) | OS-level app switch only (WezTerm → browser → WezTerm), one cycle, no herdr space switch | Answered cleanly |
| (b) | herdr space-switch-by-click only, one cycle, stayed inside WezTerm | Answered cleanly |
| (c) | Full combo, one cycle (herdr switch + browser switch + back through both) | Answered cleanly |
| (d) | Full combo, **repeated switch-away/switch-back cycles** (herdr + multiple browser windows), testing arrow-key responsiveness after each cycle | **Hung** after ~3-4 cycles |

Reading: single-cycle attempts ((a), (b), (c)) all came back clean; the
one other hang (the original) and (d) both involved **repeated** cycling
through focus changes before locking up. That's consistent with a
per-cycle race with fairly low individual odds — one pass rarely hits
it, several passes in the same open-prompt window compound the
probability until it does. Tally: 2 hangs, both multi-cycle; 3 clean
answers, all single-cycle. Small sample, but directionally consistent
enough that further single-shot isolation (splitting herdr-click from
OS-switch) was deprioritized in favor of accepting the compound
repeated-cycling theory. Still untested: whether the `preview` panel
layout is required, or a plain question hangs the same way under the
same repeated-cycling action.

## What's confirmed

- Not herdr-specific: also reproduces in a plain **tmux** pane with no
  herdr involved. herdr, when used, fully replaces tmux for this setup
  (`wezterm -> herdr -> zsh`, no nesting) — so herdr isn't required to
  reproduce it. Points at something both multiplexers share (raw-mode pty
  handling, escape-sequence/query races, scrollback/copy-mode capturing
  keys) rather than a herdr bug specifically.
- `~/.config/herdr/config.toml` has no custom keybindings — stock defaults,
  `mouse_capture = true`.
- Caught one real occurrence live: session
  `~/.claude/projects/-Users-sprice--dotfiles/6fa1f40b-979e-422b-8c2b-8fcc926d2b4f.jsonl`.
  It was the preview-panel `AskUserQuestion` UI (single-select, 3 options,
  each with a multi-line preview). Asked at `16:15:10.223Z`, generic
  tool-rejection result (Ctrl-C) landed at `16:16:43.576Z` — **~93s stuck**.
  A burst of tool output/attachments immediately preceded the prompt
  (circumstantial, not proven).
- The `.jsonl` transcript only logs the eventual cancel outcome, never raw
  keystrokes — it cannot prove whether input was truly inert or just slow.
  **That evidence only exists at the terminal I/O layer and is lost once
  Ctrl-C is pressed.** Don't bother re-checking transcripts for future
  occurrences; they won't add anything beyond "what/when."
- Earlier belief that it does **not** reproduce synthetically (every
  `AskUserQuestion` shape tried answered cleanly with no explicit action
  taken mid-prompt) turned out to be incomplete in one respect: none of
  those attempts included switching panes/apps away and back while the
  prompt sat open, and the one time that was added it did hang — but see
  "Isolation attempts" above: repeating it immediately after did not
  reproduce, so this is still not a reliable synthetic trigger, just a
  new data point.
- Second live catch, session
  `~/.claude/projects/-Users-sprice-code-work-auth-svc/ed6273ed-942e-4561-8e06-696df4ebdafe.jsonl`
  (herdr, worktree `~/wt/auth-svc`, `SRE-3828-rebase-477`, CC 2.1.231) — hit
  **4 times in one session**. 3 of 4 show the same ~55-63s gap between
  prompt-fired and Ctrl-C-rejection timestamps (15:28:14→15:29:17,
  15:42:51→15:43:45, 16:17:50→16:18:50), matching the first catch's ~93s.
  Reporter confirms: **all keys totally dead** (not just arrows/Enter/Esc —
  number-key select and notes also did nothing, only Ctrl-C), and no
  scroll/resize noticed beforehand. The consistent keys-dead-with-no-user-
  action-trigger weakens hypothesis 1 (scroll/copy-mode capture — nothing
  to divert) and favors hypothesis 2 (terminal capability query race) or
  4 (herdr modal left open), neither of which need a scroll/resize
  precondition.

## Leading hypotheses

1. **Terminal capability/focus-report query race (adopted working
   theory).** A raw-byte capture of Claude Code's own startup output
   confirms it enables terminal focus-reporting (`\e[?1004h`) and issues
   DECRQM/XTVERSION capability queries (`\e[>0q`, `\e[c`, `\e[?2026$p`) —
   exactly the kind of terminal round-trip that a pane losing and
   regaining focus (herdr space-switch and/or OS app-switch) would
   perturb. Ink's input parser getting a focus-out/focus-in event mid-
   render could leave it stuck dropping normal keypresses until SIGINT
   resets terminal state. Refined per "Isolation attempts": each
   switch-cycle appears to be a low-odds independent race, so it takes
   several repeated cycles (observed: ~3-4) to reliably hit it — matches
   why single-cycle isolation attempts came back clean while repeated
   cycling hung.
2. **Resize/layout-recompute desync.** The preview panel's side-by-side
   layout recomputing — possibly triggered by the same focus-change event
   as #1 — could leave Ink's focus/measurement state inconsistent. Not
   distinguished from #1: still untested whether a non-preview (no
   side-by-side layout) question hangs the same way under repeated
   switch-cycling.
3. ~~Scrollback/copy-mode capture~~ — ruled out by the 2026-08-13 catches:
   no scrolling was involved in either the confirmed synthetic repro or
   the `ed6273ed` session's reporter-confirmed "all keys totally dead, no
   scroll/resize noticed" occurrences.
4. **herdr modal overlay left open.** Downgraded — the trigger is pinned
   to repeated focus/space switching (confirmed done by mouse click, not
   herdr's prefix key), so this is now only plausible via the
   click-forwarding mechanism folded into hypothesis 2, not a stray
   prefix keypress.

### Open questions

- Still untested: whether the `preview` panel layout matters at all, vs.
  a plain question hanging the same way under the same repeated-cycling
  action.
- Not pursued further: exact hang odds per cycle, or whether herdr's
  click-forwarding and the OS-level focus event are independently
  sufficient given enough repeated cycles each. Decided to stop grinding
  isolation trials here (see Status) rather than chase statistical
  significance on a manual, one-at-a-time test.

## Next-occurrence checklist (don't Ctrl-C immediately)

1. Try direct number-key select (`1`/`2`/`3` for a numbered list) —
   isolates whether select-by-key works even if arrows/Enter don't.
2. Try `n` (notes, if the footer offers it) — isolates whether *all* input
   is dead or just nav/select/cancel keys.
3. Nudge pane size by one column to force a redraw, then retry arrows.
4. Note: herdr, tmux, or plain terminal? Any scroll/resize just before it
   locked up?
5. If feasible, have `~/bin/repro-multichoice-hang.sh` already running in
   that pane (`script -r -k -q`, macOS/BSD syntax — captures keys sent
   *and* output, not just output) — the only way to see the actual raw
   byte stream and confirm what keys did/didn't arrive.
   **Caveat found 2026-08-13:** macOS's `script -p` playback parser is
   fragile — on a real ~33min capture it desynced and errored
   (`invalid stamp`) only ~17s in, well before the hang at the end, so the
   rest of that capture couldn't be replayed. For the next capture,
   prefer `asciinema rec` instead (newline-delimited JSON events, far more
   robust/inspectable, immune to this binary-framing desync) if
   available.
6. Only then Ctrl-C, and grab the session id (`echo $CLAUDE_SESSION_ID` or
   check the transcript dir) for the *what/when*, not the *why*.

Given the adopted working theory (repeated focus-report races during an
open prompt), the fix most likely belongs upstream in Claude Code's Ink
terminal-input handling (how it recovers from focus-out/focus-in events
mid-render) rather than in herdr or tmux config — worth reporting to
Anthropic with this doc's evidence once/if a tighter repro lands. Until
then, the practical mitigation is behavioral: avoid repeatedly switching
away from and back to the pane while a multiple-choice prompt is open.

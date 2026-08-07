# Claude Code multiple-choice prompt hangs in herdr/tmux

**Status: open, unresolved.** Intermittent-but-frequent bug: a Claude Code
`AskUserQuestion` prompt (arrow keys to navigate, Enter to select, Esc to
cancel) becomes completely unresponsive — no key does anything, only
Ctrl-C escapes, which aborts the question instead of answering it.

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
- Does **not** reproduce synthetically: tried every `AskUserQuestion` shape
  (plain single-select, multiSelect, preview, preview+multiSelect combo,
  and an exact clone of the real stuck question) and a large-stdout-burst
  precondition, all in a herdr pane — every attempt answered cleanly. The
  trigger is state-dependent/intermittent, not tied to question
  shape/content or crude output-volume timing.

## Leading hypotheses (untested — need a live catch)

1. **Scrollback/copy-mode capture.** Scrolling the pane (wheel/trackpad)
   while a question is pending could divert arrow/Enter to the
   multiplexer's scroll view instead of the app. If its "exit scroll mode"
   key isn't Esc, Esc would do nothing (matches symptom) while Ctrl-C
   (SIGINT) still reaches the app. Most likely candidate — fits "often"
   (habit of scrolling back mid-prompt) and explains all three dead keys.
2. **Terminal capability query race.** Ink-based TUIs sometimes query the
   terminal (cursor position report, Kitty keyboard protocol, focus
   reporting, synchronized-output mode) and can desync if a multiplexer
   swallows/delays/mismatches the response — leaving the input parser stuck
   dropping normal keypresses until SIGINT. Explains intermittency (race
   window) and "only Ctrl-C works."
3. **Resize-during-render desync.** Resizing the pane, or the preview
   panel's side-by-side layout recomputing, while the prompt renders could
   leave Ink's focus/measurement state inconsistent.
4. **herdr modal overlay left open.** A stray prefix keypress (`ctrl+b`
   default) before the question opened could leave herdr in prefix-wait
   mode, silently consuming the next keystroke itself.

## Next-occurrence checklist (don't Ctrl-C immediately)

1. Try direct number-key select (`1`/`2`/`3` for a numbered list) —
   isolates whether select-by-key works even if arrows/Enter don't.
2. Try `n` (notes, if the footer offers it) — isolates whether *all* input
   is dead or just nav/select/cancel keys.
3. Nudge pane size by one column to force a redraw, then retry arrows.
4. Note: herdr, tmux, or plain terminal? Any scroll/resize just before it
   locked up?
5. If feasible, have `script -q ~/stuck-repro.typescript` (or asciinema)
   already recording in that pane — the only way to see the actual raw
   byte stream and confirm what keys did/didn't arrive.
6. Only then Ctrl-C, and grab the session id (`echo $CLAUDE_SESSION_ID` or
   check the transcript dir) for the *what/when*, not the *why*.

Once one of the above hypotheses is confirmed, the fix likely lives in
herdr config (`~/.config/herdr/config.toml`, e.g. `mouse_capture = false`
or a remapped scroll-exit key), tmux config, or is worth reporting upstream
to Anthropic (Claude Code) or herdr's maintainer with a precise repro.

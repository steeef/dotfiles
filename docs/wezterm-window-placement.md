# WezTerm Window Placement

This repository lets Hammerspoon handle all of the window sizing and placement
for WezTerm. That keeps lifecycle logic in one place (the same hotkeys that move
the window also persist its geometry) and allows WezTerm to stay focused on font
and rendering config.

## How it works

- `hammerspoon/window-management.lua` writes the current WezTerm frame to
  `~/.cache/wezterm/window-state.json` whenever a grid move, maximize, or manual
  resize occurs. The JSON payload contains the window’s width, height, position,
  and the screen metadata.
- A window filter in `hammerspoon/init.lua` restores that state as soon as a new
  WezTerm window is created (or when Hammerspoon reloads), falling back to a
  sensible heuristic if the cache is empty.
- `nix/home/darwin/wezterm.nix` no longer attempts to persist window geometry.
  It simply applies rendering tweaks and lets Hammerspoon drive placement.

Because Hammerspoon is now the single source of truth, the `window-state.json`
file also reflects any movements triggered by external scripts or hotkeys. If
you prefer to reset the remembered placement, delete that file and reopen
WezTerm; Hammerspoon will recreate it with the next move.

# dotfiles

Personal Nix-managed dotfiles: declarative system + Home Manager config across
macOS, NixOS, and a home-only Linux profile. Every dotfile is generated from a Nix
module — manual edits outside Nix get overwritten.

## What

- Stack: Nix flakes, Home Manager, nix-darwin; targets macOS, NixOS, and a
  home-only Linux profile.
- Layout: `flake.nix` — inputs, overlays, per-host outputs; the host list lives
  here. Update first when adding machines or packages.
- Layout: `nix/home/` — Home Manager modules (`darwin/`, `linux/`, `claude/`).
- Layout: `nix/darwin/`, `nix/nixos/` — system-level modules.
- Layout: `nix/pkgs/` — overlays and custom packages; one file per attribute.
- Layout: `bin/` — helper scripts; executable interface for routine tasks.

## How

- Apply (Home Manager): `hms` — `home-manager switch --flake`.
- Apply (Darwin system): `dr` — `darwin-rebuild switch --flake`.
- Verify: `nix flake check` — validates all flake outputs; new modules must
  evaluate for every declared host.

## Index

- README.md — bootstrap and installation instructions.

## Lessons

- Commit subjects: short, imperative, lower-case, under 50 chars (e.g. `add rust stuff`).
- Don't hand-format; `.pre-commit-config.yaml` enforces style at commit time.
- Edit `AGENTS.md`, not `CLAUDE.md` — the latter is a symlink to it.
- Instead of `rm`, `mv` to `TRASH/` and log the move in `TRASH-FILES.md`.

## Doc Contract

- Re-read this file, plus any Index doc relevant to the area you are touching, before editing code in this repo.
- Do a doc pass after meaningful changes: before finishing work that changed behavior, structure, or commands, update this file or the relevant Index doc — or explicitly decide no doc change is needed.
- Delete stale text immediately; wrong docs are worse than missing docs.
- Prefer file:line pointers over code snippets; snippets rot.
- Hard cap: 200 lines for this file. At the cap, every addition must delete at least as many lines.
- This is the canonical map. Move depth out and index it above: working-context depth for one coherent directory → that area's child AGENTS.md (auto-loaded when working there); cross-cutting depth → a docs/ topic file.
- Children stay shallow and few: one level below root only (never a child below a child), at most a handful, each at a coherent area an agent edits as a unit — not per-folder. When in doubt, keep it in this file.

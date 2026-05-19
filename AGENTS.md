# Repository Guidelines

## Why

Personal Nix-managed dotfiles. Declarative system + Home Manager config across
macOS, NixOS, and a home-only Linux profile. Every dotfile is generated from
a Nix module — manual edits outside Nix get overwritten. See `README.md` for
bootstrap; see `flake.nix` for the host list.

## Project Structure

- `flake.nix` — inputs, overlays, per-host outputs. Update first when adding
  machines or packages.
- `nix/home/` — Home Manager modules (`darwin/`, `linux/`, `claude/`).
- `nix/darwin/`, `nix/nixos/` — system-level modules.
- `nix/pkgs/` — overlays and custom packages; one file per attribute.
- `bin/` — helper scripts; executable interface for routine tasks.

## Applying Changes

- `hms` — Home Manager switch (`home-manager switch --flake`).
- `dr` — Darwin system switch (`darwin-rebuild switch --flake`).
- `nix flake check` — validates all flake outputs; new modules must evaluate
  for every declared host.

## Commits

Short, imperative, lower-case; subject under 50 chars (e.g. `add rust stuff`).

## Agent Tips

- `CLAUDE.md` symlinks to `AGENTS.md`; edit `AGENTS.md`.
- Style is enforced by `.pre-commit-config.yaml` at commit time —
  don't hand-format.
- Instead of `rm`, `mv` to `TRASH/` and log in `TRASH-FILES.md`.

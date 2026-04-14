# Repository Guidelines

## Project Structure

- `flake.nix` defines inputs, overlays, per-host outputs; update first when adding machines or packages.
- `nix/home/` has Home Manager modules, platform splits under `darwin/` and `linux/`, agent config in `claude/`.
- `nix/darwin/` and `nix/nixos/` hold system-level modules for macOS and Linux.
- `nix/pkgs/` has custom overlays and package derivations; new packages go in dedicated file with matching attribute name.
- `bin/` has helper scripts; treat as executable interface for routine tasks.

## Hosts

- `darwinConfigurations`: `sp`, `ltm-3914` (both `aarch64-darwin`).
- `nixosConfigurations`: `nixos` (`x86_64-linux`, ThinkPad T440s).
- `homeConfigurations`: `sprice@linux` (home-only, no system module), plus `sprice@ltm-3914` and `sprice@sp` for Darwin Home Manager activations.

## Applying Changes

- `hms` applies Home Manager changes (`home-manager switch --flake` via repo helper).
- `dr` applies Darwin system changes (`darwin-rebuild switch --flake` via repo helper).
- `nix flake check` validates all flake outputs.

## Testing

- `nix flake check` validates all flake outputs; new modules must evaluate for every declared host.
- `prek run --files <changed-files>` runs pre-commit hooks for specific files.

## Pre-commit Hooks

- Nix: `alejandra` (formatter), `deadnix` (dead code), `statix` (linter).
- Shell: `shellcheck` (linter), `shfmt -i 2 -ci -w` (formatter, 2-space indent).
- YAML: `yamlfmt` (formatter).
- Markdown: `pymarkdown` (linter).
- Lua: `stylua` (formatter).

## Coding Style

- Nix: two-space indent, `snake_case` attributes, formatted by `alejandra`.
- Shell: POSIX-compatible, `#!/usr/bin/env bash`, `set -euo pipefail`, `shfmt` with 2-space indent.
- YAML: formatted via `yamlfmt`, linted by `yamllint` (config in `yamllint.yaml`); no hand-tweak after formatting.
- Filenames: lowercase with hyphens; prefer `nix/home/<area>/<module>.nix` pattern.

## Commits

- Short, imperative, lower-case messages (e.g. `add rust stuff`); subject lines under 50 chars.

## Agent Tips

- Manual dotfile edits outside Nix modules get overwritten; always use declarative modules.
- `CLAUDE.md` symlinks to `AGENTS.md`; edit `AGENTS.md` directly.
- Instead of `rm`, use `mv` to `TRASH/` and log in `TRASH-FILES.md`.
- Keep sections concise; agents read this file every conversation.
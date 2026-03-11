# Repository Guidelines

## Project Structure

- `flake.nix` defines all inputs, overlays, and per-host outputs; update it first when adding machines or packages.
- `nix/home/` contains Home Manager modules, with platform splits under `darwin/`, `linux/`, and agent-specific config in `claude/`.
- `nix/darwin/` and `nix/nixos/` hold system-level modules for macOS and Linux respectively.
- `nix/pkgs/` captures custom overlays and package derivations; new packages belong in a dedicated file with a matching attribute name.
- `bin/` provides helper scripts; treat them as the executable interface for routine tasks.

## Testing

- `nix flake check` validates all flake outputs; ensure new modules evaluate for every declared host.

## Coding Style

- Nix files use two-space indentation and snake_case attribute names.
- Shell scripts in `bin/` should be POSIX-compatible, start with `#!/usr/bin/env bash`, and enable `set -euo pipefail`.
- YAML is formatted via yamlfmt and linted by yamllint (config in `yamllint.yaml`); do not hand-tweak alignment after formatting.
- Keep filenames lowercase with hyphens; follow `nix/home/<area>/<module>.nix` pattern.

## Commits

- Short, imperative, lower-case style (e.g. `add rust stuff`); subject lines under 50 characters.

## Agent Tips

- Manual edits to dotfiles outside Nix modules will be overwritten; always stage changes through declarative modules.

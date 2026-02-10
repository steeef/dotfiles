# Repository Guidelines

## Project Structure & Module Organization

- `flake.nix` defines all inputs, overlays, and per-host outputs; update it first when adding machines or packages.
- `nix/home/` contains Home Manager modules, with platform splits under `darwin/`, `linux/`, and agent-specific config in `claude/`.
- `nix/darwin/` and `nix/nixos/` hold system-level modules for macOS and Linux respectively; keep hardware-specific tweaks scoped here.
- `nix/pkgs/` captures custom overlays and package derivations; new packages belong in a dedicated file with a matching attribute name.
- `bin/` provides helper scripts such as `bootstrap.sh`, `format.sh`, and `update.sh`; treat them as the executable interface for routine tasks.

## Build, Test, and Development Commands
- `hms` applies the active Home Manager configuration defined by this flake; run after editing anything in `nix/home/`.
- `dr` rebuilds macOS hosts via nix-darwin; use only on Darwin machines and expect sudo prompts.
- `nix flake check` validates all flake outputs and is the preferred pre-commit sanity test.
- `nix flake update` refreshes inputs; review `flake.lock` diffs before committing.
- `prek run --files <paths>` runs targeted hooks, and `./bin/format.sh` batches the repo's formatters.

## Coding Style & Naming Conventions
- Nix files use two-space indentation and snake_case attribute names; align lists and let blocks for readability.
- Shell scripts in `bin/` should remain POSIX-compatible, start with `#!/usr/bin/env bash`, and enable `set -euo pipefail`.
- YAML is formatted via `yamlfmt` (config in `yamlfmt.yaml`); do not hand-tweak alignment after formatting.
- Keep filenames lowercase with hyphens; stick to existing patterns such as `nix/home/<area>/<module>.nix`.

## Testing Guidelines
- Use `nix flake check` as the integration test suite; ensure new modules evaluate for every declared host.
- When touching lint-configured files, execute the relevant pre-commit hook locally (e.g. `prek run --files file.nix`).
- For experimental changes, prefer `nix develop` to spawn an isolated environment before applying `hms` or `dr`.

## Commit & Pull Request Guidelines
- Follow the existing short, imperative, lower-case commit style (e.g. `add rust stuff`); keep subject lines under 72 characters.
- Group related changes per commit to simplify rollbacks, and mention affected hosts or modules when relevant.
- Pull requests should describe the user-facing impact, list applied commands (`hms`, `dr`, etc.), and reference any linked issues or work items.

## Agent-Specific Tips
- Never edit generated files in `~/.claude/`; instead modify sources under `nix/home/claude/` and apply via `hms`.
- Note that manual edits to dotfiles outside Nix modules will be overwritten; always stage changes through declarative modules.

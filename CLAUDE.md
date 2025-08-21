# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Nix-based dotfiles repository using flakes, home-manager, and nix-darwin to manage development environments across Linux and macOS systems. The repository uses a declarative approach to system configuration management.

## Key Commands

### Nix Management
- `hms` - Apply home-manager configuration changes (alias for `home-manager switch --flake $HOME/.dotfiles#$USER@$(hostname)`)
- `dr` - Apply system-wide Darwin configuration changes (alias for `sudo darwin-rebuild switch --flake $HOME/.dotfiles`)
- `nix flake update` - Update flake inputs
- `nix flake check` - Validate flake configuration

### Development Tools
- `uvx --with pre-commit-uv pre-commit run --files <files>` - Run pre-commit hooks on specific files
- `yamlfmt` - Format YAML files (configured via yamlfmt.yaml)

### Utility Scripts
Scripts in `bin/` directory:
- `bootstrap.sh` - Initial setup script for new machines
- `format.sh` - Format configuration files
- `update.sh` - Update system and packages

## Architecture

### Core Structure
- `flake.nix` - Main Nix flake configuration defining inputs, outputs, and system configurations
- `nix/` - All Nix configuration modules organized by component
- `nix/home/` - Home-manager modules for user environment
- `nix/darwin/` - nix-darwin modules for macOS system configuration
- `nix/nixos/` - NixOS system configuration (for Linux hosts)
- `nix/pkgs/` - Custom package definitions and overlays

### Configuration Organization
- `nix/home/claude/` - Claude Code specific configuration including memory.md and settings.json
- Application configs in individual directories (hammerspoon, kitty, nvim, etc.)
- Platform-specific configs in `nix/home/darwin/` and `nix/home/linux/`

### Key Components
- **Home Manager**: Manages user environment, dotfiles, and applications
- **nix-darwin**: Manages macOS system settings and global configurations
- **Flake Inputs**: External dependencies like nixpkgs, home-manager, claude-code package from sadjow/claude-code-nix
- **Overlays**: Custom package modifications and additions in `nix/pkgs/`

## Machine Configurations

### Darwin (macOS)
- `sp` - Personal ARM64 macOS machine
- `ltm-3914` - Work ARM64 macOS machine

### NixOS (Linux)
- `nixos` - Linux configuration with ThinkPad T440s hardware support

## Important Notes

### Claude Code Configuration
- **CRITICAL**: Do not edit `~/.claude/CLAUDE.md` or `~/.claude/settings.json` directly
- Instead, edit source files in `~/.dotfiles/nix/home/claude/` and run `hms` to apply changes:
  - Memory: Edit `nix/home/claude/memory.md`
  - Settings/Hooks: Edit `nix/home/claude/settings.json`
- This ensures configuration updates persist across system rebuilds
- Claude Code package sourced from `github:sadjow/claude-code-nix` with automated updates
- Configuration managed via custom home-manager activation scripts

### File Organization
- Configuration files are managed declaratively through Nix modules
- Manual file edits may be overwritten on next `hms` or `dr` run
- Add new configurations through appropriate Nix modules in `nix/home/`

### Bootstrap Process
New machine setup requires:
1. Clone repo to `~/.dotfiles`
2. Run `./bin/bootstrap.sh`
3. For macOS: Add machine configuration to flake.nix and follow nix-darwin setup steps in README.md

# Claude Code Migration Plan: olebedev → Sewer56

## Overview
Migrate from `olebedev/claude-code.nix` to `Sewer56/claude-code-nix-flake` with full declarative configuration management.

## Current State Analysis
- **Current**: Claude Code v1.0.55 installed via olebedev/claude-code.nix
- **Installation**: System-wide via darwin configuration (nix/darwin/default.nix:54)
- **Configuration**: ~/.claude/ directory with CLAUDE.md, settings.json, projects/, statsig/, todos/
- **Flake input**: Line 24 in flake.nix, commit f847a0b8ba5

## Target State
- **New**: Sewer56/claude-code-nix-flake with home-manager module
- **Installation**: Home-manager managed via nix/home/claude/
- **Configuration**: Declarative Nix configuration with runtime data preservation
- **Structure**: Directory approach following existing patterns (git/, tmux/, etc.)

## Files Created
- `nix/home/claude/memory.md` - Contains your CLAUDE.md content
- `nix/home/claude/default.nix` - Complete flake configuration
- `nix/home/claude/MIGRATION_PLAN.md` - This migration plan

## Migration Steps

### Phase 1: Pre-migration Backup
1. **Backup current configuration**:
   ```bash
   cp -r ~/.claude ~/.claude.backup
   ```
2. **Backup flake.lock**:
   ```bash
   cp flake.lock flake.lock.backup
   ```

### Phase 2: Update Flake Configuration
1. **Update flake.nix input** (line 24):
   ```diff
   - claude-code.url = "github:olebedev/claude-code.nix";
   + claude-code-nix-flake.url = "github:Sewer56/claude-code-nix-flake";
   ```

2. **Update darwin/default.nix parameter list** (line 5):
   ```diff
   - claude-code,
   + claude-code-nix-flake,
   ```

3. **Remove from system packages** (darwin/default.nix line 54):
   ```diff
   - claude-code.packages.${pkgs.system}.default
   ```

### Phase 3: Update home-manager Configuration
1. **Add to nix/home/default.nix imports**:
   ```nix
   imports = [
     ./claude
     # ... existing imports
   ];
   ```

2. **Ensure inputs parameter**: Verify `inputs` is passed to home-manager modules

### Phase 4: Rebuild and Validate
1. **Update flake**:
   ```bash
   nix flake update claude-code-nix-flake
   ```
2. **Darwin rebuild**:
   ```bash
   darwin-rebuild switch --flake ~/.dotfiles
   ```
3. **Verify installation**:
   ```bash
   which claude  # should point to home-manager path
   claude --version
   ```
4. **Test functionality**: Basic Claude Code operations

### Phase 5: Preserve Runtime Data
1. **Copy runtime directories** from `~/.claude.backup/`:
   - `projects/` (project-specific configurations)
   - `todos/` (runtime todo files)
   - `statsig/` (analytics data)

   ```bash
   cp -r ~/.claude.backup/projects ~/.claude/
   cp -r ~/.claude.backup/todos ~/.claude/
   cp -r ~/.claude.backup/statsig ~/.claude/
   ```

2. **Verify hooks work**: Test that `$CLAUDE_CODE_TOOLS_PATH` and `~/.bin/format.sh` are accessible

## Configuration Details

### Declarative Settings
The following are now managed by Nix:
- **Memory**: `~/.claude/CLAUDE.md` from `memory.md`
- **Settings**: `~/.claude/settings.json` from Nix configuration
- **Permissions**: Bash commands allowlist
- **Hooks**: All PreToolUse, PostToolUse, and Notification hooks

### Runtime Data (Preserved)
The following directories remain file-based:
- `~/.claude/projects/` - Project-specific configurations
- `~/.claude/todos/` - Runtime todo files
- `~/.claude/statsig/` - Analytics data

### Hook Dependencies
Ensure these exist for hooks to function:
- `$CLAUDE_CODE_TOOLS_PATH` environment variable
- `~/.bin/format.sh` script
- Python scripts referenced in hooks configuration

## Benefits
- **Declarative config**: Nix-managed Claude Code settings and memory
- **Better integration**: Home-manager module vs system package
- **Version control**: Configuration changes tracked in git
- **Modularity**: Clean separation following existing patterns
- **Maintainability**: Easy to modify memory.md independently
- **Rollback capability**: Easy reversion with backups

## Rollback Plan
If issues arise:
1. Restore original flake configuration from `flake.lock.backup`
2. Restore `~/.claude/` from `~/.claude.backup/`
3. Run `darwin-rebuild switch --flake ~/.dotfiles`

## Post-Migration Validation
- [ ] Claude Code version check
- [ ] Basic commands work (`claude --help`)
- [ ] Settings preserved (permissions, hooks)
- [ ] Memory content accessible
- [ ] Project configurations intact
- [ ] Hook scripts functional
- [ ] Format script integration works

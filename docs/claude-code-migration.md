# Claude Code Migration: Sewer56 → sadjow

## Overview

Migration plan to switch from `github:Sewer56/claude-code-nix-flake` to `github:sadjow/claude-code-nix` while preserving all configuration functionality (settings, hooks, memory management).

## Current State Analysis

### Sewer56 Flake Features
- Provides `homeManagerModules.claude-code` with declarative config management
- Uses **home.activation scripts** (not symlinks) to manage `~/.claude/` files
- Supports settings.json, hooks, memory.md, commands, agents
- File operations via shell commands: `mkdir`, `install`, `jq`
- Optional backup and force-clean capabilities

### sadjow Flake Limitations
- Only provides the package (`packages.default`) - no configuration modules
- No declarative configuration management
- Simpler, more maintained package source

### Current Configuration
Located in `nix/home/claude/default.nix`:
- Memory: `./memory.md` → `~/.claude/CLAUDE.md`
- Settings: Complex settingsJson with permissions and hooks
- Hooks: Managed via settings.json format

## Migration Strategy

### 1. Extract Settings Configuration
```bash
# Create separate settings file:
nix/home/claude/settings.json
```

This separates the JSON configuration from Nix code, making it easier to maintain and edit.

### 2. Flake Input Change
```nix
# In flake.nix, line 24:
# FROM:
claude-code.url = "github:Sewer56/claude-code-nix-flake";
# TO:
claude-code.url = "github:sadjow/claude-code-nix";
```

### 3. Package Installation
```nix
# Add to home.packages in appropriate module:
home.packages = [ inputs.claude-code.packages.${pkgs.system}.default ];
```

### 4. Replace Home Manager Module
```nix
# In nix/home/claude/default.nix:
# REMOVE:
{
  imports = [
    inputs.claude-code.homeManagerModules.claude-code
  ];

  programs.claude-code = {
    enable = true;
    memory.source = ./memory.md;
    settingsJson = { ... };
  };
}
```

### 5. Custom Activation Script Implementation
```nix
# Replace with:
{ inputs, pkgs, lib, ... }: {
  home.packages = [ inputs.claude-code.packages.${pkgs.system}.default ];

  home.activation.claude-config = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create ~/.claude directory structure
    mkdir -p $HOME/.claude/hooks

    # Copy memory file
    install -m 644 ${./memory.md} $HOME/.claude/CLAUDE.md

    # Copy settings.json file
    install -m 644 ${./settings.json} $HOME/.claude/settings.json
  '';
}
```

## Implementation Steps & Validation

### 1. Extract settings.json ✓
**Test:**
```bash
# Validate JSON syntax
jq . nix/home/claude/settings.json > /dev/null && echo "✓ Valid JSON" || echo "✗ Invalid JSON"

# Compare with current config
claude --settings 2>/dev/null | jq -S . > /tmp/current_settings.json
jq -S . nix/home/claude/settings.json > /tmp/new_settings.json
diff /tmp/current_settings.json /tmp/new_settings.json || echo "Settings differ - review changes"
```

### 2. Switch flake input
**Test:**
```bash
# Validate flake builds
nix flake check

# Check if package is available
nix eval .#homeConfigurations."$(whoami)@$(hostname -s)".config.home.packages --apply 'builtins.map (p: p.pname or "unknown")' | grep claude-code
```

### 3. Remove module & add activation script
**Test:**
```bash
# Build home-manager config without applying
home-manager build --flake .#"$(whoami)@$(hostname -s)"

# Check if activation script is present
home-manager build --flake .#"$(whoami)@$(hostname -s)" && \
  ls result/activate | grep -q "claude-config" && echo "✓ Activation script found" || echo "✗ Activation script missing"
```

### 4. Apply configuration
**Test:**
```bash
# Backup current config before applying
cp -r ~/.claude ~/.claude.backup.$(date +%s) 2>/dev/null || true

# Apply home-manager changes
hms

# Test file placement
test -f ~/.claude/CLAUDE.md && echo "✓ Memory file exists" || echo "✗ Memory file missing"
test -f ~/.claude/settings.json && echo "✓ Settings file exists" || echo "✗ Settings file missing"
test -d ~/.claude/hooks && echo "✓ Hooks directory exists" || echo "✗ Hooks directory missing"
```

### 5. Validate configuration content
**Test:**
```bash
# Check memory file content matches
diff ~/.claude/CLAUDE.md nix/home/claude/memory.md && echo "✓ Memory content matches" || echo "✗ Memory content differs"

# Check settings JSON is valid and complete
jq -e '.permissions.allow | length > 0' ~/.claude/settings.json && echo "✓ Permissions configured" || echo "✗ Permissions missing"
jq -e '.hooks.PreToolUse | length > 0' ~/.claude/settings.json && echo "✓ PreToolUse hooks configured" || echo "✗ PreToolUse hooks missing"
jq -e '.hooks.PostToolUse | length > 0' ~/.claude/settings.json && echo "✓ PostToolUse hooks configured" || echo "✗ PostToolUse hooks missing"
```

### 6. Test Claude Code functionality
**Test:**
```bash
# Test basic execution
claude --version && echo "✓ Claude executable works" || echo "✗ Claude executable failed"

# Test settings are loaded (if claude has a way to verify)
# Note: May need to check logs or behavior since claude doesn't have --check-config

# Test specific hook functionality by creating test scenarios:
# Test rm block hook
echo 'echo "test"' > /tmp/test_rm_file
claude --non-interactive < <(echo "rm /tmp/test_rm_file") 2>&1 | grep -q "blocked\|denied" && echo "✓ rm block hook working" || echo "✗ rm block hook not working"

# Test file size hook
dd if=/dev/zero of=/tmp/large_test_file bs=1024 count=1000 2>/dev/null
claude --non-interactive < <(echo "Read /tmp/large_test_file") 2>&1 | grep -q "blocked\|large" && echo "✓ File size hook working" || echo "✗ File size hook not working"
rm -f /tmp/large_test_file

# Test permissions
claude --non-interactive < <(echo "Bash find . -name '*.nix'") && echo "✓ Allowed bash commands work" || echo "✗ Allowed bash commands blocked"
```

## Complete Validation Script

Create `scripts/validate-claude-migration.sh`:
```bash
#!/bin/bash
set -e

echo "🧪 Validating Claude Code Migration..."

# JSON validation
echo -n "Validating settings.json syntax... "
jq . nix/home/claude/settings.json > /dev/null && echo "✓" || (echo "✗" && exit 1)

# Flake validation
echo -n "Validating flake configuration... "
nix flake check && echo "✓" || (echo "✗" && exit 1)

# Home-manager build test
echo -n "Testing home-manager build... "
home-manager build --flake .#"$(whoami)@$(hostname -s)" > /dev/null && echo "✓" || (echo "✗" && exit 1)

# File placement after activation
if [ "$1" = "--post-activation" ]; then
    echo "🔍 Post-activation validation..."

    test -f ~/.claude/CLAUDE.md && echo "✓ Memory file exists" || (echo "✗ Memory file missing" && exit 1)
    test -f ~/.claude/settings.json && echo "✓ Settings file exists" || (echo "✗ Settings file missing" && exit 1)
    test -d ~/.claude/hooks && echo "✓ Hooks directory exists" || (echo "✗ Hooks directory missing" && exit 1)

    # Content validation
    jq -e '.permissions.allow | length > 0' ~/.claude/settings.json > /dev/null && echo "✓ Permissions configured" || (echo "✗ Permissions missing" && exit 1)

    # Basic functionality
    claude --version > /dev/null && echo "✓ Claude executable works" || (echo "✗ Claude executable failed" && exit 1)
fi

echo "✅ All validations passed!"
```

## Benefits

- **More maintained package source**: sadjow flake has automated hourly updates
- **Preserved functionality**: All current settings, hooks, and memory management retained
- **Cleaner dependencies**: Removes complex home-manager module dependency
- **Easier maintenance**: Settings in separate JSON file, not embedded in Nix
- **Flexibility**: Easier to customize configuration management approach
- **Automated validation**: Test scripts ensure migration doesn't break functionality

## Risks

- **Manual maintenance**: Configuration management becomes our responsibility
- **Potential breaking changes**: If activation script logic differs from Sewer56's implementation
- **Testing required**: Need to verify all hooks and settings work correctly

## File Structure After Migration

```
nix/home/claude/
├── default.nix          # Nix module with activation scripts
├── memory.md            # Claude memory content
└── settings.json        # Claude settings and hooks configuration
```

## Testing Checklist

- [ ] Extract settings.json and validate JSON syntax
- [ ] Switch flake input and validate flake builds
- [ ] Update Nix config and test home-manager builds
- [ ] Apply configuration with `hms`
- [ ] Run post-activation validation script
- [ ] Test Claude Code basic functionality
- [ ] Verify hook behavior with test scenarios
- [ ] Confirm all safety hooks are working

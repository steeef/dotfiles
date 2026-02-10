# Fish Shell Migration Plan Review

This review focuses on correctness, integration risk, maintainability, and performance. Claims are based on the current repository state and should be validated against live shell behavior.

## Findings (ordered by severity)

### 1) Current setup summary is inaccurate or incomplete (High)

**Why it matters**: The plan targets prompt and integration parity, but the summary does not match what is actually wired in the repo. That makes the migration target ambiguous and risks missing required behavior.

#### Evidence

- `nix/home/zsh/initExtraFirst.zsh` enables p10k instant prompt.
- `nix/home/symlinks.nix` symlinks `.p10k.zsh` from `zsh/p10k.zsh`.
- There is no explicit oh-my-posh initialization in zsh files; only config under `nix/home/oh-my-posh/`.
- Zsh integrations also exist in `nix/home/granted.nix` and `nix/home/nix-index.nix`.

#### Proposed change (diff)

```diff
--- a/migration-plan.md
+++ b/migration-plan.md
@@
-**Shell**: zsh with home-manager module at `nix/home/zsh/`
-**Prompt**: oh-my-posh using Catppuccin Macchiato theme (config at `nix/home/oh-my-posh/`)
-**Plugin Manager**: zgenom (10+ plugins)
-**Integrations**: atuin, fzf, direnv (all with zsh-specific hooks)
-**Custom Config**: 11 files in `~/.zsh/after/` (runtime, sourced by initExtra), 1 in `~/.zsh/before/`
+**Shell**: zsh with home-manager module at `nix/home/zsh/`
+**Prompt**: p10k instant prompt is enabled (`nix/home/zsh/initExtraFirst.zsh`) with `.p10k.zsh` symlinked from `zsh/p10k.zsh`; oh-my-posh config exists in `nix/home/oh-my-posh/` but is not explicitly initialized in zsh - verify at runtime
+**Plugin Manager**: zgenom (10+ plugins)
+**Integrations**: atuin, fzf, direnv, granted, nix-index (all with zsh integrations enabled)
+**Custom Config**: `zsh/after/` and `zsh/before/` in repo, symlinked to `~/.zsh/*` via `nix/home/symlinks.nix`; `~/.zshrc.d` is sourced for local overrides
```

### 2) Shell-agnostic env/path are missing (High)

**Why it matters**: Fish will not inherit critical environment variables and PATH unless moved into shell-agnostic config. Current values are defined inside zsh-specific files, which will break fish equivalence.

#### Evidence

- `nix/home/zsh/default.nix` sets `EDITOR`, `VISUAL`, `SUDO_EDITOR` only for zsh.
- `nix/home/zsh/initExtra.zsh` sets `PATH`, `LIBRARY_PATH`, `SSH_AUTH_SOCK`, `GRANTED_*`.
- `zsh/after/aws-vault.zsh` sets `AWS_VAULT_KEYCHAIN_NAME`.
- `zsh/after/nix-direnv.zsh` sets `DIRENV_WARN_TIMEOUT`.

#### Proposed change (diff)

```diff
--- a/migration-plan.md
+++ b/migration-plan.md
@@
 **Critical files to modify:**
 - `nix/home/default.nix` - remove `programs.fish.enable = false` block, add fish import
+
+### Phase 1.5: Normalize shared env/path (shell-agnostic)
+
+1. Move `EDITOR`, `VISUAL`, `SUDO_EDITOR` from `programs.zsh.sessionVariables` into `home.sessionVariables` so fish inherits them.
+2. Move `SSH_AUTH_SOCK`, `GRANTED_*`, `DIRENV_WARN_TIMEOUT`, and `AWS_VAULT_KEYCHAIN_NAME` into `home.sessionVariables` with OS conditionals (Darwin 1Password path vs Linux agent socket).
+3. Move PATH and `LIBRARY_PATH` mutations from `nix/home/zsh/initExtra.zsh` to `home.sessionPath`/`home.sessionVariables` (avoid `.zgenom/bin` in fish PATH; keep zsh-only if needed).
@@
-## Files to Modify
+## Files to Modify

-- `nix/home/default.nix` - add fish and starship imports, remove fish disable block
+- `nix/home/default.nix` - add fish/starship imports; move shared sessionVariables/sessionPath out of zsh
+- `nix/home/zsh/default.nix` - remove zsh-only sessionVariables once moved
+- `nix/home/zsh/initExtra.zsh` - drop PATH/SSH_AUTH_SOCK/GRANTED exports after migration
+- `zsh/after/aws-vault.zsh` - keep functions; move AWS_VAULT_KEYCHAIN_NAME to shell-agnostic env
+- `zsh/after/nix-direnv.zsh` - keep hook; move DIRENV_WARN_TIMEOUT to shell-agnostic env
+- `nix/home/symlinks.nix` - add `~/.config/fish` symlink (if using repo-managed fish configs)
 - `nix/home/atuin.nix` - add `enableFishIntegration = true`
 - `nix/home/fzf.nix` - add `enableFishIntegration = true`
 - `nix/home/direnv.nix` - already auto-enabled for fish (read-only flag, defaults to true)
@@
 ## Verification

 1. Run `hms` to apply fish config
 2. Open new terminal, verify fish launches (via terminal config or zsh bootstrap)
-3. Test each integration:
+3. Verify shared env and PATH in both fish and zsh (`echo $EDITOR`, `echo $SSH_AUTH_SOCK`, `echo $GRANTED_ALIAS_CONFIGURED`, `echo $DIRENV_WARN_TIMEOUT`, confirm `~/.local/bin` and `~/.bin` in PATH)
+4. Test each integration:
    - `atuin` history search works (press Up, verify history appears)
    - `fzf` keybindings work (Ctrl+R for history, Ctrl+T for file picker)
    - `direnv` activates in project directories (cd into a dir with `.envrc`, verify prompt shows direnv loaded)
-4. Test aliases - verify these work:
+5. Test aliases - verify these work:
@@
-5. Test functions - verify these work:
+6. Test functions - verify these work:
@@
-6. Verify starship prompt shows these segments:
+7. Verify starship prompt shows these segments:
@@
-7. **Performance check**: Test starship in large git repos (kubernetes, monorepos) - if slow, consider disabling git module for those directories
+8. **Performance check**: Test starship in large git repos (kubernetes, monorepos) - if slow, consider disabling git module for those directories
```

### 3) Missing goals and preflight audit (Medium)

**Why it matters**: The plan does not state the motivation for migrating, which affects whether the scope is justified. It also skips auditing local overrides, which can cause regressions.

#### Evidence

- `nix/home/zsh/initExtra.zsh` sources `~/.zshrc.d`, which is outside the repo and unknown to the plan.

#### Proposed change (diff)

```diff
--- a/migration-plan.md
+++ b/migration-plan.md
@@
 ## Overview

 Migrate from zsh (with oh-my-posh) to fish shell with starship prompt, maintaining the Catppuccin Macchiato theme and all existing integrations.

+## Goals & Non-goals
+
+**Goals**
+- State the motivation for fish (UX vs performance vs syntax) to justify the scope.
+- Preserve interactive UX parity (prompt segments, history search, keybindings).
+- Keep zsh usable as a rollback path.
+
+**Non-goals**
+- Rewriting non-interactive scripts to fish.
+- Removing zsh until fish is stable.
+
 ## Current Setup Summary
@@
 ## Implementation Steps

+### Phase 0: Preflight audit (before changes)
+1. Confirm the active prompt in a live zsh session (p10k vs oh-my-posh).
+2. Inventory `~/.zshrc.d` for local overrides to port or explicitly drop.
+3. Capture baseline prompt latency and git-status latency in a large repo for comparison.
+4. List zgenom plugin features that must be replaced in fish/starship.
+
 ### Phase 1: Create fish module structure
```

### 4) Aliases are not always a direct port (Medium)

**Why it matters**: Fish syntax differs for command substitution and quoting. Treating aliases as a direct port will cause functional breakage.

#### Evidence

- `zsh/after/aliases.zsh` uses command substitution in `drm`, `drmi`, and `grm`, which must be converted to fish `( ... )`.

#### Proposed change (diff)

```diff
--- a/migration-plan.md
+++ b/migration-plan.md
@@
-| Aliases | Low | Same syntax in fish |
+| Aliases | Medium | Mostly same syntax, but command substitution/quoting changes and `alias` vs `abbr` choices |
@@
-**Aliases (direct port - same syntax):**
+**Aliases (mostly direct port; update `$(...)` to `(...)`, decide between `alias` vs `abbr` for interactive-only shortcuts):**
```

### 5) fzf + atuin parity and binding conflicts (Medium)

**Why it matters**: The zsh widget has extra behavior (query prefill, ctrl-d reload) and fish fzf integration may conflict with Ctrl+R. Without a parity plan, the fish experience regresses.

#### Evidence

- `nix/home/zsh/initExtra.zsh` defines `fzf-atuin-history-widget` with custom reloads and query handling.
- `programs.fzf.enableFishIntegration` typically binds Ctrl+R unless disabled.

#### Proposed change (diff)

```diff
--- a/migration-plan.md
+++ b/migration-plan.md
@@
-This is NOT covered by `enableFishIntegration` alone. Create `fish/functions/fzf-atuin-history.fish`:
+This is NOT covered by `enableFishIntegration` alone. Disable the default fzf Ctrl+R binding and prevent atuin from auto-binding, then create `fish/functions/fzf-atuin-history.fish` with feature parity:
 ```fish
 function fzf-atuin-history
-    set -l selected (atuin search --cmd-only --limit 10000 | fzf --height 40% --reverse --tiebreak=index)
+    set -l query (commandline -b)
+    set -l atuin_opts "--cmd-only"
+    set -l height (set -q FZF_TMUX_HEIGHT; and echo $FZF_TMUX_HEIGHT; or echo "80%")
+    set -l fzf_opts --height=$height --tac --tiebreak=index --query="$query" \
+        --bind "ctrl-d:reload(atuin search $atuin_opts -c $PWD),ctrl-r:reload(atuin search $atuin_opts)"
+    set -l selected (atuin search $atuin_opts | fzf $fzf_opts)
     if test -n "$selected"
         commandline -r "$selected"
     end
     commandline -f repaint
 end
-
-# Bind to Ctrl+R (configured in fish/conf.d/keybindings.fish)
 ```

-Add `fish/conf.d/keybindings.fish` to Files to Create for this and other keybindings.
+In `fish/conf.d/keybindings.fish`:
+```fish
+set -gx ATUIN_NOBIND true
+bind --erase \cr
+bind \cr fzf-atuin-history
+bind \ce _atuin_search
+bind \cv edit_command_buffer
+```
```

### 6) Missing prompt modules and guardrails (Medium)

**Why it matters**: Several zgenom plugins add prompt cues (aws vault, nix shell). Without matching starship modules and prompt timeouts, the migration could lose important context or regress on performance.

#### Evidence

- `nix/home/zsh/initExtra.zsh` loads `blimmer/zsh-aws-vault` and `chisui/zsh-nix-shell`.
- The plan only calls out generic performance testing, not timeouts.

#### Proposed change (diff)

```diff
--- a/migration-plan.md
+++ b/migration-plan.md
@@
 1. Create `nix/home/starship/default.nix`
 2. Create `nix/home/starship/starship.toml` with Catppuccin Macchiato theme
+3. Use `right_format` to mirror the oh-my-posh right prompt layout
+4. Set `command_timeout` and `scan_timeout` to cap prompt latency in large repos
@@
 **Prompt elements to replicate from oh-my-posh.json:**
@@
 - Kubernetes context (with prod highlighting)
+- AWS profile (replaces zsh-aws-vault prompt cues)
+- Nix shell indicator (replaces zsh-nix-shell)
+- direnv status (optional, for at-a-glance env activation)
 - Command execution time
 - Exit status
 - Time
```

### 7) Fish config location needs explicit symlink pattern (Low)

**Why it matters**: Without mirroring the existing `nix/home/symlinks.nix` pattern, it is easy to edit the wrong files and lose runtime changes.

#### Proposed change (diff)

```diff
--- a/migration-plan.md
+++ b/migration-plan.md
@@
 - `nix/home/fish/*.nix` = home-manager module (requires `hms` rebuild)
-- `fish/` (in repo root) = runtime configs, symlinked to `~/.config/fish/` by home-manager (edit-and-source workflow, no rebuild needed for changes)
+- `fish/` (in repo root) = runtime configs, symlinked to `~/.config/fish/` via `nix/home/symlinks.nix` (mirrors `.zsh`), edit-and-source workflow (no rebuild needed for changes)
```

### 8) macOS login-shell note is too absolute (Low)

**Why it matters**: The statement says macOS rejects fish even when added to `/etc/shells`, but the repo currently only declares zsh as a valid shell. The plan should instruct to test and fall back instead of asserting a universal failure.

#### Evidence

- `nix/darwin/default.nix` sets `environment.shells = [pkgs.zsh];`

#### Proposed change (diff)

```diff
--- a/migration-plan.md
+++ b/migration-plan.md
@@
-**IMPORTANT**: macOS rejects fish as a login shell via `chsh` even when added to `/etc/shells`. Additionally, setting fish as the default shell breaks Home Manager shell integration modules (atuin, fzf, direnv).
+**NOTE**: macOS can reject non-standard shells. After adding fish to `environment.shells`, test `chsh -s` on this host; if it fails (or integrations misbehave), use one of the fallback options below.
```

## Open questions / assumptions

- Do you want the zsh fallback prompt to stay on p10k/oh-my-posh, or switch to starship for parity once fish is added?
- Is there anything in `~/.zshrc.d` that must be preserved in fish?
- Is fish intended to be interactive-only, or do you want to attempt default login shell once `chsh` is possible?

## Alternative framing

Treat this as a two-step migration: (1) normalize shell-agnostic env/path and adopt starship in zsh for prompt/perf parity, (2) add fish only after parity is proven. This isolates prompt work from shell changes and reduces risk.

## Change summary (brief)

- Align the plan with the actual prompt/integration wiring and repo symlink conventions.
- Add preflight + shell-agnostic env/path normalization with explicit verification steps.
- Preserve behavior in keybindings/atuin+fzf and expand starship modules with performance guardrails.

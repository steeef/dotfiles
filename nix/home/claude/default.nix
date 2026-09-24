# Claude Code configuration
#
# Hooks are provided by claude-hooks plugins resolved via extraKnownMarketplaces.
# Claude Code auto-installs enabled plugins from registered marketplaces at startup.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};

  claudeHooksPlugins = [
    "command-safety"
    "comment-style"
    "env-protection"
    "file-protection"
    "gh-formatting"
    "git-hooks"
  ];

  # command-safety's rm_check.py delegates "what to do instead of rm" guidance
  # to CLAUDE_HOOKS_RM_HANDLER (falls back to its own bundled TRASH/mv handler
  # if unset). Point it at our rkvr_handler.sh below so the fallback shown on
  # a blocked `rm` matches how we actually delete things on this machine.
  rkvrHandlerPath = "${config.home.homeDirectory}/.claude/hooks/rkvr_handler.sh";

  baseSettings =
    lib.importJSON ./settings.json
    // {
      enabledPlugins =
        lib.genAttrs
        (map (p: "${p}@claude-hooks") claudeHooksPlugins)
        (_: true)
        // {
          "ast-grep@ast-grep-marketplace" = true;
        };
    };
  baseSettingsFile = jsonFormat.generate "claude-code-base-settings.json" (
    baseSettings // {"$schema" = "https://json.schemastore.org/claude-code-settings.json";}
  );
in {
  # ClaudeCodeStatusLine (shows real 5h/7d rate limit usage)
  home.file.".claude/statusline.sh" = {
    source = ./statusline.sh;
    executable = true;
  };

  # Renames the herdr workspace for this pane to a Jira-style ticket key
  # (e.g. ENG-1234) detected in the session's first user prompt only — later
  # prompts never change it. Wired into hooks.UserPromptSubmit by the
  # herdrWorkspaceTicketHook activation script below (not declared in
  # settings.json directly — see that script's comment for why).
  home.file.".claude/hooks/herdr-workspace-ticket.sh" = {
    source = ./hooks/herdr-workspace-ticket.sh;
    executable = true;
  };

  # rm-block guidance handler for command-safety@claude-hooks (see
  # rkvrHandlerPath / CLAUDE_HOOKS_RM_HANDLER above).
  home.file.".claude/hooks/rkvr_handler.sh" = {
    source = ./hooks/rkvr_handler.sh;
    executable = true;
  };

  # PreToolUse guard for mirrored repos (see rules/repo-mirrors.md).
  home.file.".claude/hooks/repo-mirror-guard.py" = {
    source = ./hooks/repo-mirror-guard.py;
    executable = true;
  };

  # See AGENTS.md for PreCompact hook rationale.
  home.file.".claude/hooks/compact-instructions.sh" = {
    source = ./hooks/compact-instructions.sh;
    executable = true;
  };

  home.sessionVariables = {
    CLAUDE_HOOKS_RM_HANDLER = rkvrHandlerPath;
  };

  # Agent definitions (Nix-managed)
  home.file.".claude/agents/opus-reviewer.md" = {
    source = ./agents/opus-reviewer.md;
    force = true;
  };

  # Nix base settings (read-only reference for merge)
  home.file.".claude/settings.nix.json".source = baseSettingsFile;

  # Three-way merge Nix base into mutable settings.json on every hms
  # See merge-settings.sh for details
  home.activation.mergeClaudeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${./merge-settings.sh} \
      ${pkgs.jq}/bin/jq \
      "$HOME/.claude/settings.nix.json" \
      "$HOME/.claude/settings.nix.prev.json" \
      "$HOME/.claude/settings.json"
  '';

  # Symlink fnm default node/npm/npx/corepack into ~/.local/bin for non-interactive contexts (MCP)
  home.activation.linkFnmNode = lib.hm.dag.entryAfter ["writeBoundary"] ''
    fnm_bin="$HOME/.local/share/fnm/aliases/default/bin"
    target_dir="$HOME/.local/bin"
    if [ -d "$fnm_bin" ]; then
      run mkdir -p "$target_dir"
      for name in node npm npx corepack; do
        src="$fnm_bin/$name"
        target="$target_dir/$name"
        [ -f "$src" ] && [ -x "$src" ] || continue
        if [ -e "$target" ] && [ ! -L "$target" ]; then
          echo "refusing to replace non-symlink: $target" >&2
          exit 1
        fi
        run ln -sfn "$src" "$target"
      done
    fi
  '';

  # Wire herdr-workspace-ticket.sh into hooks.UserPromptSubmit only. Not
  # declared in settings.json directly: merge-settings.sh replaces hook
  # arrays wholesale rather than merging elements, which would clobber the
  # SessionStart entry herdr's own Claude integration already added, plus
  # context-mode-cache-heal.mjs's entry. Add-if-absent instead, matched on
  # the script's stable path. Also
  # strips any older SessionStart/UserPromptSubmit entries referencing this
  # script (from before it was narrowed to first-prompt-only) regardless of
  # the argv they were registered with.
  home.activation.herdrWorkspaceTicketHook = lib.hm.dag.entryAfter ["mergeClaudeSettings"] ''
    cs="$HOME/.claude/settings.json"
    jq="${pkgs.jq}/bin/jq"
    script="$HOME/.claude/hooks/herdr-workspace-ticket.sh"
    cmd="bash '$script'"

    if [ -f "$cs" ]; then
      run "$jq" --arg cmd "$cmd" '
        .hooks.SessionStart = ((.hooks.SessionStart // [])
          | map(select(((.hooks // [])[0].command? // "") | test("herdr-workspace-ticket\\.sh") | not)))
        | .hooks.UserPromptSubmit = ((.hooks.UserPromptSubmit // [])
            | map(select(
                (.hooks // [])[0].command? == $cmd
                or (((.hooks // [])[0].command? // "") | test("herdr-workspace-ticket\\.sh") | not)
              ))
            | if any(.[]; (.hooks // [])[0].command? == $cmd) then .
              else . + [{hooks: [{type: "command", command: $cmd, timeout: 10}]}]
              end)
      ' "$cs" > "$cs.tmp" && run mv "$cs.tmp" "$cs"
    fi
  '';

  # PreToolUse array is clobbered wholesale on merge.
  home.activation.repoMirrorGuardHook = lib.hm.dag.entryAfter ["mergeClaudeSettings"] ''
    cs="$HOME/.claude/settings.json"
    jq="${pkgs.jq}/bin/jq"
    cmd="${pkgs.python3}/bin/python3 $HOME/.claude/hooks/repo-mirror-guard.py"

    if [ -f "$cs" ]; then
      run "$jq" --arg cmd "$cmd" '
        .hooks.PreToolUse = ((.hooks.PreToolUse // [])
          | map(select(((.hooks // [])[0].command? // "") | test("repo-mirror-guard\\.py") | not))
          | . + [{matcher: "Bash", hooks: [{type: "command", command: $cmd, timeout: 5}]}])
      ' "$cs" > "$cs.tmp" && run mv "$cs.tmp" "$cs"
    fi
  '';

  # Use official home-manager claude-code module
  programs.claude-code = {
    enable = true;
    package = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # Settings managed via activation script merge (see below)
    # Custom skills directory
    skills = ./skills;
    # Path-scoped and unconditional rules (see rules/)
    rulesDir = ./rules;
    # Memory file for CLAUDE.md
    context = ./memory.md;
    # Custom output styles. Attr name sets the destination filename
    # (output-styles/<name>.md); the active-style lookup key is the
    # frontmatter `name` field, not this attr, so they're kept identical
    # to avoid a silent name mismatch.
    outputStyles.Brief = ./output-styles/brief.md;
  };
}

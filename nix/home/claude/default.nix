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
    "env-protection"
    "file-protection"
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
        (_: true);
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
  # (e.g. ENG-1234) detected in the session's git branch or prompt text.
  # Wired into hooks.SessionStart/UserPromptSubmit by the
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

  home.sessionVariables = {
    CLAUDE_HOOKS_RM_HANDLER = rkvrHandlerPath;
  };

  # Agent definitions (Nix-managed)
  home.file.".claude/agents/batch-reader.md" = {
    source = ./agents/batch-reader.md;
    force = true;
  };
  home.file.".claude/agents/budgeted-explore.md" = {
    source = ./agents/budgeted-explore.md;
    force = true;
  };
  home.file.".claude/agents/fable-reviewer.md" = {
    source = ./agents/fable-reviewer.md;
    force = true;
  };
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

  # Register codegraph as a user-scoped MCP server (macOS only). We do NOT use
  # programs.claude-code.mcpServers: that emits a --plugin-dir plugin whose MCP
  # server appears in `claude mcp list` but never loads into a real session
  # (verified). A ~/.claude.json entry (like coderabbit-docs) does load. Both
  # ~/.claude.json and the allowlist are mutable, Claude-owned, and NOT in the
  # Nix base, so we jq-merge idempotently on each hms rather than manage them
  # declaratively. Command is the stable profile path so the allowlist entry
  # (matched by exact serverCommand argv) survives codegraph version bumps.
  # Caveat: a Claude session writing ~/.claude.json concurrently with `hms`
  # could race this read-modify-write; low risk in practice (run hms when idle).
  # Runs after mergeClaudeSettings so it edits the post-merge settings.json.
  home.activation.codegraphMcp = lib.hm.dag.entryAfter ["mergeClaudeSettings"] (
    lib.optionalString pkgs.stdenv.isDarwin ''
      cg="${config.home.homeDirectory}/.nix-profile/bin/codegraph"
      cj="$HOME/.claude.json"
      cs="$HOME/.claude/settings.json"
      jq="${pkgs.jq}/bin/jq"

      # user-scoped MCP server entry (skip if ~/.claude.json not yet created)
      if [ -f "$cj" ]; then
        run "$jq" --arg cmd "$cg" '.mcpServers.codegraph = {
          type: "stdio", command: $cmd,
          args: ["serve", "--mcp", "--no-watch"],
          env: {CODEGRAPH_NO_DAEMON: "1", DO_NOT_TRACK: "1"}
        }' "$cj" > "$cj.tmp" && run mv "$cj.tmp" "$cj"
      fi

      # allowlist entry (strict allowlist; stdio matched by exact serverCommand),
      # add-if-absent since merge-settings.sh can't manage array elements
      if [ -f "$cs" ]; then
        run "$jq" --arg cmd "$cg" '
          .allowedMcpServers = ((.allowedMcpServers // [])
            | if any(.[]; .serverCommand[0]? == $cmd) then .
              else . + [{serverCommand: [$cmd, "serve", "--mcp", "--no-watch"]}]
              end)
        ' "$cs" > "$cs.tmp" && run mv "$cs.tmp" "$cs"
      fi
    ''
  );

  # Wire herdr-workspace-ticket.sh into hooks.SessionStart/UserPromptSubmit.
  # Not declared in settings.json directly: merge-settings.sh replaces hook
  # arrays wholesale rather than merging elements, which would clobber the
  # SessionStart entry herdr's own Claude integration already added, plus
  # context-mode-cache-heal.mjs's entry. Add-if-absent instead, matched on
  # the script's stable path, same approach as codegraphMcp above.
  home.activation.herdrWorkspaceTicketHook = lib.hm.dag.entryAfter ["mergeClaudeSettings"] ''
    cs="$HOME/.claude/settings.json"
    jq="${pkgs.jq}/bin/jq"
    script="$HOME/.claude/hooks/herdr-workspace-ticket.sh"

    add_ticket_hook() {
      cmd="bash '$script' $2"
      [ -f "$cs" ] || return 0
      run "$jq" --arg event "$1" --arg cmd "$cmd" '
        .hooks[$event] = ((.hooks[$event] // [])
          | if any(.[]; (.hooks // [])[0].command? == $cmd) then .
            else . + [{hooks: [{type: "command", command: $cmd, timeout: 10}]}]
            end)
      ' "$cs" > "$cs.tmp" && run mv "$cs.tmp" "$cs"
    }
    add_ticket_hook SessionStart session
    add_ticket_hook UserPromptSubmit prompt
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
    # NB: codegraph MCP is registered via the codegraphMcp activation script
    # below, NOT programs.claude-code.mcpServers. The module's mcpServers option
    # emits a --plugin-dir plugin whose MCP server shows in `claude mcp list`
    # but does NOT load into actual sessions (verified). A ~/.claude.json
    # user-scoped server (like coderabbit-docs) does load.
  };
}

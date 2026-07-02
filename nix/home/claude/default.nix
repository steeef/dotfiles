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

  # Agent definitions (Nix-managed)
  home.file.".claude/agents/batch-reader.md" = {
    source = ./agents/batch-reader.md;
    force = true;
  };
  home.file.".claude/agents/budgeted-explore.md" = {
    source = ./agents/budgeted-explore.md;
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

  # Use official home-manager claude-code module
  programs.claude-code = {
    enable = true;
    package = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # Settings managed via activation script merge (see below)
    # Custom skills directory
    skills = ./skills;
    # Memory file for CLAUDE.md
    context = ./memory.md;

    # CodeGraph MCP server — one-call structural queries (callers, blast radius,
    # symbol lookup) over the ~/wt worktree Claude is working in. Darwin-only
    # (pkgs.codegraph is macOS-only). --no-watch + CODEGRAPH_NO_DAEMON keep any
    # file watcher from leaking per ephemeral worktree; the server reconciles the
    # index on connect instead. Usage guidance lives in memory.md.
    #
    # command is the STABLE profile path, not `${pkgs.codegraph}/bin/codegraph`,
    # on purpose: ~/.claude/settings.json has a strict `allowedMcpServers`
    # allowlist (blocks every non-listed MCP, incl. plugin/stdio servers), and a
    # stdio server is allowlisted by exact `serverCommand` argv. A store path
    # would change on every version bump and silently drop codegraph from the
    # allowlist; the profile path keeps the one-time allowlist entry valid across
    # bumps. The allowlist entry itself lives in the mutable settings.json (not
    # the Nix base) — see reference_mcp_allowlist memory / the PR.
    mcpServers = lib.optionalAttrs pkgs.stdenv.isDarwin {
      codegraph = {
        type = "stdio";
        command = "${config.home.homeDirectory}/.nix-profile/bin/codegraph";
        args = ["serve" "--mcp" "--no-watch"];
        env = {
          CODEGRAPH_NO_DAEMON = "1";
          DO_NOT_TRACK = "1";
        };
      };
    };
  };
}

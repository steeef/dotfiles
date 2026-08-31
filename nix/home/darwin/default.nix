{pkgs, ...}: {
  targets.genericLinux.enable = false;

  home.packages = with pkgs; [
    bento4 # mp4decrypt — Apple Music DRM decrypt for gamdl (music tool)
    cmake
    codegraph # local code knowledge graph (MCP); see nix/home/claude for wiring
    colima
    docker
    docker-credential-helpers
    fatsort
    fswatch
    iterm2
    reattach-to-user-namespace
    terminal-notifier
    vale # prose linter; see nix/home/claude/skills/vale-check
  ];

  # CodeGraph: no detached auto-sync daemon (would leak a watcher per ephemeral
  # ~/wt worktree; the MCP server reconciles on connect instead), and no
  # telemetry. Inherited by interactive `codegraph` runs; the MCP server also
  # sets these in its own env block (nix/home/claude/default.nix).
  home.sessionVariables = {
    CODEGRAPH_NO_DAEMON = "1";
    DO_NOT_TRACK = "1";
  };

  home.shellAliases = {
    hms = "home-manager switch --flake $HOME/.dotfiles#$USER@$(hostname)";
    dr = "sudo darwin-rebuild switch --flake $HOME/.dotfiles";
  };

  imports = [
    ./iterm2
    ./aliasApplications.nix
    ./symlinks.nix
    ./vscode
    ./wezterm.nix
    # ./_1password.nix
  ];
}

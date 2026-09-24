{pkgs, ...}: {
  targets.genericLinux.enable = false;

  home.packages = with pkgs; [
    bento4 # mp4decrypt — Apple Music DRM decrypt for gamdl (music tool)
    cmake
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

  home.sessionVariables = {
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

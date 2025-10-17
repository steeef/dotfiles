{pkgs, ...}: {
  targets.genericLinux.enable = false;

  home.packages = with pkgs; [
    cmake
    colima
    docker
    docker-credential-helpers
    fatsort
    fswatch
    iterm2
    reattach-to-user-namespace
    terminal-notifier
  ];

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

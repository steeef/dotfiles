{pkgs, ...}: {
  targets.genericLinux.enable = false;

  home.packages = with pkgs; [
    cmake
    colima
    docker
    docker-credential-helpers
    fatsort
    fswatch
    ghostty
    iterm2
    reattach-to-user-namespace
  ];

  home.shellAliases = {
    hms = "home-manager switch --flake $HOME/.dotfiles#$USER@$(hostname)";
    dr = "darwin-rebuild switch --flake $HOME/.dotfiles";
  };

  imports = [
    ./iterm2
    ./aliasApplications.nix
    ./symlinks.nix
    ./vscode
    # ./_1password.nix
  ];
}

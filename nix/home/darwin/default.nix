{ pkgs, ... }: {
  targets.genericLinux.enable = false;

  home.packages = with pkgs; [
    cmake
    colima
    docker
    fswatch
    iterm2
    reattach-to-user-namespace
  ];

  home.shellAliases = {
    hms = "home-manager switch --flake $HOME/.dotfiles#$USER@macbook";
    dr = "darwin-rebuild switch --flake $HOME/.dotfiles";
  };


  imports = [
    ./iterm2
    ./aliasApplications.nix
    ./symlinks.nix
    ./vscode
    ./_1password.nix
  ];
}

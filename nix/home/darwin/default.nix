{ pkgs, ... }: {
  targets.genericLinux.enable = false;

  home.packages = with pkgs; [
    cmake
    fswatch
    iterm2
    mullvad-vpn
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
  ];
}

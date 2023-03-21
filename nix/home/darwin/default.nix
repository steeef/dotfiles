{ pkgs, ... }: {
  targets.genericLinux.enable = false;

  home.packages = with pkgs; [
    iterm2
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

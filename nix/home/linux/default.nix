{ pkgs, ... }: {
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    stdenv.cc.cc.lib
  ];

  home.shellAliases = {
    hms = "home-manager switch --flake $HOME/.dotfiles#$USER@linux";
  };
}

{ ... }: {
  targets.genericLinux.enable = true;

  home.shellAliases = {
    hms = "home-manager switch --flake $HOME/.dotfiles#$USER@linux";
  };
}

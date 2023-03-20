{ pkgs, ... }: {
  targets.genericLinux.enable = false;

  home.packages = with pkgs; [
    iterm2
  ];

  imports = [
    ./iterm2
  ];
}

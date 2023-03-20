{ ... }: {
  targets.genericLinux.enable = false;

  imports = [
    ./iterm2
  ];
}

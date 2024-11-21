{
  lib,
  pkgs,
  ...
}: {
  programs.oh-my-posh = {
    enable = true;
    useTheme = "powerlevel10k_rainbow";
  };
}

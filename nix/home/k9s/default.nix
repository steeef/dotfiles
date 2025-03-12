{
  config,
  pkgs,
  ...
}: {
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        ui.skin = "catppuccin-macchiato";
      };
    };
    skins = {
      catppuccin-macchiato = ./skin-catppuccin-macchiato.yaml;
    };
  };
}

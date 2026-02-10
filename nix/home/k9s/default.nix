{...}: {
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        defaultView = "v1/nodes";
        readOnly = true;
        ui.skin = "catppuccin-macchiato";
      };
    };
    skins = {
      catppuccin-macchiato = ./skin-catppuccin-macchiato.yaml;
    };
    views = {
      "v1/nodes" = {
        columns = [
          "NAME"
          "STATUS"
          "GROUP:.metadata.labels.tatari\\.tv/asg"
          "VERSION"
          "PODS"
          "AGE"
        ];
      };
    };
  };
}

{config, ...}: {
  home.file = {
    ".hammerspoon" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hammerspoon";
    };
    ".config/karabiner" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/karabiner";
    };
  };
}

{ config, ... }: {
  home.file = {
    ".config/nvim/init.lua" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/init.lua";
    };
    ".config/nvim/lua" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/lua";
    };
  };
}

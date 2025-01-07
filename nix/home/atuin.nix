{pkgs, ...}: {
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      filter_mode = "host";
      filter_mode_shell_up_key_binding = "session";
      inline_height = 50;
      keymap_mode = "vim-insert";
      search_mode = "skim";
      store_failed = false;
      sync = {
        records = true;
      };
      sync_frequency = "5m";
      sync_address = "https://atuin.steeef.net";
      update_check = false;
    };
  };
}

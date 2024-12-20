{pkgs, ...}: {
  programs.atuin = {
    enable = true;
    settings = {
      filter_mode = "host";
      filter_mode_shell_up_key_binding = "session";
      inline_height = 50;
      keymap_mode = "vim-insert";
      sync_frequency = "5m";
      sync_address = "https://atuin.steeef.net";
      update_check = false;
    };
  };
}

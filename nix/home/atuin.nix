{pkgs, ...}: {
  programs.atuin = {
    enable = true;
    settings = {
      sync_frequency = "5m";
      sync_address = "https://atuin.steeef.net";
      update_check = false;
    };
  };
}

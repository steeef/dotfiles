{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles.nix = {
      id = 0;
      settings = {
        "privacy.trackingprotection.enabled" = true;
        "signon.rememberSignons" = false;
      };
      userChrome = builtins.readFile ./userChrome.css;
    };
  };
}

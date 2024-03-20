{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles.nix = {
      id = 0;
      extensions = with pkgs.inputs.firefox-addons; [
        darkreader
        facebook-container
        multi-account-containers
        sidebery
        ublock-origin
      ];
      settings = {
        "privacy.trackingprotection.enabled" = true;
        "signon.rememberSignons" = false;
      };
      userChrome = builtins.readFile ./userChrome.css;
    };
  };
}

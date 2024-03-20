{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = null;
    profiles.nix = {
      id = 0;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        darkreader
        facebook-container
        multi-account-containers
        sidebery
        ublock-origin
      ];
      settings = {
        "general.warnOnAboutConfig" = false;
        "privacy.trackingprotection.enabled" = true;
        "signon.rememberSignons" = false;

        # disable DoH
        "network.trr.mode" = 5;

        # disable pocket
        "extensions.pocket.enabled" = false;
        "extensions.pocket.showHome" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;

        # theme
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.theme.content-theme" = 2;
        "browser.theme.toolbar-theme" = 2;
      };
      userChrome = builtins.readFile ./userChrome.css;
    };
  };
}

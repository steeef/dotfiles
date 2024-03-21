{ pkgs, ... }: {
  programs.firefox = {
    enable = false; # needs work
    package = null;
    profiles = {
      personal = {
        id = 0;
      };
      nix = {
        id = 1;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          add-custom-search-engine
          clearurls
          container-proxy
          darkreader
          don-t-fuck-with-paste
          facebook-container
          libredirect
          multi-account-containers
          onepassword-password-manager
          reddit-enhancement-suite
          sidebery
          streetpass-for-mastodon
          ublock-origin
          web-archives
        ];
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.warnOnQuit" = false;
          "browser.warnOnQuitShortcut" = false;
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

          # don't disable extensions on first run
          "extensions.autoDisableScopes" = 0;
        };
        userChrome = builtins.readFile ./userChrome.css;
      };
    };
  };
}

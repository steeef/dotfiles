{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = null;
    profiles.nix = {
      id = 0;
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
      };
      userChrome = builtins.readFile ./userChrome.css;
    };
  };
}

{
  lib,
  pkgs,
  machine,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = false;

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      trusted-substituters = [
        "cache.nixos.org"
        "nix-community.cachix.org"
      ];

      trusted-users = [
        "root"
        "sprice"
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      interval = {
        Weekday = 2;
        Hour = 11;
        Minute = 23;
      };
      options = "--delete-older-than 30d";
    };
  };

  environment = {
    # remove once https://github.com/LnL7/nix-darwin/pull/787 merged
    etc."pam.d/sudo_local".text = ''
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      auth       sufficient     pam_tid.so
    '';

    loginShell = "${pkgs.zsh}/bin/zsh";
    shells = [pkgs.zsh];

    systemPackages = with pkgs; [
      pam-reattach
    ];

    userLaunchAgents = {
      "com.user.backup.alpha.plist" = {
        enable = true;
        source = ./backup.alpha.plist;
      };
      "com.user.backup.beta.plist" = {
        enable = true;
        source = ./backup.beta.plist;
      };
      "com.user.backup.gamma.plist" = {
        enable = true;
        source = ./backup.gamma.plist;
      };
    };
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
    taps = [
      "homebrew/cask-versions"
      "homebrew/bundle"
      "homebrew/services"
    ];
    brews = [
      "mas"
      "ncdu"
      "pam-reattach"
      "vault"
    ];
    casks = [
      "1password"
      "alfred"
      "anylist"
      "balenaetcher"
      "blockblock"
      "calibre"
      "contexts"
      "elgato-stream-deck"
      "fantastical"
      "github"
      "hammerspoon"
      "hazel"
      "home-assistant"
      "istat-menus"
      "karabiner-elements"
      "mullvadvpn"
      "omnidisksweeper"
      "plex"
      "qlvideo"
      "slack"
      "steam"
      "swinsian"
      "vnc-viewer"
      "vlc"
      "xld"
      "xscreensaver"
      "yubico-authenticator"
    ];
    masApps = {
      "1password-for-safari" = 1569813296;
      "automounter" = 1160435653;
      "ivory-for-mastodon" = 6444602274;
      "paprika-recipe-manager-3" = 1303222628;
      "tailscale" = 1475387142;
      "velja" = 1607635845;
    };
  };

  # Whether to enable Enable sudo authentication with Touch ID
  # Waiting on https://github.com/LnL7/nix-darwin/pull/787 for Sonoma compatibility
  # security.pam.enableSudoTouchIdAuth = true;

  networking = {
    computerName = machine;
    hostName = machine;
    localHostName = machine;
  };

  programs.zsh = {
    enable = true;
  };

  services.nix-daemon.enable = true;

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      ShowStatusBar = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    LaunchServices.LSQuarantine = false;

    NSGlobalDomain = {
      AppleShowAllFiles = true;
      InitialKeyRepeat = 20;
      KeyRepeat = 2;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.swipescrolldirection" = false;

      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
    };
  };

  system.activationScripts.nix-darwin = {
    enable = true;
    text = lib.strings.fileContents ./activation_script.sh;
  };

  system.keyboard = {
    enableKeyMapping = true;
    userKeyMapping = [
      # remap Left Control to F19 as Hyper key for Hammerspoon
      {
        HIDKeyboardModifierMappingSrc = 30064771296;
        HIDKeyboardModifierMappingDst = 30064771182;
      }
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      fira-code
      hack-font
      (pkgs.nerdfonts.override {fonts = ["Mononoki"];})
      source-code-pro
      ttf-envy-code-r
    ];
  };

  system.activationScripts.alfred-preferences = {
    enable = true;
    text = ''
      defaults write com.runningwithcrayons.Alfred-Preferences NSNavLastRootDirectory -string  "~/.dotfiles/alfred"
    '';
  };
}

{
  lib,
  pkgs,
  machine,
  claude-code,
  username,
  ...
}: {
  nix = {
    settings = {
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
        username
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    optimise = {
      automatic = true;
    };
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

    shells = [pkgs.zsh];

    systemPackages = with pkgs; [
      pam-reattach
      claude-code.packages.${pkgs.system}.default
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
      "homebrew/bundle"
      "homebrew/services"
    ];
    brews = [
      "docker-credential-helper-ecr"
      "mas"
      "ncdu"
      "pam-reattach"
    ];
    casks =
      [
        "1password"
        "alfred"
        "anylist"
        "blockblock"
        "calibre"
        "cameracontroller"
        "contexts"
        "fantastical"
        "ghostty"
        "github"
        "hammerspoon"
        "hazel"
        "home-assistant"
        "istat-menus"
        "karabiner-elements"
        "mullvad-vpn"
        "omnidisksweeper"
        "plex"
        "qlvideo"
        "raspberry-pi-imager"
        "slack"
        "steam"
        "swinsian"
        "tailscale"
        "vnc-viewer"
        "vlc"
        "xld"
        "xscreensaver"
        "yubico-authenticator"
      ]
      ++ lib.optionals (machine == "ltm-3914") [
        "elgato-stream-deck"
      ];
    masApps = {
      "1password-for-safari" = 1569813296;
      "adguard-for-safari" = 1440147259;
      "automounter" = 1160435653;
      "dark-reader-for-safari" = 1438243180;
      "ivory-for-mastodon" = 6444602274;
      "paprika-recipe-manager-3" = 1303222628;
      "sink-it-for-reddit" = 6449873635;
      "unread" = 1363637349;
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
    packages = with pkgs; [
      fira-code
      hack-font
      jetbrains-mono
      nerd-fonts.mononoki
      source-code-pro
      ttf-envy-code-r
      terminus_font_ttf
    ];
  };

  system.activationScripts.alfred-preferences = {
    enable = true;
    text = ''
      defaults write com.runningwithcrayons.Alfred-Preferences NSNavLastRootDirectory -string  "~/.dotfiles/alfred"
    '';
  };
}

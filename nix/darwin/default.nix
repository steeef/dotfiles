{ lib, pkgs, machine, ... }: {
  nix = {
    settings = {
      auto-optimise-store = false;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment = {
    loginShell = "${pkgs.zsh}/bin/zsh";
    shells = [ pkgs.zsh ];

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
      "homebrew/cask-drivers"
      "homebrew/cask-versions"
      "homebrew/bundle"
      "homebrew/services"
    ];
    brews = [
      "mas"
      "pam-reattach"
    ];
    casks = [
      "1password"
      "aerial"
      "alfred"
      "anylist"
      "balenaetcher"
      "bartender"
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
      "lastfm"
      "mullvadvpn"
      "omnidisksweeper"
      "qlvideo"
      "slack"
      "steam"
      "swinsian"
      "virtualbox"
      "vnc-viewer"
      "vlc"
      "xld"
      "xscreensaver"
      "yubico-authenticator"
    ];
    masApps = {
      "tailscale" = 1475387142;
    };
  };

  # Whether to enable Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

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
      { HIDKeyboardModifierMappingSrc = 30064771296; HIDKeyboardModifierMappingDst = 30064771182; }
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      fira-code
      hack-font
      (pkgs.nerdfonts.override { fonts = [ "Mononoki" ]; })
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

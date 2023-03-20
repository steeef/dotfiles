{ lib, pkgs, machine, ... }: {
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-nix-path = nixpkgs=flake:nixpkg
    '';
  };

  environment = {
    loginShell = "${pkgs.zsh}/bin/zsh";
    shells = [ pkgs.zsh ];

    userLaunchAgents = {
      "com.user.backup.plist" = {
        enable = true;
        source = ./backup.plist;
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
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/bundle"
      "homebrew/core"
      "homebrew/services"
      "1password/tap"
    ];
    brews = [
      "libpng"
      "gettext"
      "pcre"
      "pkg-config"
      "gdbm"
      "readline"
      "tcl-tk"
      "xz"
      "autoconf"
      "automake"
      "libtool"
      "cmake"
      "fswatch"
      "gh"
      "hugo"
      "kubectx"
      "libevent"
      "nmap"
      "node"
      "openssl@1.1"
      "pam-reattach"
      "python3"
      "sox"
      "ykman"
      "ykpers"
    ];
    casks = [
      "1password"
      "1password-cli"
      "aerial"
      "alfred"
      "anylist"
      "aws-vault"
      "bartender"
      "blockblock"
      "calibre"
      "contexts"
      "dash"
      "elgato-stream-deck"
      "fantastical"
      "github"
      "hammerspoon"
      "hazel"
      "home-assistant"
      "istat-menus"
      "karabiner-elements"
      "font-fira-code"
      "font-fira-mono"
      "font-fira-sans"
      "font-mononoki-nerd-font"
      "lastfm"
      "mullvadvpn"
      "nvalt"
      "qlvideo"
      "slack"
      "steam"
      "swinsian"
      "vagrant"
      "virtualbox"
      "visual-studio-code-insiders"
      "vnc-viewer"
      "vlc"
      "xld"
      "xscreensaver"
      "yubico-authenticator"
    ];
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
}

{ pkgs, machine, ... }: {
  environment = {
    loginShell = "${pkgs.zsh}/bin/zsh";
    shells = [ pkgs.zsh ];
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
    brews = [
    ];
    casks = [
    ];
  };

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
      InitialKeyRepeat = 10;
      KeyRepeat = 2;

      com.apple = {
        mouse.tapBehavior = 1;
        swipescrolldirection = false;
      };

      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
    };
  };

  system.activationScripts.nix-darwin = {
    enable = true;
    text = ''
      defaults write com.apple.screensaver askForPassword -int 1
      defaults write com.apple.screensaver askForPasswordDelay -int 5
      defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
      defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
      defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
      defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
      defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"
      defaults write com.apple.finder WarnOnEmptyTrash -bool false
      defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    '';
  };
}

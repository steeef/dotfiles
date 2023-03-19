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
      "actionlint"
      "awscli"
      "libpng"
      "gettext"
      "pcre"
      "pkg-config"
      "gdbm"
      "readline"
      "sqlite"
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
      "lua-language-server"
      "marksman"
      "nmap"
      "node"
      "openssl@1.1"
      "pam-reattach"
      "python3"
      "rdiff-backup"
      "shellcheck"
      "shfmt"
      "sox"
      "terraform-ls"
      "tflint"
      "yaml-language-server"
      "ykman"
      "ykpers"
    ];
    casks = [
      "1password"
      "1password-cli"
      "alfred"
      "aws-vault"
      "bartender"
      "blockblock"
      "calibre"
      "contexts"
      "dash"
      "hammerspoon"
      "hazel"
      "istat-menus"
      "iterm2"
      "karabiner-elements"
      "font-fira-code"
      "font-fira-mono"
      "font-fira-sans"
      "font-mononoki-nerd-font"
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
      InitialKeyRepeat = 10;
      KeyRepeat = 2;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.swipescrolldirection" = false;

      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
    };
  };

  system.activationScripts.nix-darwin = {
    enable = true;
    text = ''
      # cool stuff from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
      #
      defaults write com.apple.screensaver askForPassword -int 1
      defaults write com.apple.screensaver askForPasswordDelay -int 5
      defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
      defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"
      defaults write com.apple.finder WarnOnEmptyTrash -bool false
      defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
      # Disable smart quotes as it’s annoying for messages that contain code
      defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
      # disable boot sound
      nvram SystemAudioVolume=" "
      # power settings
      # battery
      pmset -b displaysleep 2 sleep 5 disksleep 10 womp 0
      # AC
      pmset -c displaysleep 20 sleep 0 disksleep 0 womp 1
      # standby delay to 1 day
      pmset -a standbydelay 86400
      # disable hibernation
      pmset -a hibernatemode 0
      # disable sleep
      systemsetup -setcomputersleep Never 2>/dev/null
      # Enable snap-to-grid for icons on the desktop and in other icon views
      /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
      /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
      /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
      # Show the ~/Library folder
      chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library
      chflags nohidden /Volumes
      # disable Spotlight for attached volumes
      defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
      # Software Update
      defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
      defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
      defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
      defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
      defaults write com.apple.commerce AutoUpdate -bool true
    '';
  };
}

#!/usr/bin/env bash

set -e

# https://github.com/0xmachos/dotfiles

function get_sudo {

  # Ask user to input password to get sudo privilege
  # Update user's cached credentials, adds five (5)
  #   minutes to sudo timeout (-v)
  # Paramter: 
  #  $purpose_string REQUIRED
  #   Descibe why sudo is needed 

  local purpose_string=${1:?$purpose_string not passed to get_sudo}
  
  if sudo --prompt="[⚠️ ] Password required ${purpose_string}: " -v; then
    # !! SUDO !!
    return 0
  else 
    return 1
  fi
}

function enable_touchid_sudo {
  # enable_touchid_sudo
  #   Check if already enabled in /etc pam.d/sudo
  #   Use vim to insert required text to sudo
  
  if grep -q 'pam_tid.so' /etc/pam.d/sudo; then
    echo "[✅] TouchID Sudo Already Enabled"
    return 0
  fi

  if sudo ex -s -c '2i|auth       sufficient     pam_tid.so' -c x! -c x! /etc/pam.d/sudo; then
    # Invoke Vim in ex mode
    # Select line 2, enter insert mode, insert that text write changes and exit
    # Need to exit twice to get passed the read only file warning
    echo "[✅] TouchID Sudo Enabled"
  else
    echo "[❌] Failed to enable TouchID Sudo"
  fi
}

enable_touchid_sudo

defaults write com.apple.finder AppleShowAllFiles YES
chflags nohidden "${HOME}/Library"

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

get_sudo "to set defaults"

sudo defaults write com.apple.finder AppleShowAllFiles -bool true
sudo defaults write com.apple.finder AppleShowAllFiles TRUE
sudo defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
sudo defaults write com.apple.finder ShowStatusBar -bool true
sudo defaults write com.apple.finder WarnOnEmptyTrash -bool false

sudo defaults write com.apple.screensaver askForPassword -int 1
sudo defaults write com.apple.screensaver askForPasswordDelay -int 5

sudo defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# touchpad setup
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write -g com.apple.swipescrolldirection -bool FALSE

sudo defaults write NSGlobalDomain KeyRepeat -int 0
sudo defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
sudo defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"

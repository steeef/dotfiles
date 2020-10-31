#!/usr/bin/env bash

set -e

defaults write com.apple.finder AppleShowAllFiles YES
chflags nohidden "${HOME}/Library"

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

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
defaults write -g com.apple.swipescrolldirection -bool FALSE

sudo defaults write NSGlobalDomain KeyRepeat -int 0
sudo defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
sudo defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

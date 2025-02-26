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
pmset -b displaysleep 2 sleep 5 disksleep 10 womp 0 powernap 0
# AC
pmset -c displaysleep 20 sleep 0 disksleep 0 womp 0 powernap 0
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

# menu bar spacing
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 5
defaults -currentHost write -globalDomain NSStatusSelectionPadding -int 5

# Unread App: add shortcuts
defaults write com.goldenhillsoftware.Unread2 NSUserKeyEquivalents -dict-add "Next Source" -string "@j"
defaults write com.goldenhillsoftware.Unread2 NSUserKeyEquivalents -dict-add "Previous Source" -string "@k"

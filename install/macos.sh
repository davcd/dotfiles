#!/bin/sh

SCREENSHOTS_FOLDER="${HOME}/Screenshots"

brew install dockutil mysides

# Dock
defaults write com.apple.dock "orientation" -string "bottom"
defaults write com.apple.dock "tilesize" -int "60"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "autohide-time-modifier" -float "0.5"
defaults write com.apple.dock "autohide-delay" -float "0.2"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock "mineffect" -string "genie"
defaults write com.apple.dock "scroll-to-open" -bool "true"

dockutil --no-restart --remove all
if [ -e "/System/Applications/System Settings.app" ]; then dockutil --no-restart --add "/System/Applications/System Settings.app"; fi
if [ -e "/System/Applications/Photos.app" ]; then dockutil --no-restart --add "/System/Applications/Photos.app"; fi
if [ -e "/System/Applications/Launchpad.app" ]; then dockutil --no-restart --add "/System/Applications/Launchpad.app"; fi
if [ -e "/System/Applications/Calendar.app" ]; then dockutil --no-restart --add "/System/Applications/Calendar.app"; fi
if [ -e "/Applications/Notion.app" ]; then dockutil --no-restart --add "/Applications/Notion.app"; fi
if [ -e "/Applications/Obsidian.app" ]; then dockutil --no-restart --add "/Applications/Obsidian.app"; fi
if [ -e "/System/Applications/Notes.app" ]; then dockutil --no-restart --add "/System/Applications/Notes.app"; fi
if [ -e "/Applications/Google Chrome.app" ]; then dockutil --no-restart --add "/Applications/Google Chrome.app"; fi
if [ -e "/System/Applications/Mail.app" ]; then dockutil --no-restart --add "/System/Applications/Mail.app"; fi
if [ -e "/Applications/iTerm.app" ]; then dockutil --no-restart --add "/Applications/iTerm.app"; fi
if [ -e "/Applications/Visual Studio Code.app" ]; then dockutil --no-restart --add "/Applications/Visual Studio Code.app"; fi
if [ -e "/Applications/IntelliJ IDEA.app" ]; then dockutil --no-restart --add "/Applications/IntelliJ IDEA.app"; fi
if [ -e "/Applications/Postman.app" ]; then dockutil --no-restart --add "/Applications/Postman.app"; fi
if [ -e "/Applications/Slack.app" ]; then dockutil --no-restart --add "/Applications/Slack.app"; fi
if [ -e "/Applications/WhatsApp.app" ]; then dockutil --no-restart --add "/Applications/WhatsApp.app"; fi
if [ -e "/Applications/zoom.us.app" ]; then dockutil --no-restart --add "/Applications/zoom.us.app"; fi
if [ -e "/Applications/Spotify.app" ]; then dockutil --no-restart --add "/Applications/Spotify.app"; fi

# Finder
defaults write com.apple.finder "QuitMenuItem" -bool "false"
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
defaults write com.apple.finder "FinderSpawnTab" -bool "true"
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "false"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "2"
defaults write com.apple.finder ShowRecentTags -bool false
for item in $(mysides list | awk '{print $1}'); do
  mysides remove "$item"
done
mysides add Projects file://${HOME}/Projects/
mysides add Home file://${HOME}/
mysides add Applications file:///Applications/
mysides add Documents file://${HOME}/Documents/
mysides add Downloads file://${HOME}/Downloads/

# Screenshots
defaults write com.apple.screencapture "disable-shadow" -bool "true"
defaults write com.apple.screencapture "include-date" -bool "true"
mkdir -p "${SCREENSHOTS_FOLDER}"
defaults write com.apple.screencapture "location" -string "${SCREENSHOTS_FOLDER}"
defaults write com.apple.screencapture "show-thumbnail" -bool "true"
defaults write com.apple.screencapture "type" -string "png"

# Trackpad
defaults write NSGlobalDomain "com.apple.swipescrolldirection" -bool false

# Keyboard
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "true"
defaults write com.apple.HIToolbox AppleFnUsageType -int "2"
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"

# Mouse
defaults write NSGlobalDomain "com.apple.mouse.scaling" -float "1.5"

# Calendar
defaults write com.apple.iCal "first day of week" -int 1

# Safari
defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true"

# Control center
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

for app in "Dock" "Finder" "SystemUIServer" "Calendar" "Safari"; do
  killall "${app}" &> /dev/null
done
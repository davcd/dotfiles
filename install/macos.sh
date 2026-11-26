#!/bin/bash

SCREENSHOTS_FOLDER="${HOME}/Screenshots"

brew install dockutil

# Dock
defaults write com.apple.dock "orientation" -string "bottom"
defaults write com.apple.dock "tilesize" -int "60"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "autohide-time-modifier" -float "0.5"
defaults write com.apple.dock "autohide-delay" -float "0.2"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock "mineffect" -string "genie"
defaults write com.apple.dock "scroll-to-open" -bool "true"

DOCK_APPS=(
  "/System/Applications/System Settings.app"
  "/System/Applications/Photos.app"
  "/System/Applications/Launchpad.app"
  "/System/Applications/Calendar.app"
  "/System/Applications/Mail.app"
  "/Applications/Notion.app"
  "/Applications/Obsidian.app"
  "/System/Applications/Notes.app"
  "/Applications/Google Chrome.app"
  "/Applications/iTerm.app"
  "/Applications/Visual Studio Code.app"
  "/Applications/IntelliJ IDEA.app"
  "/Applications/Slack.app"
  "/Applications/WhatsApp.app"
  "/Applications/zoom.us.app"
  "/Applications/Spotify.app"
)

dockutil --no-restart --remove all
for app in "${DOCK_APPS[@]}"; do
  [ -e "$app" ] && dockutil --no-restart --add "$app"
done

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

# Control center
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

for app in "Dock" "Finder" "SystemUIServer" "Calendar" "Safari"; do
  killall "${app}" >/dev/null 2>&1
done
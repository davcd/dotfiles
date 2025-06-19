#!/bin/sh

update_ssh_config() {
  local host=$1
  shift
  local config_lines=()
  for line in "$@"; do
    config_lines+=("  $line")
  done

  if grep -q "^Host $host\$" "$HOME/.ssh/config"; then
    sed -i '' "/^Host $host\$/,/^Host \|^\$/d" "$HOME/.ssh/config"
  fi

  {
    echo "Host $host"
    for cl in "${config_lines[@]}"; do
      echo "$cl"
    done
  } >> "$HOME/.ssh/config"
}


brew install git git-extras

if [ -e "$HOME/.gitconfig_base" ]; then
    mv "$HOME/.gitconfig_base" "$HOME/.gitconfig_base.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sf "$DOTFILES_CONFIG/.gitconfig_base" "$HOME/.gitconfig_base"

if [ -e "$HOME/.gitignore_global" ]; then
    mv "$HOME/.gitignore_global" "$HOME/.gitignore_global.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sf "$DOTFILES_CONFIG/.gitignore_global" "$HOME/.gitignore_global"

# Ssh folder initialization
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$HOME/.ssh/config" ]; then
    touch "$HOME/.ssh/config"
fi

# Configure authentication
SSH_AUTH_KEY_NAME="$MACHINE_ID-auth-key-github-com"
if [ ! -f "$HOME/.ssh/$SSH_AUTH_KEY_NAME" ]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$HOME/.ssh/$SSH_AUTH_KEY_NAME" -N ""
  cat "$HOME/.ssh/$SSH_AUTH_KEY_NAME.pub" | gh ssh-key add --title "$SSH_AUTH_KEY_NAME" --type authentication -
fi

update_ssh_config "github.com" "AddKeysToAgent yes" "UseKeychain yes" "IdentityFile ~/.ssh/$SSH_AUTH_KEY_NAME"
eval "$(ssh-agent -s)"
ssh -T git@github.com || true

# Configure signing
SSH_SIGN_KEY_NAME="$MACHINE_ID-sign-key-git"
if [ ! -f "$HOME/.ssh/$SSH_SIGN_KEY_NAME" ]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$HOME/.ssh/$SSH_SIGN_KEY_NAME" -N ""
  cat "$HOME/.ssh/$SSH_SIGN_KEY_NAME.pub" | gh ssh-key add --title "$SSH_SIGN_KEY_NAME" --type signing -
fi

# Global git config
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global user.signingkey "~/.ssh/$SSH_SIGN_KEY_NAME.pub"
git config --global gpg.format ssh
git config --global commit.gpgsign true
git config --global include.path "~/.gitconfig_base"

#!/bin/bash

# Git hosts to set up, one auth key per host (can be overridden in .env)
GIT_HOSTS="${GIT_HOSTS:-github.com}"

# Replace (or add) the ssh config block of a host
update_ssh_config() {
  local host=$1; shift
  local config="$HOME/.ssh/config"

  touch "$config"
  awk -v h="$host" '$1 == "Host" { skip = ($2 == h) } !skip' "$config" > "$config.tmp"
  mv "$config.tmp" "$config"
  chmod 600 "$config"

  { echo "Host $host"; printf '  %s\n' "$@"; echo; } >> "$config"
}

# Upload a public key to a git host, or tell how to do it manually
upload_key() {
  local host=$1 key=$2 type=$3
  gh auth status --hostname "$host" >/dev/null 2>&1 \
    || gh auth login --hostname "$host" --git-protocol ssh --scopes admin:public_key,admin:ssh_signing_key
  GH_HOST="$host" gh ssh-key add "$key.pub" --title "$(basename "$key")" --type "$type" \
    || echo "Could not upload $key.pub, add it manually at https://$host/settings/keys"
}

brew install git git-extras

link-file "$DOTFILES_CONFIG/.gitconfig_base" "$HOME/.gitconfig_base"

link-file "$DOTFILES_CONFIG/.gitignore_global" "$HOME/.gitignore_global"

# Ssh folder initialization
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Configure authentication, one key per host
for host in $GIT_HOSTS; do
  key="$HOME/.ssh/$MACHINE_ID-auth-key-${host//./-}"
  if [ ! -f "$key" ]; then
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$key" -N ""
    upload_key "$host" "$key" authentication
  fi

  update_ssh_config "$host" "User git" "StrictHostKeyChecking accept-new" "AddKeysToAgent yes" \
    "UseKeychain yes" "IdentitiesOnly yes" "IdentityFile ~/.ssh/$(basename "$key")"
  ssh -o BatchMode=yes -T "git@$host" || true
done

# Configure signing (the same key is registered in every host)
SSH_SIGN_KEY="$HOME/.ssh/$MACHINE_ID-sign-key-git"
if [ ! -f "$SSH_SIGN_KEY" ]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_SIGN_KEY" -N ""
  for host in $GIT_HOSTS; do
    upload_key "$host" "$SSH_SIGN_KEY" signing
  done
fi

# Allow verifying our own signatures locally (git log --show-signature)
echo "$GIT_EMAIL $(cat "$SSH_SIGN_KEY.pub")" > "$HOME/.ssh/allowed_signers"

# Global git config
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global user.signingkey "~/.ssh/$(basename "$SSH_SIGN_KEY").pub"
git config --global gpg.format ssh
git config --global gpg.ssh.allowedSignersFile "~/.ssh/allowed_signers"
git config --global commit.gpgsign true
git config --global include.path "~/.gitconfig_base"

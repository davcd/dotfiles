#!/bin/sh

brew install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/themes"
mkdir -p "$ZSH_CUSTOM/plugins"

if [ -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
    rm -rf "$ZSH_CUSTOM/themes/spaceship-prompt"
fi
if [ -L "$ZSH_CUSTOM/themes/spaceship.zsh-theme" ]; then
    rm -f "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    rm -rf "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    rm -rf "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

if [ -e "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sf "$DOTFILES_CONFIG/.zshrc" "$HOME/.zshrc"

if [ -e "$HOME/.zsh_aliases" ]; then
    mv "$HOME/.zsh_aliases" "$HOME/.zsh_aliases.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sf "$DOTFILES_CONFIG/.zsh_aliases" "$HOME/.zsh_aliases"

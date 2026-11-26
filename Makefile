export DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
export DOTFILES_CONFIG := $(DOTFILES_DIR)/config
export PATH := $(DOTFILES_DIR)/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$(PATH)

LANGUAGES := java python go node

# Run an install script with the variables of .env (if any) in its environment
run = set -a && if [ -f $(DOTFILES_DIR)/.env ]; then . $(DOTFILES_DIR)/.env; fi && set +a && bash $(DOTFILES_DIR)/install/$(1)

.PHONY: all compatible brew brew-packages cask-apps git gh gh-auth language-setup $(LANGUAGES) zsh projects-setup macos

all: compatible brew brew-packages cask-apps git language-setup zsh projects-setup macos

compatible:
	is-macos || (echo "This Makefile is only compatible with macOS." && exit 1)

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || echo "Warning: some Homebrew packages failed to install"

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || echo "Warning: some Homebrew casks failed to install"

gh: brew
	is-executable gh || brew install gh

gh-auth: gh
	gh auth status >/dev/null 2>&1 || gh auth login

git: gh
	$(call run,git.sh)

language-setup: $(LANGUAGES)

$(LANGUAGES): brew
	$(call run,language/$@.sh)

zsh: brew
	$(call run,zsh.sh)

projects-setup: gh-auth
	$(call run,projects.sh)

macos: brew
	$(call run,macos.sh)

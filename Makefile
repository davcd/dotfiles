export DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
export DOTFILES_CONFIG := $(DOTFILES_DIR)/config
export PATH := $(DOTFILES_DIR)/bin:$(PATH)

ENV_SETUP := set -a && \
    if [ -f ./.env ]; then . ./.env; fi && \
    set +a

all: compatible brew brew-packages cask-apps git language-setup zsh projects-setup macos

compatible:
	is-macos || (echo "This Makefile is only compatible with macOS." && exit 1)

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true

git: brew gh
	$(ENV_SETUP) && sh $(DOTFILES_DIR)/install/git.sh

gh:
	is-executable gh || brew install gh
	$(ENV_SETUP) && if [ -z "$$GH_TOKEN" ]; then \
		echo "Error: GH_TOKEN environment variable is not set."; \
		exit 1; \
	fi

language-setup: java python go node

java: brew
	$(ENV_SETUP) && sh $(DOTFILES_DIR)/install/language/java.sh

python: brew
	$(ENV_SETUP) && sh $(DOTFILES_DIR)/install/language/python.sh

go: brew
	$(ENV_SETUP) && sh $(DOTFILES_DIR)/install/language/go.sh

node:
	$(ENV_SETUP) && sh $(DOTFILES_DIR)/install/language/node.sh

zsh: brew
	$(ENV_SETUP) && sh $(DOTFILES_DIR)/install/zsh.sh

projects-setup: gh
	$(ENV_SETUP) && sh $(DOTFILES_DIR)/install/projects.sh

macos: brew
	$(ENV_SETUP) && sh $(DOTFILES_DIR)/install/macos.sh

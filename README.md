# Dotfiles

My personal dotfiles repository for macOS.

The goal of this project is to speed up the setup of a new laptop and centralize common configuration files (via symlinks).

## What?
- **Homebrew**
  - Install command-line packages using Homebrew
  - Install applications using Homebrew Cask
- **Git**
  - Set up a base `.gitconfig` and configure user details
  - Define global `.gitignore`
  - Set up SSH keys
    - Authorization
    - Signing
- **Zsh**
  - Install Oh My Zsh
  - Install plugins
  - Install and configure spaceship theme
  - Define common aliases
  - Enable lazy loading for language tools
- **Languages**
  - Install and configure version managers
    - Java (Sdkman)
    - Node.js (Nvm)
    - Python (Pyenv)
    - Go (Gvm)
- **MacOS**
  - Apply system settings and preferences
- **Projects**
  - Clone personal GitHub repositories

## How?

1. On a fresh installation of macOS, run:

```shell 
sudo softwareupdate -i -a
xcode-select --install
```

2. Copy `.env.example` to `.env` and update it with your environment variables.
3. Run the desired `make` scripts. To execute all setup scripts, use:

 ```shell
 make all
 ```

## Roadmap

- Add support for more languages and tools

### Inspiration

- https://github.com/webpro/dotfiles
- https://github.com/spences10/dotfiles/tree/main
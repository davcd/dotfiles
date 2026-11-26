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
    - Authorization (one key per host listed in `GIT_HOSTS`)
    - Signing
- **Zsh**
  - Install Oh My Zsh
  - Install plugins
  - Install and configure spaceship theme
  - Define common aliases
  - Put the default version of each language in `PATH` and lazy load only the version managers
  - Skip the prompt and plugins in non-interactive shells (scripts, tools)
- **Languages**
  - Install the latest release of each major listed in `install/language/versions.env`
  - Install and configure version managers
    - Java (Sdkman)
    - Node.js (Nvm)
    - Python (Pyenv)
    - Go (Gvm)
- **MacOS**
  - Apply system settings and preferences
- **Projects**
  - Clone personal GitHub repositories (asks for `gh auth login` if needed)

## How?

1. On a fresh installation of macOS, run:

```shell 
sudo softwareupdate -i -a
xcode-select --install
```

2. Copy `.env.example` to `.env` and update it with your variables (key prefix, git hosts, name and email).
3. Run the desired `make` targets. To execute all setup scripts, use:

 ```shell
 make all
 ```

 Or just one of them: `brew-packages`, `cask-apps`, `git`, `language-setup` (or `java`, `python`, `go`, `node`), `zsh`, `projects-setup`, `macos`.

The scripts are written to be re-runnable. Git SSH keys that are created are uploaded with `gh`; if that is not possible, the public key path and where to add it are printed.

## Roadmap

- Add support for more languages and tools

### Inspiration

- https://github.com/webpro/dotfiles
- https://github.com/spences10/dotfiles/tree/main
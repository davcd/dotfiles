# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Path management
path=(
  "$HOME/bin"
  $path
)
export PATH

# Language runtimes
# The default version of each one goes straight into PATH (no manager involved), so scripts,
# make, git hooks and other child processes can find it. The managers themselves are only
# loaded the first time you call them.
lazy_load() {
  eval "function $1 { unset -f $1; $2; $1 \"\$@\"; }"
}

# Node (nvm): the default alias is a major (e.g. 26), pick the newest installed version of it
export NVM_DIR="$HOME/.nvm"
() {
  setopt local_options null_glob numeric_glob_sort
  [[ -r $NVM_DIR/alias/default ]] || return
  local v=${$(<$NVM_DIR/alias/default)#v}
  local -a dirs=($NVM_DIR/versions/node/v${v}(|.*)(/On[1]))
  (( $#dirs )) && path=($dirs[1]/bin $path)
}
lazy_load nvm '[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"'

# Java (sdkman)
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -d $SDKMAN_DIR/candidates/java/current ]]; then
  export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
  path=($JAVA_HOME/bin $path)
fi
lazy_load sdk '[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"'

# Python (pyenv): shims are enough to run the selected version
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/shims ]] && path=($PYENV_ROOT/shims $path)
lazy_load pyenv 'eval "$(pyenv init -)"; eval "$(pyenv virtualenv-init -)"'

# Go (gvm): the default environment only exports GOROOT, GOPATH and PATH
export GVM_DIR="$HOME/.gvm"
[[ -r $GVM_DIR/environments/default ]] && source "$GVM_DIR/environments/default"
lazy_load gvm '[[ -s "$GVM_DIR/scripts/gvm" ]] && source "$GVM_DIR/scripts/gvm"'

# Zsh extra config (machine specific). Also loaded by non-interactive shells such as
# the ones Claude Code starts, so guard interactive-only things yourself
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Everything below is only needed in a real terminal (prompt, plugins, aliases, completions)
[[ -o interactive ]] || return

# Performance optimizations
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
ZSH_DISABLE_COMPFIX="true"

# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Theme config
ZSH_THEME="spaceship"

# Spaceship settings
SPACESHIP_PROMPT_PRECOMPILE=false
SPACESHIP_PROMPT_ASYNC=false
SPACESHIP_PROMPT_ADD_NEWLINE=false

# Minimal spaceship sections for performance
SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  git
  line_sep
  char
)

# Carefully ordered plugins (syntax highlighting must be last)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Autosuggest settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Zsh aliases
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

# Fuzzy finder and smarter cd
command -v fzf >/dev/null && source <(fzf --zsh)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

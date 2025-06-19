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
SPACESHIP_PROMPT_ADD_NEWLINE=true

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

# Path management
path=(
  "$HOME/bin"
  $path
)
export PATH

# Zsh extra config
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Zsh aliases
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

# Lazy loading helper function
lazy_loading() {
  local init_snippet=$1; shift
  local cmds=("$@")
  local loader="${cmds[1]}_lazy_load"

  eval '
  function '"$loader"'() {
    for c in '"${cmds[*]}"'; do
      unset -f "$c" 2>/dev/null || true
    done
    '"$init_snippet"'
    "$@"
  }'

  for c in "${cmds[@]}"; do
    eval "function $c { $loader \"$c\" \"\$@\"; }"
  done
}

# Pyenv config
export PYENV_ROOT="$HOME/.pyenv"
lazy_loading 'eval "$(pyenv init --path)"; eval "$(pyenv init -)"; eval "$(pyenv virtualenv-init -)"' pyenv python python3 pip pip3

# Nvm config
export NVM_DIR="$HOME/.nvm"
lazy_loading '[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"' nvm node npm npx yarn

# Sdkman config
export SDKMAN_DIR="$HOME/.sdkman"
lazy_loading '[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"' sdk java javac gradle maven

# Gvm config
export GVM_DIR="$HOME/.gvm"
lazy_loading '[[ -s "$GVM_DIR/scripts/gvm" ]] && source "$GVM_DIR/scripts/gvm"' gvm go

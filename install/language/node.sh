#!/bin/bash
. "$(dirname "$0")/versions.env"

if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

for major in $NODE_MAJORS; do
  nvm install "$major" --skip-default-packages --latest-npm
done

nvm alias default "$NODE_DEFAULT"

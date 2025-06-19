#!/bin/sh

if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi

nvm install 20 --skip-default-packages --latest-npm
nvm install 22 --skip-default-packages --latest-npm

nvm alias default 22 && nvm use 22

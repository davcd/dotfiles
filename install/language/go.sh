#!/bin/sh

brew install bison

if [ ! -d "$HOME/.gvm" ]; then
  curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
fi

export GVM_DIR="$HOME/.gvm"
if [ -s "$GVM_DIR/scripts/gvm" ]; then
  source "$GVM_DIR/scripts/gvm"
fi

gvm install go1.22.6 -B
gvm use go1.22.6

gvm install go1.24

gvm use go1.24 --default

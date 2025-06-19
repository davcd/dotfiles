#!/bin/sh

brew install pyenv pyenv-virtualenv

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.11.13 --skip-existing
pyenv install 3.12.11 --skip-existing

pyenv global 3.12.11

pip install --upgrade pip setuptools wheel

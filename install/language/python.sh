#!/bin/bash
. "$(dirname "$0")/versions.env"

# openssl@3 is needed to build Python 3.11-3.13 (they do not support OpenSSL 4)
brew install pyenv pyenv-virtualenv openssl@3

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

for minor in $PYTHON_MAJORS; do
  pyenv install "$(pyenv latest -k "$minor")" --skip-existing
done

pyenv global "$(pyenv latest "$PYTHON_DEFAULT")"
pip install --upgrade pip setuptools wheel

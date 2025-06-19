#!/bin/sh

brew install maven gradle

if [ ! -d "$HOME/.sdkman" ]; then
  curl -s "https://get.sdkman.io?ci=true" | bash
fi

if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

yes | sdk install java 17.0.15-zulu
yes | sdk install java 21.0.7-zulu

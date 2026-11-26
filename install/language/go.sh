#!/bin/bash
. "$(dirname "$0")/versions.env"

if [ ! -d "$HOME/.gvm" ]; then
  curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
fi

source "$HOME/.gvm/scripts/gvm"

# Latest release of a minor line (e.g. go1.27.4)
latest_go() {
  curl -fsSL 'https://go.dev/dl/?mode=json&include=all' \
    | jq -r --arg m "$1" '[.[] | select(.version | test("^go" + ($m | gsub("\\."; "\\.")) + "(\\.|$)"))][0].version'
}

for minor in $GO_MINORS; do
  gvm install "$(latest_go "$minor")" -B
done

gvm use "$(latest_go "$GO_DEFAULT")" --default

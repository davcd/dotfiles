#!/bin/bash
. "$(dirname "$0")/versions.env"

brew install maven gradle

if [ ! -d "$HOME/.sdkman" ]; then
  curl -s "https://get.sdkman.io?ci=true" | bash
fi

source "$HOME/.sdkman/bin/sdkman-init.sh"

# Latest identifier for a major (e.g. 21.0.13.0+9-zulu), skipping fx/crac builds
latest_java() {
  sdk list java | awk -F'|' -v m="$1" -v v="$JAVA_VENDOR" '
    { id=$NF; gsub(/ /, "", id) }
    id ~ ("^" m "[.+-]") && id ~ ("-" v "$") && id !~ /-(fx|crac)/ { print id; exit }'
}

for major in $JAVA_MAJORS; do
  sdk install java "$(latest_java "$major")" </dev/null
done

sdk default java "$(latest_java "$JAVA_DEFAULT")"

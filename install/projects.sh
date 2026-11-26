#!/bin/bash

PROJECTS_DIR="$HOME/Projects"
mkdir -p "$PROJECTS_DIR"

gh repo list --limit 100 --json name,sshUrl --jq '.[] | [.name, .sshUrl] | @tsv' |
while IFS=$'\t' read -r name url; do
  if [ -d "$PROJECTS_DIR/$name" ]; then
    echo "Repository $name already exists in Projects."
  else
    # stdin closed: ssh would otherwise swallow the rest of the repo list
    git clone "$url" "$PROJECTS_DIR/$name" </dev/null
  fi
done

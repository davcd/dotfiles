#!/bin/sh

mkdir -p "${HOME}/Projects"

gh repo list --limit 100 --json name,sshUrl | jq -r '.[] | .name + " " + .sshUrl' | while read -r repo; do
  repo_name=$(echo "$repo" | awk '{print $1}')
  repo_url=$(echo "$repo" | awk '{print $2}')

  if [ ! -d "${HOME}/Projects/${repo_name}" ]; then
    git clone "$repo_url" "${HOME}/Projects/${repo_name}"
  else
    echo "Repository ${repo_name} already exists in Projects."
  fi
done
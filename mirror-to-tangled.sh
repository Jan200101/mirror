#! /bin/bash

# MIRROR_TANGLED_DOMAIN
# MIRROR_TANGLED_HANDLE

# Repo is not created by this script because the API endpoint requires OAuth2 authentication

source mirror.sh

function mirror_gitlab_repo {
  echo "Mirror $1"
  readarray -d / -t parts < <(printf '%s' "$1")

  repo=${parts[-1]}
  # Remove trailing .git if exists
  if [[ $repo =~ \.git$ ]]; then
          repo=${repo::-4}
  fi
  export repo_name="${repo}"

  export MIRROR_URL="git@${MIRROR_TANGLED_DOMAIN}:${MIRROR_TANGLED_HANDLE}/${repo_name}"

  mirror_repo $1
}

while IFS="" read -r line || [ -n "$1" ]
do
  # ignore blank lines and lines that start with #
  [[ -z "$line" || $line =~ ^#.* ]] && continue

  mirror_gitlab_repo $line
done < repos.txt < tangled_repos.txt

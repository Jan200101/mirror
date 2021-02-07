#! /bin/bash

# MIRROR_GITHUB_API
# MIRROR_GITHUB_TOKEN
# MIRROR_GITHUB_ACCOUNT

source mirror.sh

function mirror_github_repo {
  echo "Mirror $1"
  readarray -d / -t parts < <(printf '%s' "$1")

  repo=${parts[-1]}
  # Remove trailing .git if exists
  if [[ $repo =~ \.git$ ]]; then
          repo=${repo::-4}
  fi
  export repo_name="${repo}"

  api_resp=$(curl --silent --header "Authorization: token ${MIRROR_GITHUB_TOKEN}" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{ \"name\": \"$repo_name\", \"visibility\": \"public\", \"description\": \"Mirror of ${1}\" }" "https://${MIRROR_GITHUB_API}/repos")

  export MIRROR_URL="https://github.com/${MIRROR_GITHUB_ACCOUNT}/${repo_name}"

  mirror_repo $1
}

# Set defaults
MIRROR_GITHUB_API=${MIRROR_GITHUB_API:="api.github.com/user"}

while IFS="" read -r line || [ -n "$1" ]
do
  # ignore blank lines and lines that start with #
  [[ -z "$line" || $line =~ ^#.* ]] && continue

  mirror_github_repo $line
done < repos.txt < github_repos.txt

#! /bin/bash

# MIRROR_GITLAB_URL
# MIRROR_GITLAB_TOKEN
# MIRROR_GITLAB_NAMESPACE_ID

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

  api_resp=$(curl --silent --header "PRIVATE-TOKEN: ${MIRROR_GITLAB_TOKEN}" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{ \"namespace_id\": \"${MIRROR_GITLAB_NAMESPACE_ID}\", \"name\": \"$repo_name\", \"visibility\": \"public\", \"description\": \"Mirror of ${1}\" }" "https://${MIRROR_GITLAB_DOMAIN}/api/v4/projects")

  export MIRROR_URL="${MIRROR_GITLAB_URL}/${repo_name}"

  mirror_repo $1
}

while IFS="" read -r line || [ -n "$1" ]
do
  # ignore blank lines and lines that start with #
  [[ -z "$line" || $line =~ ^#.* ]] && continue

  mirror_gitlab_repo $line
done < repos.txt < gitlab_repos.txt

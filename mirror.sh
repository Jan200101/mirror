function mirror_repo
{
  # Add a tralling / if needed
  [[ $MIRROR_PATH != *\/ && ! -z $MIRROR_PATH ]] && MIRROR_PATH=${MIRROR_PATH}/
  # Create dir paths if set
  [[ ! -z $MIRROR_PATH ]] && mkdir -p $MIRROR_PATH

  REPO_PATH=${MIRROR_PATH}${repo_name}
  # Check if repo exists
  if [ -d $REPO_PATH ]; then
    echo "Fetching $1"
    cd  ${REPO_PATH}
    git fetch --prune --quiet origin
    # Re set mirror url just in case its needed
    #git remote set-url mirror ${MIRROR_GITLAB_URL}/${repo_name}
    git remote set-url mirror ${MIRROR_URL}
  else
    echo "Cloning $1"
    git clone --quiet --mirror $1 ${REPO_PATH}
    cd  ${REPO_PATH}
    git remote add mirror ${MIRROR_URL}
  fi

  git push --quiet --prune --mirror mirror
  cd -
  if [ "$MIRROR_CLEANUP" = true ] ; then
    rm -rf ${REPO_PATH}
  fi
}

MIRROR_CLEANUP=${MIRROR_CLEANUP:=false}
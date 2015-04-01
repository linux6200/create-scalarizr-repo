#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source "${SCALR_REPOCONFIG_CONF}"

# Overriden for Windows for now
remote_base="${REMOTE_REPO_ROOT}/win"

for repo in $CLONE_REPOS; do
  cd "${LOCAL_REPO_ROOT}/${repo}/win/x86_64"

  wget "${WGET_OPTS[@]}" --accept "*.exe" "${remote_base}/${repo}/x86_64/"

  # Update Packages index
  rm -f index
  for name in $(find . -name '*.exe'); do
    name=$(basename $name);
    package=$(echo $name | awk -F '_' '{ print $1 }');
    echo "$package $name" >> index
  done
done

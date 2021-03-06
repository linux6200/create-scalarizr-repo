#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source "${SCALR_REPOCONFIG_CONF}"

remote_base="${REMOTE_REPO_ROOT}/apt-plain"

for repo in ${CLONE_REPOS}; do
  remote_repo="${remote_base}/${repo}/"
  extra_wget_opts=("--accept" "*.deb")

  echo "Cloning repo '$repo'"

  # Navigate to the appropriate repository
  cd "${LOCAL_REPO_ROOT}/${repo}/apt"

  # Pull latest packages from Scalr
  wget "${WGET_OPTS[@]}" "${extra_wget_opts[@]}" "${remote_repo}"

  # Create a release file
  cat > Release << EOC
Origin: ${ORG_NAME}
Label: scalr
Suite: scalr
Codename: scalr
Architectures: all i386 amd64
Description: Scalr packages
EOC

  # Update Packages index
  dpkg-scanpackages -m . > Packages
  dpkg-scansources . > Sources
  cat Packages | gzip -9c > Packages.gz
  cat Sources | gzip -9c > Sources.gz
done

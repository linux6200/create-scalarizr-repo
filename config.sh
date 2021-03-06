# Configurable
DEFAULT_REPO_ROOT="/var/www"
: ${ORG_NAME:="Your company name"}
: ${LOCAL_REPO_ROOT:="$DEFAULT_REPO_ROOT"}

: ${NGINX_USER_CANDIDATES:="nginx www-data"}
: ${NGINX_CONFIG_LOCATION:="/etc/nginx/nginx.conf"}

# Should not be touched
CLONE_REPOS="stable beta"

REMOTE_REPO_ROOT="http://snapshot.repo.scalr.net/scalarizr/current"

RHEL_VERSIONS="6 6Server 6.0 6.1 6.2 6.3 6.4 6.5 6.6 6.7 2013.03 2013.09 2014.03 2014.09 2015.03 2015.09 2016.03 7 7Server 7.0 7.1 7.2"

WGET_OPTS=("--recursive" "--no-directories" "--timestamping" "--no-parent" "--no-verbose" "--execute" "robots=off")

function wget_mirror() {
  rm -rf ./*
  wget --recursive --no-parent --timestamping --no-verbose --execute robots=off $@
  mirror_root=$(echo "${@: -1}" | sed 's|https\?://||')
  cp -a ${mirror_root}/* .
  rm -rf ${mirror_root:0:$(expr index $mirror_root /)-1}
  find . -name 'index.html*' | xargs rm -f
}

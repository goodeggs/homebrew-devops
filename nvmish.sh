# adapted from https://gist.github.com/assaf/ee377a186371e2e269a7
# requires n and jq

# Install nodejs/npm version specified in package.json
#
# Source this file in your profile to get node/npm installed when you cd into a directory with a package.json.

function __nish_needs_resolution() {
  local semver=$1
  if ! [[ "$semver" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 0
  else
    return 1
  fi
}

function __nish_install_npm() {
  local version="$1"

  if __nish_needs_resolution "$version"; then
    version=$(curl --silent --get --retry 5 --retry-max-time 15 --data-urlencode "range=${version}" https://semver.io/npm/resolve)
  fi

  local current_version=$(npm --version)

  if [[ "$current_version" == "$version" ]]; then
    echo "npm $current_version already installed"
  else
    echo "Downloading and installing npm $version (replacing version $current_version)..."
    npm install --unsafe-perm --quiet -g npm@$version 2>&1 >/dev/null
  fi
  return $?
}

function nish() {
  if [[ ! -f package.json ]] ; then
    return 0
  fi

  local blessed_nodejs_version=4
  local desired_nodejs_version=$(cat package.json | jq --raw-output .engines.node)
  [[ "$desired_nodejs_version" == "null" ]] && desired_nodejs_version="$blessed_nodejs_version"
  n "$desired_nodejs_version" || return $?

  local blessed_npm_version=3.9
  local desired_npm_version=$(cat package.json | jq --raw-output .engines.npm)
  [[ "$desired_npm_version" == "null" ]] && desired_npm_version="$blessed_npm_version"
  __nish_install_npm "$desired_npm_version" || return $?

  return 0
}

function cd() {
  builtin cd "$@";
  nish
}

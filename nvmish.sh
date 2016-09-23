# adapted from https://gist.github.com/assaf/ee377a186371e2e269a7
# requires nvm and jq

# Install nodejs/npm version specified in package.json
#
# Exit code:
# 0 Successfully installed and using the desired version
# 1 No package.json in current directory

function __nvmish_needs_resolution() {
  local semver=$1
  if ! [[ "$semver" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 0
  else
    return 1
  fi
}

function __nvmish_install_nodejs() {
  local version="$1"

  if __nvmish_needs_resolution "$version"; then
    version=$(curl --silent --get --retry 5 --retry-max-time 15 --data-urlencode "range=${version}" https://semver.io/node/resolve)
  fi
  local nvm_version="v$version"
  local nvm_new_version_dir="$NVM_DIR/versions/node/$nvm_version"
  local nvm_old_version_dir="$NVM_DIR/$nvm_version"
  if [[ ! -d "$nvm_old_version_dir" && ! -d "$nvm_new_version_dir" ]]; then
    echo "Installing node v$version ..."
    nvm install $nvm_version
  else
    nvm use $nvm_version
  fi
  return $?
}

function __nvmish_install_npm() {
  local version="$1"

  if __nvmish_needs_resolution "$version"; then
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

function nvmish() {
  if [[ ! -f package.json ]] ; then
    if [[ "$1" != "chpwd" ]] ; then
      echo "No package.json found in current directory"
      return 1
    else
      return 0
    fi
  fi

  local blessed_nodejs_version=4
  local desired_nodejs_version=$(cat package.json | jq --raw-output .engines.node)
  [[ "$desired_nodejs_version" == "null" ]] && desired_nodejs_version="$blessed_nodejs_version"
  __nvmish_install_nodejs "$desired_nodejs_version" || return $?

  local blessed_npm_version=3.9
  local desired_npm_version=$(cat package.json | jq --raw-output .engines.npm)
  [[ "$desired_npm_version" == "null" ]] && desired_npm_version="$blessed_npm_version"
  __nvmish_install_npm "$desired_npm_version" || return $?

  return 0
}


# This whole chpwd support business was lovingly borrowed from rvm.
__dirname=$(brew --prefix nvmish)

source $__dirname/vendor/bash_zsh_support/chpwd/function.sh
source $__dirname/vendor/bash_zsh_support/chpwd/load.sh

function __nvmish() {
  nvmish "chpwd"
}

[[ " ${chpwd_functions[*]} " == *" __nvmish "* ]] ||
  chpwd_functions=( "${chpwd_functions[@]}" __nvmish )


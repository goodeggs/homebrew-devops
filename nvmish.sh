# adapted from https://gist.github.com/assaf/ee377a186371e2e269a7
# requires nvm and jq

# Install io.js/Node version specified in package.json
#
# Exit code:
# 0 Successfully installed and using latest version
# 1 No package.json in current directory
# 2 Found package.json but no engines specified

source $(brew --prefix nvm)/nvm.sh

function nvmish() {
  if [[ ! -f package.json ]] ; then
    if [[ "$1" != "chpwd" ]] ; then
      echo "No package.json found in current directory"
      return 1
    else
      return 0
    fi
  fi
  
  local INSTALL_VERSION
  local NVM_VERSION_DIR
  local IOJS_VERSION=$(cat package.json | jq --raw-output .engines.iojs)
  if [[ "$IOJS_VERSION" != "null" ]] ; then
    if ! [[ "$IOJS_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      IOJS_VERSION=$(curl --silent --get --data-urlencode "range=${IOJS_VERSION}" https://semver.herokuapp.com/iojs/resolve)
    fi
    NVM_VERSION="iojs-v$IOJS_VERSION"
    NVM_NEW_VERSION_DIR="$NVM_DIR/versions/iojs/$NVM_VERSION"
    NVM_OLD_VERSION_DIR="$NVM_DIR/$NVM_VERSION"
    if [ ! -d "$NVM_OLD_VERSION_DIR" -a ! -d "$NVM_NEW_VERSION_DIR" ]; then
      echo "Installing io.js v$IOJS_VERSION ..."
      nvm install $NVM_VERSION
    else
      nvm use $NVM_VERSION
    fi
    return $?
  fi
  
  local NODE_VERSION=$(cat package.json | jq --raw-output .engines.node)
  if [[ "$NODE_VERSION" != "null" ]] ; then
    if ! [[ "$NODE_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      NODE_VERSION=$(curl --silent --get --data-urlencode "range=${NODE_VERSION}" https://semver.herokuapp.com/node/resolve)
    fi
    NVM_VERSION="v$NODE_VERSION"
    NVM_NEW_VERSION_DIR="$NVM_DIR/versions/node/$NVM_VERSION"
    NVM_OLD_VERSION_DIR="$NVM_DIR/$NVM_VERSION"
    if [ ! -d "$NVM_OLD_VERSION_DIR" -a ! -d "$NVM_NEW_VERSION_DIR" ]; then
      echo "Installing node v$NODE_VERSION ..."
      nvm install $NVM_VERSION
    else
      nvm use $NVM_VERSION
    fi
    return $?
  fi

  nvm use default
  return 0
}


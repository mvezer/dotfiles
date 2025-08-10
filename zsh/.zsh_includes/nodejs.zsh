#!/usr/bin/env zsh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "/home/mat/.deno/env"
# global npm packages
# export NPM_PACKAGES="$NVM_DIR/versions/node/v20.11.1"
# npm config set prefix "$NPM_PACKAGES"
# export PATH="$PATH:$NPM_PACKAGES/bin"

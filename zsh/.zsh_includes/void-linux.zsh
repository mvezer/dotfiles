#!/usr/bin/env zsh

export XBPS_DISTDIR=$HOME/.void-packages

function xq() {
  xbps-query -Rs $1
}

# function xi() {
#   sudo xbps-install -S $1
# }

function update-system() {
  sudo xbps-install -Su
}

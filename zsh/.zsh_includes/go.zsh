#!/usr/bin/env zsh

export PATH="$PATH:$HOME/go/bin"

function init-go-project() {
  PACKAGE_PREFIX="github.com/mvezer"

  # Checking shit
  if [[ -z $1 ]]; then
    echo "ERROR: you need to specify a project name"
    return 1
  fi

  PACKAGE_NAME="$1"

  if [[ ! "$PACKAGE_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "ERROR: invalid package name: $PACKAGE_NAME"
  fi

  if $(gh repo view $PACKAGE_NAME &>/dev/null); then
    echo "ERROR: repo \"$PACKAGE_NAME\" already exists"
    return 1
  fi

  gh repo create "$PACKAGE_NAME" --private
  gh repo clone "$PACKAGE_NAME"

  # Creating directories
  cd $PACKAGE_NAME
  echo "Created directory: $(pwd)"
  mkdir -p "cmd/$PACKAGE_NAME"
  mkdir "internal"
  mkdir "pkg"

  # Creating files
  touch "cmd/$PACKAGE_NAME/main.go"
  cat >"cmd/$PACKAGE_NAME/main.go" << EOL
package main

import "fmt"

func main() {
    fmt.Println("Hello, $PACKAGE_NAME")
}
EOL
  touch "README.md"
  cat >"README.md" << EOL
# $PACKAGE_NAME
EOL

  # Initializing go module
  go mod init "$PACKAGE_PREFIX/$PACKAGE_NAME"
}

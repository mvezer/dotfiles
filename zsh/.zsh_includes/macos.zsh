#!/usr/bin/env zsh


alias cb="pbcopy"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export HOMEBREW_BREWFILE="$HOME/.brew/Brewfile"

if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

function enable_apps() {
  for app in "$@"; do
    echo "Enabling $app..."
    xattr -d -r com.apple.quarantine "$app"
  done
}

apps_to_enable=(
  "/Applications/Alacritty.app"
  "/Applications/AeroSpace.app"
)

alias "br"="HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file=~/Brewfile --cleanup"
alias "bru"="brew bundle install --file=~/Brewfile --cleanup && enable_apps ${apps_to_enable[*]}"

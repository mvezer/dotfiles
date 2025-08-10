#!/usr/bin/env zsh

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"
export PATH=$PATH:/usr/local/go/bin


function draw_line {
  printf %"$COLUMNS"s |tr " " "${1:--}"
}

function .. {
  cd ..
}

function ... {
  cd ../..
}

function .... {
  cd ../../..
}

function v() {
  local dst="$(command vifm . --choose-dir - "$@")"
  if [ -z "$dst" ]; then
    echo 'Directory picking cancelled/failed'
    return 1
  fi
  cd "$dst"
}

# aliases
alias "nv"="nvim"
alias ll="eza --icons -al --time-style=long-iso --git --no-user --no-permissions"
alias l="eza --icons -al --time-style=long-iso --git --no-user --no-permissions"
alias tree="eza -al -T --no-time --no-user --no-permissions -I node_modules $argv"
alias ws="cd $WORKSPACE"
alias zsrc="source ~/.zshrc"
alias ai="nvim -c ':terminal aichat'"

if [[ ":$FPATH:" != *":/$HOME/.zsh/completions:"* ]]; then export FPATH="/$HOME/.zsh/completions:$FPATH"; fi
eval "$(starship init zsh)"

# env vars
export SECRETS="$HOME/.secrets"
export EDITOR="nvim"
export PAGER="nvim -c 'Man!' -o -"
export MANPAGER='nvim +Man!'
export WORKSPACE="$HOME/workspace"
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
export TERM="screen-256color"
export PATH="$PATH:$HOME/.local/bin"
# doom emacs
export PATH="$PATH:$HOME/.config/emacs/bin"
export PATH=/home/mat/.opencode/bin:$PATH
export HOST="$HOST"

# misc settings
unsetopt BEEP

# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILESIZE=10000
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTTIMEFORMAT="%F %T "
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# zinit
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# export NVM_LAZY_LOAD=true
# zinit light lukechilds/zsh-nvm
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
eval "$(fnm env --use-on-cd)"
autoload -Uz compinit && compinit

zmodload zsh/zprof
eval "$(zoxide init --cmd cd zsh)"

# find out the OS
if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
  export OS="macos"
else # it must be linux or WSL lol
  export OS="linux"
  if [[ ! -z "$(cat /etc/os-release | grep void)" ]]; then
    export OS="void-linux"
  fi
fi

export ZSH_INCLUDES="$HOME/.zsh_includes"
if [[ "$OS" == "macos" ]]; then
  source $ZSH_INCLUDES/macos.zsh
  source $ZSH_INCLUDES/work.zsh
elif [[ "$OS" =~ "linux" ]]; then
  source $ZSH_INCLUDES/linux.zsh
  if [[ "$OS" == "void-linux" ]]; then 
    source $ZSH_INCLUDES/void-linux.zsh
  fi
fi

export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
export PATH="$PATH:$HOME/.nvm/versions/node/v24.9.0/bin/npm"

# source machine-specific secrets
if [ -f $SECRETS ]; then source $SECRETS; fi # TODO: use 1password cli instead

if [ -f $ZSH_INCLUDES/gh_autocomp.sh ]; then source $ZSH_INCLUDES/gh_autocomp.sh; fi

source $ZSH_INCLUDES/aws.zsh
source $ZSH_INCLUDES/general.zsh
source $ZSH_INCLUDES/git.zsh
source $ZSH_INCLUDES/go.zsh
source $ZSH_INCLUDES/kubernetes.zsh
source $ZSH_INCLUDES/rust.zsh
# source $ZSH_INCLUDES/lua.zsh
source $ZSH_INCLUDES/work.zsh
# source $ZSH_INCLUDES/nodejs.zsh
source $ZSH_INCLUDES/tmux.zsh
source $ZSH_INCLUDES/zk.zsh

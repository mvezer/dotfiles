#!/usr/bin/env zsh

alias gitignore="git update-index --assume-unchanged"
alias gitunignore="git update-index --no-assume-unchanged"
function githistory () {
  git log -p -- $1
}
function git-squash-branch() {
  git reset $(git merge-base master $(git branch --show-current))
} 

function git-cleanup() {
  git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done
}

function git-setup() {
  git config --global user.name "Matyas Vezer"
  git config --global user.email "vezer.m@gmail.com"
}


function gcof () {
  git checkout $(git branch -a | sed 's/remotes\/origin\///g' | fzf)
}

alias lg="lazygit"
alias g='git'

function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

function gcof() {
  git checkout $(git branch -r | while read line ; do echo $line | sed -e 's/^origin\///g' ; done | fzf)
}

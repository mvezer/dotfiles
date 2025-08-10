#!/usr/bin/env zsh

alias kx="kubectx"
alias kns="kubens"
alias kgp="kubectl get pods"
alias kgd="kubectl get deployments"
function ks () {
  echo "context: $(kubectx -c), namespace: $(kubens -c)"
}
function klogs () {
  stern --timestamps $(kubectl get deployments -oname | awk -F '/' '{ print $2 }' | fzf)
}
function nuke-rapp () {
  kubectl delete ingresses -l prunable=true,reviewAppId="$1" -n nxt
  kubectl delete all -l prunable=true,reviewAppId="$1" -n nxt
}
function kex () {
  command="${1:-/bin/bash}"
  # command="${1:-/bin/sh}"
  kubectl exec --stdin --tty $(kubectl get pods -oname | awk -F '/' '{ print $2 }' | fzf) -- $command
}

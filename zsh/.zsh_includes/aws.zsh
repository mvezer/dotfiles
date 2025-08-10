#!/usr/bin/env zsh

alias awslogin='aws sso login --profile $(aws configure list-profiles | fzf)'
function ecrlogin() {
  # aws ecr get-login-password | docker login --username AWS --password-stdin 640616770507.dkr.ecr.eu-west-1.amazonaws.com/api-v2/api:staging
  aws ecr get-login-password | docker login --username AWS --password-stdin 640616770507.dkr.ecr.eu-west-1.amazonaws.com/$1:staging
}

alias ecrlogin='aws ecr get-login-password | docker login --username AWS --password-stdin 640616770507.dkr.ecr.eu-west-1.amazonaws.com/api-v2/api:staging'

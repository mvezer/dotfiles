#!/usr/bin/env zsh

alias ld=lazydocker

function ecr-login () {
  aws ecr get-login-password | docker login -u AWS --password-stdin "https://$(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.us-east-1.amazonaws.com"
}

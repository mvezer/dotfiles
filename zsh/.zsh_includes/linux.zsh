#!/usr/bin/env zsh

alias battery="cat /sys/class/power_supply/BAT0/capacity"
alias cb="xclip -selection c"
alias mixer="wiremix -v output"
alias proxmox="ssh root@192.168.178.173"
alias jellyfin="ssh root@192.168.178.175"

function evening() {
  hctl on szekreny
  hctl on golyo_lampak
}

function dinner() {
  evening
  hctl brightness asztal 30
}

function night() {
  hctl off szekreny
  hctl off golyo_lampak
  hctl off asztal
}

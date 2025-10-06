#!/usr/bin/env bash
if [ "$(laptop-keyboard-status)" = "enabled" ]; then
  echo "󰌌"
else
  echo "󰹋"
fi

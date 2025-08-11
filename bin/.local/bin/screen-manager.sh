#!/usr/bin/env bash

LOGDIR=$HOME/.local/state/
LOGFILE=$LOGDIR/screen-manager.log
EXTERNAL_SCREEN="HDMI-1-1"
EXTERNAL_MODE=1920x1080
BUILTIN_SCREEN="eDP-1"
BUILTIN_MODE=1920x1080

function is_connected() {
  if xrandr | grep -q "$1"; then
    return 0
  else
    return 1
  fi
}

function switch_to_external() {
  if [ "$LOG" = "1" ]; then
    echo "$(date +%Y-%m-%dT%H:%M:%S) Switching to external screen" >> "${LOGFILE}"
  fi
  xrandr --output "$EXTERNAL_SCREEN" --primary --mode "$EXTERNAL_MODE" --right-of "$BUILTIN_SCREEN"
  xrandr --output "$BUILTIN_SCREEN" --mode "$BUILTIN_MODE"
}

function switch_to_builtin() {
  if [ "$LOG" = "1" ]; then
    echo "$(date +%Y-%m-%dT%H:%M:%S) Switching to builtin screen" >> "${LOGFILE}"
  fi
  xrandr --output "$BUILTIN_SCREEN" --mode "$BUILTIN_MODE"
  xrandr --output "$EXTERNAL_SCREEN" --off
}

if [ "$SCREEN_MANAGER_LOG" = "1" ] || [ "$SCREEN_MANAGER_LOG" = "true" ]; then
  LOG=1
else
  LOG=0
fi

LOG=1

if [ "$LOG" = "1" ]; then
  if [ ! -d "${LOGDIR}" ]; then
    mkdir -p "${LOGDIR}"
  fi

  if [ ! -f "${LOGFILE}" ]; then
    touch "${LOGFILE}"
  fi
fi

if [ -n $SRANDRD_OUTPUT ] && [ -n $SRANDRD_EVENT ]; then
  if [ "$LOG" = "1" ]; then
    echo "$(date +%Y-%m-%dT%H:%M:%S) srandrd output: ${SRANDRD_OUTPUT} event: ${SRANDRD_EVENT}" >> "${LOGFILE}"
  fi
  if [ "$SRANDRD_OUTPUT" = "$EXTERNAL_SCREEN" ]; then
    if [ "$SRANDRD_EVENT" = "connected" ]; then
      switch_to_external
    elif [ "$SRANDRD_EVENT" = "disconnected" ]; then
      switch_to_builtin
    fi
  fi
else
  if xrandr | grep -q "$EXTERNAL_SCREEN"; then
    switch_to_external
  fi
fi



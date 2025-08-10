#!/usr/bin/env zsh

alias "todo"="todo.sh -d $HOME/.config/todo.txt/todo.cfg"

function invoke_todo_with_context () {
  command="$1"
  context="$2"
  shift 2
  todo "$command" "$@" "@$context"
}

function pick_todo_item_with_fzf () {
  command="$1"
  context="$2"
  shift 2
  ITEM=$(todo -p ls "@$context" | grep '^[0-9]' | fzf | awk -F ' ' '{ print $1 }')
  todo $command $ITEM "$@"
}

function process_todo_command_with_context () {
  echo "$@"
  context="$1"
  shift
  command="${1:-ls}"
  if [ ! -z $1 ]; then
    shift
  fi
  case "$command" in 
    "add" | "a" | "list" | "ls" | "listall" | "lsa" | "listcon" | "lsc" | "listproj" | "lsprj")
      invoke_todo_with_context $command $context $@
      ;;
    "depri" | "dp" | "done" | "do" | "del" | "rm" | "replace" | "addto" | "append" | "app" | "pri" | "p" | "prepend" | "prep")
      pick_todo_item_with_fzf $command $context $@
      ;;
    *)
      todo $command $@
      ;;
  esac
}

function tp() {
  process_todo_command_with_context private $@
}

function tw() {
  process_todo_command_with_context work $@
}

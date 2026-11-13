#!/bin/sh
# ctrl+arrow pane navigation shared with neovim (like tmux's is_nvim check):
# if nvim is in the focused pane, forward the key so nvim moves between its
# splits (it calls `herdr pane focus` itself at the edge); otherwise move herdr focus.
dir=$1
pane=$HERDR_ACTIVE_PANE_ID
if herdr pane process-info --pane "$pane" | jq -e 'any(.result.process_info.foreground_processes[]; .name == "nvim")' >/dev/null; then
	herdr pane send-keys "$pane" "ctrl+$dir"
else
	herdr pane focus --direction "$dir" --pane "$pane"
fi

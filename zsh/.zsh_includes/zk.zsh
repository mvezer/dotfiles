#!/user/bin/env zsh

export ZK_DIR="$HOME/notes"

alias n="pushd &> /dev/null && cd $ZK_DIR && zk edit quick-note && popd &> /dev/null"

# function day() {
#   pushd &> /dev/null
#   cd $ZK_DIR
#   if [ "$1" = "yesterday" ] || [ "$1" = "y" ]; then
#     if [[ "$OSTYPE" == "darwin"* ]]; then
#         day=$(date -v -1d +%Y-%m-%d)
#       else
#         day=$(date -d "yesterday" +%Y-%m-%d)
#     fi
#   elif [ "$1" = "tomorrow" ] || [ "$1" = "t" ]; then
#     if [[ "$OSTYPE" == "darwin"* ]]; then
#         day=$(date -v +1d +%Y-%m-%d)
#       else
#         day=$(date -d "tomorrow" +%Y-%m-%d)
#     fi
#   else
#       day=$(date +%Y-%m-%d)
#   fi
#
#   file=$(find . -name "*${day}*" -type f 2>/dev/null | head -1)
#
#   if [ -n "$file" ]; then
#       nvim "$file"
#   else
#       zk new --title "daily-note-${day}" --working-dir dailies --template daily.md --extra day="$day"
#   fi
#   popd &> /dev/null
# }

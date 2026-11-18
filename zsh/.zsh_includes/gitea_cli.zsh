gt() {
  local bw_token_key="lenny gitea cli"
  local gitea_host="https://git.vezer.me"
  # check if we are logged in (exit code 4 = no account or missing credential)
  command gt auth status --host "$gitea_host" >/dev/null 2>&1
  if [[ $? -eq 4 ]]; then
    # log in
    rbw get "$bw_token_key" | command gt auth login --host "$gitea_host" --with-token || return
  fi
  # execute the gt command with the arguments passed to this function
  command gt "$@"
}

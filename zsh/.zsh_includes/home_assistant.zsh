hass-cli() {
  local token
  token=$(rbw get "Home Assistant CLI Token") || return   # or: bw get password "..."
  HASS_SERVER=http://192.168.178.65:8123 HASS_TOKEN=$token command hass-cli "$@"
}

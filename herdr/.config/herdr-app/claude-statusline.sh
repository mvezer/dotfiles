#!/bin/sh
# Claude Code statusLine (~/.claude/settings.json). Prints nothing; saves for Herdr:
# - claude-usage.json: the plan usage windows (rate_limits.five_hour / seven_day),
#   read by the claude-usage mod
# - claude-usage/<terminal>.json: this session's model and context, keyed by the
#   herdr-core terminal it runs in (HC_TERMINAL_ID), read by the agents list (square-agents)
dir="${XDG_CACHE_HOME:-$HOME/.cache}"
f="$dir/claude-usage.json"
mkdir -p "$dir/claude-usage"
in=$(cat)
# keep the last values when the input has no rate_limits (before a session's first response)
tmp="$f.$$"
if printf '%s' "$in" | jq -c '.rate_limits // empty' > "$tmp" && [ -s "$tmp" ]; then mv "$tmp" "$f"; else rm -f "$tmp"; fi
if [ -n "$HC_TERMINAL_ID" ]; then
  s="$dir/claude-usage/$HC_TERMINAL_ID.json"
  tmp="$s.$$"
  if printf '%s' "$in" | jq -c --argjson now "$(date +%s)" '{
      session: .session_id,
      model: (.model.display_name // .model.id),
      context: (.context_window.used_percentage
                // (if .context_window.remaining_percentage then 100 - .context_window.remaining_percentage else null end)),
      updated: $now }' > "$tmp" && [ -s "$tmp" ]; then mv "$tmp" "$s"; else rm -f "$tmp"; fi
fi

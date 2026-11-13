#!/bin/sh
# Claude Code statusLine (~/.claude/settings.json): saves the plan usage windows
# (rate_limits.five_hour / seven_day) for Herdr's tab bar. Prints nothing.
f="${XDG_CACHE_HOME:-$HOME/.cache}/claude-usage.json"
tmp="$f.$$"
mkdir -p "$(dirname "$f")"
# keep the last values when the input has no rate_limits (before a session's first response)
if jq -c '.rate_limits // empty' > "$tmp" && [ -s "$tmp" ]; then mv "$tmp" "$f"; else rm -f "$tmp"; fi

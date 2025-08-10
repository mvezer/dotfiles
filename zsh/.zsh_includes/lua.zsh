#!/usr/bin/env zsh

# Lua
export LUA_DIR="$HOME/Developer/lua"
export PATH="$PATH:${LUA_DIR}/bin"
export LUA_CPATH="${LUA_DIR}/lib/lua/5.1/?.so"
export LUA_PATH="${LUA_DIR}/share/lua/5.1/?.lua;;"
export MANPATH="${LUA_DIR}/share/man:$MANPATH"

# LuaRocks
export PATH="$PATH:$HOME/.luarocks/bin"
eval $(luarocks path --no-bin)

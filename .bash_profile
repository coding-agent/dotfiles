#!/bin/bash

export PATH="$HOME/.local/bin:$PATH"

if [[ -z "$WAYLAND_DISPLAY" ]]; then
    lua scripts/init.lua
fi

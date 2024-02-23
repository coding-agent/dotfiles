#!/bin/bash

export PATH="$PATH:$HOME/.local/bin"

if [[ -z "$WAYLAND_DISPLAY" ]]; then
    lua init.lua
fi

#!/bin/bash

if [[ -z "$WAYLAND_DISPLAY" ]]; then
    lua init.lua
fi

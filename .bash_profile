#!/bin/bash

export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_DIRS="$HOME/.config/"

if [[ -z "$WAYLAND_DISPLAY" ]]; then
    systemctl --user enable --now confgenfs
    #river
fi


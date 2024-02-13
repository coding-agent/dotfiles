#!/bin/bash

wp_dir=$HOME/dev/wallpapers/
rwp=$(find $wp_dir -type f | shuf -n 1)

hyprctl hyprpaper preload "$rwp" 
hyprctl hyprpaper wallpaper "eDP-1,contain:$rwp"
hyprctl hyprpaper unload all

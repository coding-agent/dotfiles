#!/bin/bash

wp_dir=$HOME/dev/wallpapers/
rwp=$(find $wp_dir -type f | shuf -n 1)

exec swaylock -f -i $rwp

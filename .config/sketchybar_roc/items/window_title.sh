#!/bin/zsh

sketchybar --add item title left \
  --set title script="$PLUGIN_DIR/window_title.sh" \
  --subscribe title window_focus front_app_switched space_change title_change

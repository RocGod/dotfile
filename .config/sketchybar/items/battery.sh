#!/bin/bash

sketchybar --add item battery right \
  --set battery update_freq=180 \
  script="$PLUGIN_DIR/battery.sh" \
  label.color="$BLACK" \
  icon.color="$BLACK" \
  --subscribe battery system_woke power_source_change

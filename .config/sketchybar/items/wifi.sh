#!/bin/bash

sketchybar --add item wifi right \
  --set wifi \
  icon="􀙥" \
  label="Updating..." \
  label.color="$BLACK" \
  icon.color="$BLACK" \
  script="$PLUGIN_DIR/wifi.sh" \
  --subscribe wifi wifi_change

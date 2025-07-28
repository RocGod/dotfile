#!/bin/bash

sketchybar --add item volume right \
  --set volume script="$PLUGIN_DIR/volume.sh" \
  label.color="$BLACK" \
  icon.color="$BLACK" \
  --subscribe volume volume_change

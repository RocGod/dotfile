#!/bin/zsh

sketchybar --add item front_app left \
  --set front_app background.color=$BAR_COLOR \
  background.border_width=0 \
  background.corner_radius=6 \
  background.height=24 \
  icon.color=$ACCENT_COLOR \
  icon.font="sketchybar-app-font:Regular:16.0" \
  label.color=$ACCENT_COLOR \
  script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched

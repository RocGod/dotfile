#!/bin/zsh
sketchybar --add item time right \
  --set time script="$PLUGIN_DIR/time.sh" \
  update_freq=5 \
  padding_left=2 \
  padding_right=8 \
  background.border_width=0 \
  background.corner_radius=6 \
  background.height=24 \
  icon=$ICON_CLOCK \
  icon.color=$COLOR_RED \
  label.color=$COLOR_RED \
  --add item date right \
  --set date script="$PLUGIN_DIR/date.sh" \
  update_freq=60 \
  padding_left=8 \
  padding_right=2 \
  background.border_width=0 \
  background.height=24 \
  icon=$ICON_CALENDAR \
  icon.color=$COLOR_RED \
  label.color=$COLOR_RED

sketchybar --add bracket clock time date \
  --set clock background.color=$BAR_COLOR \
  background.border_color=$COLOR_RED

sketchybar --add item seperator.r1 right \
  --set seperator.r1 padding_left=4 \
  padding_right=4 \
  background.drawing=off \
  icon.drawing=off \
  label.drawing=off
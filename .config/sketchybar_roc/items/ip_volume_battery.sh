#!/bin/zsh

sketchybar --add item ip_address right \
  --set ip_address script="$PLUGIN_DIR/ip_address.sh" \
  update_freq=30 \
  padding_left=2 \
  padding_right=8 \
  background.border_width=0 \
  background.corner_radius=6 \
  background.height=24 \
  icon.highlight=on \
  label.highlight=on \
  --subscribe ip_address wifi_change \
  \
  --add item volume right \
  --set volume script="$PLUGIN_DIR/volume.sh" \
  padding_left=2 \
  padding_right=2 \
  background.border_width=0 \
  background.height=24 \
  --subscribe volume volume_change \
  \
  --add item battery right \
  --set battery script="$PLUGIN_DIR/battery.sh" \
  update_freq=120 \
  padding_left=8 \
  padding_right=2 \
  background.border_width=0 \
  background.height=24 \
  --subscribe battery system_woke power_source_change

sketchybar --add bracket status ip_address volume battery \
  --set status background.color=$BAR_COLOR \
  background.border_color=$COLOR_BLUE

sketchybar --add item seperator.r2 right \
  --set seperator.r2 padding_left=4 \
  padding_right=4 \
  background.drawing=off \
  icon.drawing=off \
  label.drawing=off
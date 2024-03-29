#!/bin/zsh

sketchybar --add item command.logo left \
  --set command.logo background.color=$COLOR_GREEN \
  background.border_width=0 \
  background.corner_radius=6 \
  background.height=24 \
  icon=$ICON_CMD \
  icon.highlight=on \
  icon.padding_left=4 \
  icon.padding_right=4 \
  label.drawing=off \
  click_script="sketchybar -m --set \$NAME popup.drawing=toggle" \
  popup.height=32 \
  popup.background.color=$BAR_COLOR \
  popup.background.border_width=2 \
  popup.background.corner_radius=12 \
  popup.background.border_color=$COLOR_GREEN \
  \
  --add item command.preferences popup.command.logo \
  --set command.preferences icon=$ICON_COG \
  icon.color=$COLOR_GREEN \
  icon.padding_left=4 \
  icon.padding_right=2 \
  label="Settings" \
  label.color=$COLOR_GREEN \
  label.padding_left=2 \
  label.padding_right=4 \
  click_script="open -a 'System Preferences';

sketchybar -m --set command.logo popup.drawing=off" \
  --add item command.activity popup.command.logo \
  --set command.activity icon=$ICON_CHART \
  icon.color=$COLOR_GREEN \
  icon.padding_left=4 \
  icon.padding_right=2 \
  label="Activity Monitor" \
  label.color=$COLOR_GREEN \
  label.padding_left=2 \
  label.padding_right=4 \
  click_script="open -a 'Activity Monitor';

sketchybar -m --set command.logo popup.drawing=off" \
  --add item command.lock popup.command.logo \
  --set command.lock icon=$ICON_LOCK \
  icon.color=$COLOR_GREEN \
  icon.padding_left=4 \
  icon.padding_right=2 \
  label="Lock Screen" \
  label.color=$COLOR_GREEN \
  label.padding_left=2 \
  label.padding_right=4 \
  click_script="pmset displaysleepnow;

sketchybar -m --set command.logo popup.drawing=off"

sketchybar --add bracket cmd command.logo \
  --set cmd background.color=$BAR_COLOR \
  background.border_color=$COLOR_GREEN

sketchybar --add item seperator.l1 left \
  --set seperator.l1 padding_left=4 \
  padding_right=4 \
  background.drawing=off \
  icon.drawing=off \
  label.drawing=off
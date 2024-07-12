#!/bin/bash

SPOTIFY_EVENT="com.spotube.client.PlaybackStateChanged"
POPUP_SCRIPT="sketchybar -m --set spotube.anchor popup.drawing=toggle"

spotify_anchor=(
  script="$PLUGIN_DIR/spotube.sh"
  click_script="$POPUP_SCRIPT"
  popup.horizontal=on
  popup.align=center
  popup.height=150
  icon=􁁒
  icon.font="$FONT:Regular:25.0"
  label.drawing=off
  drawing=off
  y_offset=2
)

spotify_cover=(
  script="$PLUGIN_DIR/spotube.sh"
  click_script="open -a 'Spotify'; $POPUP_SCRIPT"
  label.drawing=off
  icon.drawing=off
  padding_left=12
  padding_right=10
  background.image.scale=0.2
  background.image.drawing=on
  background.drawing=on
  background.image.corner_radius=9
  shadow=on
)

spotify_title=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  width=0
  label.font="$FONT:Heavy:15.0"
  label.max_chars=20
  y_offset=55
)

spotify_artist=(
  icon.drawing=off
  y_offset=30
  padding_left=0
  padding_right=0
  width=0
  label.max_chars=20
)

spotify_album=(
  icon.drawing=off
  padding_left=0
  padding_right=0
  y_offset=15
  width=0
  label.max_chars=25
)

spotify_state=(
  icon.drawing=on
  icon.font="$FONT:Light Italic:10.0"
  icon.width=35
  icon="00:00"
  label.drawing=on
  label.font="$FONT:Light Italic:10.0"
  label.width=35
  label="00:00"
  padding_left=0
  padding_right=0
  y_offset=-15
  width=0
  slider.background.height=6
  slider.background.corner_radius=1
  slider.background.color=$GREY
  slider.highlight_color=$GREEN
  slider.percentage=40
  slider.width=115
  script="$PLUGIN_DIR/spotube.sh"
  update_freq=1
  updates=when_shown
)

spotify_shuffle=(
  icon=􀊝
  icon.padding_left=5
  icon.padding_right=5
  icon.color=$BLACK
  icon.highlight_color=$GREY
  label.drawing=off
  script="$PLUGIN_DIR/spotube.sh"
  y_offset=-45
)

spotify_back=(
  icon=􀊎
  icon.padding_left=5
  icon.padding_right=5
  icon.color=$BLACK
  script="$PLUGIN_DIR/spotube.sh"
  label.drawing=off
  y_offset=-45
)

spotify_play=(
  icon=􀊔
  background.height=40
  background.corner_radius=20
  width=40
  align=center
  background.color=$POPUP_BACKGROUND_COLOR
  background.border_color=$WHITE
  background.border_width=0
  background.drawing=on
  icon.padding_left=4
  icon.padding_right=5
  updates=on
  label.drawing=off
  script="$PLUGIN_DIR/spotube.sh"
  y_offset=-45
)

spotify_next=(
  icon=􀊐
  icon.padding_left=5
  icon.padding_right=5
  icon.color=$BLACK
  label.drawing=off
  script="$PLUGIN_DIR/spotube.sh"
  y_offset=-45
)

spotify_repeat=(
  icon=􀊞
  icon.highlight_color=$GREY
  icon.padding_left=5
  icon.padding_right=10
  icon.color=$BLACK
  label.drawing=off
  script="$PLUGIN_DIR/spotube.sh"
  y_offset=-45
)

spotify_controls=(
  background.color=$GREEN
  background.corner_radius=11
  background.drawing=on
  y_offset=-45
)

sketchybar --add event spotify_change $SPOTIFY_EVENT             \
           --add item spotube.anchor center                      \
           --set spotube.anchor "${spotify_anchor[@]}"           \
           --subscribe spotube.anchor mouse.entered mouse.exited \
                                      mouse.exited.global        \
                                                                 \
           --add item spotube.cover popup.spotube.anchor         \
           --set spotube.cover "${spotify_cover[@]}"             \
                                                                 \
           --add item spotube.title popup.spotube.anchor         \
           --set spotube.title "${spotify_title[@]}"             \
                                                                 \
           --add item spotube.artist popup.spotube.anchor        \
           --set spotube.artist "${spotify_artist[@]}"           \
                                                                 \
           --add item spotube.album popup.spotube.anchor         \
           --set spotube.album "${spotify_album[@]}"             \
                                                                 \
           --add slider spotube.state popup.spotube.anchor       \
           --set spotube.state "${spotify_state[@]}"             \
           --subscribe spotube.state mouse.clicked               \
                                                                 \
           --add item spotube.shuffle popup.spotube.anchor       \
           --set spotube.shuffle "${spotify_shuffle[@]}"         \
           --subscribe spotube.shuffle mouse.clicked             \
                                                                 \
           --add item spotube.back popup.spotube.anchor          \
           --set spotube.back "${spotify_back[@]}"               \
           --subscribe spotube.back mouse.clicked                \
                                                                 \
           --add item spotube.play popup.spotube.anchor          \
           --set spotube.play "${spotify_play[@]}"               \
           --subscribe spotube.play mouse.clicked spotify_change \
                                                                 \
           --add item spotube.next popup.spotube.anchor          \
           --set spotube.next "${spotify_next[@]}"               \
           --subscribe spotube.next mouse.clicked                \
                                                                 \
           --add item spotube.repeat popup.spotube.anchor        \
           --set spotube.repeat "${spotify_repeat[@]}"           \
           --subscribe spotube.repeat  mouse.clicked             \
                                                                 \
           --add item spotube.spacer popup.spotube.anchor        \
           --set spotube.spacer width=5                          \
                                                                 \
           --add bracket spotube.controls spotube.shuffle        \
                                          spotube.back           \
                                          spotube.play           \
                                          spotube.next           \
                                          spotube.repeat         \
           --set spotube.controls "${spotify_controls[@]}"       \

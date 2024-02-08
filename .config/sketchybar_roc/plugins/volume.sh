#!/bin/zsh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

source "$CONFIG_DIR/colors.sh"

ICONS_VOLUME=(󰸈 󰕿 󰖀 󰕾)

if [ "$SENDER" = "volume_change" ]; then
	VOLUME=$INFO

	case $VOLUME in
	[6-9][0-9] | 100)
		ICON=${ICONS_VOLUME[3]}
		COLOR=$COLOR_MAGENTA_BRIGHT
		;;
	[3-5][0-9])
		ICON=${ICONS_VOLUME[2]}
		COLOR=$COLOR_MAGENTA_BRIGHT
		;;
	[1-9] | [1-2][0-9])
		ICON=${ICONS_VOLUME[1]}
		COLOR=$COLOR_MAGENTA
		;;
	*)
		ICON=${ICONS_VOLUME[0]}
		COLOR=$COLOR_MAGENTA
		;;
	esac

	sketchybar --set $NAME icon="$ICON" \
		icon.color=$COLOR \
		label="$VOLUME%" \
		label.color=$COLOR
fi

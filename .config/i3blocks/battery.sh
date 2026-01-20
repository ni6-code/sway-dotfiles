#!/bin/bash

BAT_PATH="/sys/class/power_supply/BAT1"
CAPACITY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status")

# Icons
ICON_CHARGING="󰂅"
ICON_PLUGGED=""
ICONS=("" "" "" "" "")

# Colors
COLOR_CRITICAL="#FF0000"
COLOR_WARNING="#FFA500"
COLOR_DEFAULT="#FFFFFF"

# Choosing icon
if [ "$CAPACITY" -le 20 ]; then ICON=${ICONS[0]}
elif [ "$CAPACITY" -le 40 ]; then ICON=${ICONS[1]}
elif [ "$CAPACITY" -le 60 ]; then ICON=${ICONS[2]}
elif [ "$CAPACITY" -le 80 ]; then ICON=${ICONS[3]}
else ICON=${ICONS[4]}
fi

# Determine the current color depending on the level
if [ "$CAPACITY" -le 15 ]; then
    CURRENT_COLOR="$COLOR_CRITICAL"
elif [ "$CAPACITY" -le 30 ]; then
    CURRENT_COLOR="$COLOR_WARNING"
else
    CURRENT_COLOR="$COLOR_DEFAULT"
fi

# Forming text
if [ "$STATUS" = "Charging" ]; then
    TEXT="$ICON_CHARGING $CAPACITY%"
elif [ "$STATUS" = "Full" ] || [ "$STATUS" = "Not charging" ]; then
    TEXT="$ICON_PLUGGED $CAPACITY%"
else
    TEXT="$ICON $CAPACITY%"
fi

# Final output
echo "<span font='JetBrainsMono Nerd Font' color='$CURRENT_COLOR'>$TEXT</span>"

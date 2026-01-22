#!/bin/bash

CACHE_FILE="$HOME/.cache/i3blocks_volume"

load_cache() {
    if [ -f "$CACHE_FILE" ]; then
        read VOL MUTE < "$CACHE_FILE"
    else
        VOL=0
        MUTE="no"
    fi
}

save_cache() {
    echo "$VOL $MUTE" > "$CACHE_FILE"
}

get_icon() {
    if [ "$MUTE" = "yes" ]; then
        ICON=""   # nf-fa-volume_off
    elif [ "$VOL" -le 30 ]; then
        ICON=""   # nf-fa-volume_down
    elif [ "$VOL" -le 70 ]; then
        ICON=""   # nf-fa-volume_up
    else
        ICON=""   # nf-fa-volume_high
    fi
}

load_cache
get_icon
echo "<span font_family='JetBrainsMono Nerd Font'>$ICON $VOL%</span>"

pactl subscribe | while read -r line; do
    if echo "$line" | grep -q "sink"; then
        VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')
        MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oP 'yes|no')
        save_cache
        get_icon
        echo "<span font_family='JetBrainsMono Nerd Font'>$ICON $VOL%</span>"
    fi
done

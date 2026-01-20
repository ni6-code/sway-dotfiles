#!/bin/bash

echo "$(date +'%a %b %-d, %H:%M:%S')"

if [ ! -z "$BLOCK_BUTTON" ]; then
    foot -c "$HOME/.config/foot/i3-foot.ini" -T "i3-calendar" -e sh -c "cal -my; read -n 1 -s"
fi

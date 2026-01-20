#!/bin/bash

# Output current keymap
swaymsg -t get_inputs | grep -m 1 "xkb_active_layout_name" | cut -d '"' -f 4 | awk '{print toupper(substr($1,1,2))}'

# Subscribe to the event
swaymsg -t subscribe '["input"]' -m | while read -r line; do
    swaymsg -t get_inputs | grep -m 1 "xkb_active_layout_name" | cut -d '"' -f 4 | awk '{print toupper(substr($1,1,2))}'
done

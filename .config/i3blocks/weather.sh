#!/bin/bash

# Write ur city (e.g. Tokyo)
city="Tokyo"
cachedir=$HOME/.cache/i3-weather
# File name
cachefile="weather_cache_${1:-default}"

if [ ! -d "$cachedir" ]; then
    mkdir -p "$cachedir"
fi

# Saving IFS
SAVEIFS=$IFS
IFS=$'\n'

# Checking cache (1740 sec = 29 min)
if [ ! -f "$cachedir/$cachefile" ] || [ $(($(date +%s) - $(stat -c '%Y' "$cachedir/$cachefile"))) -gt 1740 ]; then
    # Request to wttr.in
    data=($(curl -s "https://en.wttr.in/${city}${1}?0qnT" 2>&1))
    if [ ${#data[@]} -gt 2 ]; then
        echo "${data[0]}" | cut -f1 -d, > "$cachedir/$cachefile"
        echo "${data[1]}" | sed -E 's/^.{15}//' >> "$cachedir/$cachefile"
        echo "${data[2]}" | sed -E 's/^.{15}//' >> "$cachedir/$cachefile"
    fi
fi

if [ -s "$cachedir/$cachefile" ]; then
    weather=($(cat "$cachedir/$cachefile"))
else
    echo "N/A"
    exit 1
fi

IFS=$SAVEIFS

# Обработка температуры
temperature=$(echo "${weather[2]}" | sed -E 's/([[:digit:]]+)\.\./\1-/g' | tr -d ' ')

# Choosing icon
case $(echo "${weather[1]##*,}" | tr '[:upper:]' '[:lower:]' | xargs) in
    "clear" | "sunny") condition="" ;;
    "partly cloudy")   condition="󰖕" ;;
    "cloudy")          condition="" ;;
    "overcast")        condition="" ;;
    "fog" | "freezing fog" | "mist") condition="" ;;
    "patchy rain possible" | "patchy light drizzle" | "light drizzle" | "patchy light rain" | "light rain" | "light rain shower" | "rain") condition="󰼳" ;;
    "moderate rain at times" | "moderate rain" | "heavy rain at times" | "heavy rain" | "moderate or heavy rain shower" | "torrential rain shower") condition="" ;;
    "patchy snow possible" | "patchy sleet possible" | "light snow" | "light snow showers") condition="󰙿" ;;
    "blizzard" | "heavy snow" | "moderate or heavy snow showers") condition="" ;;
    "thundery outbreaks possible" | "patchy light rain with thunder") condition="" ;;
    *) condition="" ;;
esac

# Choosing font and size
ICON_FONT="JetBrainsMono Nerd Font"
TEXT_FONT="JetBrainsMono Nerd Font"

ICON_SIZE="x-large"           # or 'xx-large', '18pt', '200%'
TEXT_SIZE="medium"            # or 'small', '10pt', '80%'

# Output for i3blocks
# 1. Full text
echo "<span font_family='${ICON_FONT}' size='${ICON_SIZE}'>${condition}</span> <span font_family='${TEXT_FONT}' size='${TEXT_SIZE}'>${temperature}</span>"
# 2. Short text
echo "<span font_family='${ICON_FONT}' size='${TEXT_SIZE}'>${condition}</span>"
# 3. Color (optional)
# echo "#FFFFFF"

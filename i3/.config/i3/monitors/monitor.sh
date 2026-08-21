#!/bin/sh
# Default fallback: auto-detect monitor count and configure accordingly
#   1 monitor  -> primary at preferred mode
#   2 monitors -> side by side, primary on the left
#   3+        -> first monitor primary, rest off

CONNECTED=$(xrandr --query | awk '/ connected/ {print $1}')
COUNT=$(echo "$CONNECTED" | wc -l)

if [ "$COUNT" -eq 0 ]; then
    exit 0
elif [ "$COUNT" -eq 1 ]; then
    /usr/bin/xrandr --output "$CONNECTED" --auto --primary
elif [ "$COUNT" -eq 2 ]; then
    PRIMARY=$(echo "$CONNECTED" | head -n1)
    SECOND=$(echo "$CONNECTED" | tail -n1)
    # Get preferred mode of primary; fall back to 1920x1080
    MODE=$(xrandr --query | awk -v p="$PRIMARY" '$1 == p && / preferred/ {print $3; exit}')
    [ -z "$MODE" ] && MODE="1920x1080"
    /usr/bin/xrandr \
        --output "$PRIMARY" --mode "$MODE" --pos 0x0 --rotate normal --primary \
        --output "$SECOND" --mode "$MODE" --pos "${MODE%%x*}x0" --rotate normal
else
    PRIMARY=$(echo "$CONNECTED" | head -n1)
    /usr/bin/xrandr --output "$PRIMARY" --auto --primary
    echo "$CONNECTED" | tail -n +2 | while read -r output; do
        /usr/bin/xrandr --output "$output" --off
    done
fi

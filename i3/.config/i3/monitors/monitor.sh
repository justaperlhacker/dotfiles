#!/bin/sh
# Default fallback: auto-detect monitor count and configure accordingly
#   1 monitor  -> primary at preferred mode
#   2 monitors -> side by side, primary on the left
#   3 monitors -> HDMI on the left in portrait, two DisplayPorts to its right
#   4+         -> first monitor primary, rest off

XRANDR=/usr/bin/xrandr

CONNECTED=$($XRANDR --query | awk '/ connected/ {print $1}')
COUNT=$(printf '%s\n' "$CONNECTED" | grep -c .)

# First (normally preferred) mode reported for an output
first_mode() {
    $XRANDR --query | awk -v p="$1" '
        $1 == p { found = 1; next }
        found && /^[[:space:]]+[0-9]+x[0-9]+/ { print $1; exit }
    '
}

if [ "$COUNT" -eq 0 ]; then
    exit 0
elif [ "$COUNT" -eq 1 ]; then
    $XRANDR --output "$CONNECTED" --auto --primary
elif [ "$COUNT" -eq 2 ]; then
    PRIMARY=$(printf '%s\n' "$CONNECTED" | head -n1)
    SECOND=$(printf '%s\n' "$CONNECTED" | tail -n1)
    MODE=$(first_mode "$PRIMARY")
    [ -z "$MODE" ] && MODE="1920x1080"
    SMODE=$(first_mode "$SECOND")
    [ -z "$SMODE" ] && SMODE="$MODE"
    $XRANDR \
        --output "$PRIMARY" --mode "$MODE" --pos 0x0 --rotate normal --primary \
        --output "$SECOND" --mode "$SMODE" --pos "${MODE%%x*}x0" --rotate normal
elif [ "$COUNT" -eq 3 ]; then
    HDMI=$(printf '%s\n' "$CONNECTED" | grep -E '^HDMI' | head -n1)
    DP1=$(printf '%s\n' "$CONNECTED" | grep -E '^(DP|DisplayPort)' | sed -n 1p)
    DP2=$(printf '%s\n' "$CONNECTED" | grep -E '^(DP|DisplayPort)' | sed -n 2p)

    if [ -n "$HDMI" ] && [ -n "$DP1" ] && [ -n "$DP2" ]; then
        HMODE=$(first_mode "$HDMI"); [ -z "$HMODE" ] && HMODE=1920x1080
        M1=$(first_mode "$DP1"); [ -z "$M1" ] && M1=1920x1080
        M2=$(first_mode "$DP2"); [ -z "$M2" ] && M2=1920x1080
        # Rotating the HDMI output swaps its logical width and height
        PORTRAIT_W=${HMODE#*x}
        MID_W=${M1%%x*}
        MID_H=${M1#*x}
        Y=$(( (PORTRAIT_W - MID_H) / 2 ))
        [ "$Y" -lt 0 ] && Y=0
        $XRANDR \
            --output "$HDMI" --mode "$HMODE" --pos 0x0 --rotate right \
            --output "$DP1" --mode "$M1" --pos "${PORTRAIT_W}x${Y}" --rotate normal --primary \
            --output "$DP2" --mode "$M2" --pos "$((PORTRAIT_W + MID_W))x${Y}" --rotate normal
    else
        PRIMARY=$(printf '%s\n' "$CONNECTED" | head -n1)
        $XRANDR --output "$PRIMARY" --auto --primary
        printf '%s\n' "$CONNECTED" | tail -n +2 | while read -r out; do
            $XRANDR --output "$out" --off
        done
    fi
else
    PRIMARY=$(printf '%s\n' "$CONNECTED" | head -n1)
    $XRANDR --output "$PRIMARY" --auto --primary
    printf '%s\n' "$CONNECTED" | tail -n +2 | while read -r out; do
        $XRANDR --output "$out" --off
    done
fi

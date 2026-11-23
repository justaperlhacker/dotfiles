#!/bin/sh
# Destro desktop: three monitors, HDMI portrait on the left, middle is primary
/usr/bin/xrandr \
  --output HDMI-A-2 --mode 1920x1080 --pos 0x0 --rotate right \
  --output DisplayPort-4 --mode 1920x1080 --pos 1080x420 --rotate normal --primary \
  --output DisplayPort-6 --mode 1920x1080 --pos 3000x420 --rotate normal \
  --output DisplayPort-5 --off

#!/bin/sh
/usr/bin/xrandr \
  --output HDMI-A-1 --mode 1920x1080 --pos 0x0 --rotate normal --primary \
  --output DisplayPort-3 --mode 1920x1080 --pos 1920x0 --rotate normal \
  --output DisplayPort-4 --off \
  --output DisplayPort-5 --off

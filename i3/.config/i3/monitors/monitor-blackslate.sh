#!/bin/sh
# Blackslate laptop: internal eDP-1 at native resolution with HiDPI
/usr/bin/xrandr \
  --output eDP-1 --mode 2736x1824 --pos 0x0 --rotate normal --primary \
  --dpi 192 \
  --output HDMI-A-1 --off \
  --output DisplayPort-3 --off \
  --output DisplayPort-4 --off \
  --output DisplayPort-5 --off

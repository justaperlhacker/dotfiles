#!/bin/sh
# Host-specific niri autostart for blackslate.
# Sourced from ../niri-autostart.sh, so keep it POSIX sh and top-level only.
#
# No tray apps here on purpose: blackslate is the memory-constrained host, so
# heavy Electron clients (Discord, ...) live in autostart/destro.sh instead.

# Other host-specific extras (examples, keep as needed):
# swaybg -i ~/Pictures/wallpaper.png &
# kanshi >/dev/null 2>&1 &

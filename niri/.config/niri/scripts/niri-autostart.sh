#!/bin/sh
# Common niri autostart.
#
# Host-specific startup lives in ./autostart/<hostname>.sh, e.g.
#   autostart/destro.sh
# It is sourced (not executed), so it shares this environment, and it is
# optional: if no matching file exists nothing extra is run.

self=$0
[ -L "$self" ] && self=$(readlink -f "$self")
script_dir=$(CDPATH= cd -- "$(dirname -- "$self")" && pwd)

# --- common startup -------------------------------------------------------
# X11 settings (harmless on Wayland, needed for Xwayland apps)
xset r rate 300 50
xset b off
xset s 480 dpms 600 600 600
xrdb -merge ~/.Xresources

# --- host-specific extras -------------------------------------------------
# Prefer the short hostname, fall back to the full one.
for host in "$(hostname -s 2>/dev/null)" "$(hostname 2>/dev/null)"; do
    [ -n "$host" ] || continue
    host_autostart="$script_dir/autostart/$host.sh"
    if [ -r "$host_autostart" ]; then
        source "$host_autostart"
        break
    fi
done

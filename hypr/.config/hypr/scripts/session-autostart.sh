#!/bin/sh
# X11/Xwayland session settings (harmless on Wayland).

if command -v xset >/dev/null 2>&1; then
    xset r rate 300 50
    xset b off
    xset s 480 dpms 600 600 600
fi

if [ -f "$HOME/.Xresources" ] && command -v xrdb >/dev/null 2>&1; then
    xrdb -merge "$HOME/.Xresources"
fi

exit 0

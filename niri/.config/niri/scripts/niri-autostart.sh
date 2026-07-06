#!/bin/sh
# X11 settings (harmless on Wayland, needed for Xwayland apps)
xset r rate 300 50
xset b off
xset s 480 dpms 600 600 600
xrdb -merge ~/.Xresources

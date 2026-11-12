#!/bin/sh
# Host-specific i3 autostart for destro.
# Sourced from ../autostart-host.sh; helpers have() and is_running() are in scope.

# Discord: start minimized in the tray. Guard against a second copy when i3 is
# restarted (exec in autostart.conf runs again on a full restart, not on reload).
if is_running Discord || is_running discord; then
    :
elif have discord; then
    discord --start-minimized >/dev/null 2>&1 &
fi

# Drop-down terminal. Guard so an i3 restart does not start a second copy.
if is_running yakuake; then
    :
elif have yakuake; then
    yakuake >/dev/null 2>&1 &
fi

# Other host-specific extras (examples, keep as needed):
# nitrogen --restore &

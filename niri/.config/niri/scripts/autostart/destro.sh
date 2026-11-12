#!/bin/sh
# Host-specific niri autostart for destro.
# Sourced from ../niri-autostart.sh, so keep it POSIX sh and top-level only.
# All helpers defined there (log, is_running, is_pending, start_bg) are in scope.

# Discord is a tray app, so wait until the bar exports StatusNotifierWatcher
# (exec-after-sni does that) and skip if it is already running or queued.
# Only started here: blackslate is memory-constrained and deliberately omits it.
if is_running Discord || is_running discord ||
    is_pending "$script_dir/exec-after-sni discord"; then
    log "discord already running or queued; skipping"
else
    log "launching discord via exec-after-sni"
    start_bg "$script_dir/exec-after-sni" discord
fi

# Other host-specific extras (examples, keep as needed):
# swaybg -i ~/Pictures/wallpaper.png &
# kanshi >/dev/null 2>&1 &

# Yakuake is not launched here: its XDG autostart entry is gated to destro by
# ~/.config/systemd/user/app-org.kde.yakuake@autostart.service.d/10-host.conf
# (ConditionHost=destro). Adding it here too would start it twice on destro.

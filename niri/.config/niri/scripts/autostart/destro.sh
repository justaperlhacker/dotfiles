#!/bin/sh
# Host-specific niri autostart for destro.
# Sourced from ../niri-autostart.sh, so keep it POSIX sh and top-level only.
# All helpers defined there (log, is_running, is_pending, start_bg) are in scope.

# Discord (Electron) samples the system light/dark preference once, at startup,
# and does not re-read it when gsettings or the portal change. Launching it
# before dms-theme-sync has applied the mode therefore leaves it stuck on the
# previous session's theme until it is restarted manually. Wait until the sync
# service has written a real color-scheme ('default' means "no preference",
# which Chromium treats as dark). Bounded, so a broken sync cannot hang startup.
wait_color_scheme() {
    _wc_i=0
    while [ "$_wc_i" -lt 75 ]; do # 75 * 0.2s = 15s
        _wc_scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
        case $_wc_scheme in
            "'prefer-light'" | "'prefer-dark'") return 0 ;;
        esac
        _wc_i=$((_wc_i + 1))
        sleep 0.2
    done
    log "color-scheme still 'default'; launching Discord anyway"
    return 1
}

# Discord is a tray app, so wait until the bar exports StatusNotifierWatcher
# (exec-after-sni does that) and skip if it is already running or queued.
# Only started here: blackslate is memory-constrained and deliberately omits it.
if is_running Discord || is_running discord ||
    is_pending "$script_dir/exec-after-sni discord"; then
    log "discord already running or queued; skipping"
else
    have gsettings && wait_color_scheme
    log "launching discord via exec-after-sni"
    start_bg "$script_dir/exec-after-sni" discord
fi

# Other host-specific extras (examples, keep as needed):
# swaybg -i ~/Pictures/wallpaper.png &
# kanshi >/dev/null 2>&1 &

# Yakuake is not launched here: its XDG autostart entry is gated to destro by
# ~/.config/systemd/user/app-org.kde.yakuake@autostart.service.d/10-host.conf
# (ConditionHost=destro). Adding it here too would start it twice on destro.

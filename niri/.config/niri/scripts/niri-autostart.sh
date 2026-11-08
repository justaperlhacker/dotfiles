#!/bin/sh
# Common niri autostart.
#
# Every ordering-sensitive startup step lives here; config.kdl only spawns this
# script. Cross-process waits use the helpers in ./wait-lib.sh.
#
# Host-specific startup lives in ./autostart/<hostname>.sh, e.g.
#   autostart/destro.sh
# It is sourced (not executed), so it shares this environment, and it is
# optional: if no matching file exists nothing extra is run.
#
# Safe to re-run: already-running processes and one-shot session actions are
# detected and skipped.

self=$0
[ -L "$self" ] && self=$(readlink -f "$self")
script_dir=$(unset CDPATH; cd -- "$(dirname -- "$self")" && pwd -P)

. "$script_dir/wait-lib.sh"

uid=$(id -u)
runtime=${XDG_RUNTIME_DIR:-/tmp}

log()        { echo "${0##*/}: $*" >&2; }
have()       { command -v "$1" >/dev/null 2>&1; }
is_running() { pgrep -u "$uid" -x "$1" >/dev/null 2>&1; }
is_pending() { pgrep -u "$uid" -f "$1" >/dev/null 2>&1; }
marker()     { echo "$runtime/niri-autostart.$uid.$1"; }
done_once()  { [ -e "$(marker "$1")" ]; }
mark_done()  { : > "$(marker "$1")"; }

# Start CMD in the background with this script's lock fd closed, so long-lived
# children don't keep the lock after this script exits.
start_bg() { "$@" 9>&- & }

# Convenience for host fragments: start_once NAME CMD...
start_once() {
    _start_name=$1
    shift
    if is_running "$_start_name"; then
        log "$_start_name already running; skipping"
        return 0
    fi
    start_bg "$@"
}

# --- one instance at a time ------------------------------------------------
if command -v flock >/dev/null 2>&1; then
    exec 9>"$runtime/niri-autostart.$uid.lock"
    flock -n 9 || {
        log "another instance is running; exiting"
        exit 0
    }
fi

# --- session environment ---------------------------------------------------
# systemd units get this from environment.d and niri.service.d before niri
# starts; this covers services activated through the D-Bus daemon instead.
if have dbus-update-activation-environment; then
    dbus-update-activation-environment --systemd \
        XDG_CURRENT_DESKTOP=niri:KDE:gnome \
        KDE_SESSION_VERSION=6 \
        KDE_FULL_SESSION=true \
        QT_QPA_PLATFORMTHEME=kde \
        QT_STYLE_OVERRIDE=Breeze
fi

# --- tray app after the bar exports StatusNotifierWatcher ------------------
if is_running Discord || is_running discord ||
    is_pending "$script_dir/exec-after-sni discord"; then
    log "discord already running or queued; skipping"
else
    start_bg "$script_dir/exec-after-sni" discord
fi

# --- restart portal-gnome once niri exports Mutter.ScreenCast ---------------
# Fixes the startup race that otherwise leaves screencasting (OBS) with a
# black screen / no source picker. At most once per session.
if done_once screencast; then
    log "screencast portal restart already scheduled; skipping"
else
    mark_done screencast
    (
        exec 9>&-
        wait_for_bus org.gnome.Mutter.ScreenCast 150 &&
            pkill -f xdg-desktop-portal-gnome
    ) &
fi

# --- KWallet: unlock via the password stashed by SDDM's pam_kwallet5.so ----
if done_once wallet; then
    log "wallet already handled this session; skipping"
else
    # isOpen also D-Bus-activates kwalletd6 when available.
    if have busctl &&
        [ "$(busctl --user --no-pager call org.kde.kwalletd6 \
            /modules/kwalletd6 org.kde.KWallet isOpen s kdewallet 2>/dev/null)" = "b true" ]; then
        log "wallet already open; skipping unlock"
        mark_done wallet
    else
        if ! have busctl ||
            ! busctl --user status org.kde.kwalletd6 >/dev/null 2>&1; then
            have kwalletd6 && start_bg kwalletd6
        fi

        if wait_for_bus org.kde.kwalletd6 25; then
            if [ -x /usr/lib/pam_kwallet_init ] && /usr/lib/pam_kwallet_init; then
                mark_done wallet
            fi
        else
            log "kwalletd6 not on bus; skipping pam_kwallet_init"
        fi
    fi
fi

# --- X11 settings (harmless on Wayland, needed for Xwayland apps) ----------
# xset is itself an X11 client, so this also triggers xwayland-satellite.
i=0
while [ "$i" -lt 25 ] && ! xset q >/dev/null 2>&1; do
    i=$((i + 1))
    sleep 0.2
done
if xset q >/dev/null 2>&1; then
    xset r rate 300 50
    xset b off
    xset s 480 600
    # Xwayland has no DPMS extension; the failure is expected.
    xset dpms 600 600 600 2>/dev/null
    xrdb -merge ~/.Xresources
else
    log "Xwayland unavailable; skipped xset/xrdb"
fi

# --- host-specific extras --------------------------------------------------
# Prefer the short hostname, fall back to the full one.
for host in "$(hostname -s 2>/dev/null)" "$(hostname 2>/dev/null)"; do
    [ -n "$host" ] || continue
    host_autostart="$script_dir/autostart/$host.sh"
    if [ -r "$host_autostart" ]; then
        # shellcheck disable=SC1090
        . "$host_autostart"
        break
    fi
done

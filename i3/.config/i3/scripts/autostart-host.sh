#!/bin/sh
# Run the host-specific i3 autostart fragment, if one exists.
#
# Fragments live in ./autostart/<hostname>.sh and are sourced (not executed),
# so they can use the helpers below. Long-lived programs must be backgrounded
# with &, because this dispatcher exits as soon as the fragment returns.
#
# Called from i3's autostart.conf. Host-only startup belongs in the fragment;
# keep autostart.conf for things every host should run.

self=$0
[ -L "$self" ] && self=$(readlink -f "$self")
script_dir=$(unset CDPATH; cd -- "$(dirname -- "$self")" && pwd -P)

have()       { command -v "$1" >/dev/null 2>&1; }
is_running() { pgrep -u "$(id -u)" -x "$1" >/dev/null 2>&1; }

for host in "$(hostname -s 2>/dev/null)" "$(hostname 2>/dev/null)"; do
    [ -n "$host" ] || continue
    fragment=$script_dir/autostart/$host.sh
    if [ -r "$fragment" ]; then
        # shellcheck disable=SC1090
        . "$fragment"
        exit 0
    fi
done

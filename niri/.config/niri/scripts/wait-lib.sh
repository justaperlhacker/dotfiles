#!/bin/sh
# Shared D-Bus wait helpers for niri startup scripts.
#
# Source this file, do not execute it:
#     . "$(dirname "$0")/wait-lib.sh"
#
# Default budget: 50 tries * 0.2s = 10s. Callers may override per call.
# Variables are prefixed with _wait_ to stay out of the caller's namespace.

: "${WAIT_TRIES:=50}"
: "${WAIT_INTERVAL:=0.2}"

_wait_log() {
    echo "${0##*/}: $*" >&2
}

# wait_for_bus NAME [TRIES] [INTERVAL]
# Succeeds once NAME is owned on the user bus.
wait_for_bus() {
    _wait_name=$1
    _wait_tries=${2:-$WAIT_TRIES}
    _wait_interval=${3:-$WAIT_INTERVAL}
    _wait_i=0

    if ! command -v busctl >/dev/null 2>&1; then
        _wait_log "busctl not found; cannot wait for $_wait_name"
        return 1
    fi

    while [ "$_wait_i" -lt "$_wait_tries" ]; do
        if busctl --user --no-pager status "$_wait_name" >/dev/null 2>&1; then
            return 0
        fi
        _wait_i=$((_wait_i + 1))
        sleep "$_wait_interval"
    done

    _wait_log "timed out waiting for bus name $_wait_name"
    return 1
}

# wait_for_prop NAME PATH IFACE PROP EXPECTED [TRIES] [INTERVAL]
# Succeeds once PROP equals EXPECTED (compared against the trailing field of
# `busctl get-property` output, e.g. "b true").
wait_for_prop() {
    _wait_name=$1
    _wait_path=$2
    _wait_iface=$3
    _wait_prop=$4
    _wait_expected=$5
    _wait_tries=${6:-$WAIT_TRIES}
    _wait_interval=${7:-$WAIT_INTERVAL}
    _wait_i=0

    if ! command -v busctl >/dev/null 2>&1; then
        _wait_log "busctl not found; cannot wait for $_wait_name $_wait_prop"
        return 1
    fi

    while [ "$_wait_i" -lt "$_wait_tries" ]; do
        _wait_got=$(busctl --user --no-pager get-property \
            "$_wait_name" "$_wait_path" "$_wait_iface" "$_wait_prop" 2>/dev/null)
        _wait_got=${_wait_got##* }
        if [ "$_wait_got" = "$_wait_expected" ]; then
            return 0
        fi
        _wait_i=$((_wait_i + 1))
        sleep "$_wait_interval"
    done

    _wait_log "timed out waiting for $_wait_name $_wait_prop = $_wait_expected"
    return 1
}

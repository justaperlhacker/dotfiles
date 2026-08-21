#!/bin/sh
# Select monitor layout based on hostname

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOST="$(hostname)"

case "$HOST" in
    blackslate)
        exec "$SCRIPT_DIR/monitor-blackslate.sh"
        ;;
    destro)
        exec "$SCRIPT_DIR/monitor-destro.sh"
        ;;
    *)
        exec "$SCRIPT_DIR/monitor.sh"
        ;;
esac

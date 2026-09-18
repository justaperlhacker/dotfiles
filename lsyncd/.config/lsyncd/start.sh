#!/bin/bash
set -euo pipefail

case "$(hostname)" in
    blackslate) SHARED_DIR="${HOME}/shared/SDXC/sync/Projects" ;;
    destro)     SHARED_DIR="${HOME}/shared/UGREEN/sync/Projects" ;;
    *)          echo "lsyncd-wrapper: unknown hostname '$(hostname)', aborting" >&2; exit 1 ;;
esac

CHECK_INTERVAL=5

echo "lsyncd-wrapper: waiting for ${SHARED_DIR} to be available..."
while [ ! -d "${SHARED_DIR}" ]; do
    sleep "${CHECK_INTERVAL}"
done
echo "lsyncd-wrapper: ${SHARED_DIR} found, starting lsyncd"

exec lsyncd -nodaemon "${HOME}/.config/lsyncd/config.lua"

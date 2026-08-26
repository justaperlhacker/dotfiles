#!/bin/bash
set -euo pipefail

SHARED_DIR="${HOME}/shared/Projects"
CHECK_INTERVAL=5

echo "lsyncd-wrapper: waiting for ${SHARED_DIR} to be available..."
while [ ! -d "${SHARED_DIR}" ]; do
    sleep "${CHECK_INTERVAL}"
done
echo "lsyncd-wrapper: ${SHARED_DIR} found, starting lsyncd"

exec lsyncd -nodaemon "${HOME}/.config/lsyncd/config.lua"

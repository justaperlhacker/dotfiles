#!/bin/sh
# enable-user-units.sh
# Idempotently enable all stowed user-level systemd units.
# Enablement state (.wants symlinks) is local machine state and is NOT
# managed by stow (see .stow-local-ignore). This script recreates it.
#
# Usage: sh ~/.config/systemd/user/scripts/enable-user-units.sh
set -eu

printf '[*] Reloading user manager...\n'
systemctl --user daemon-reload

for unit in \
    ssh-agent.service \
    ssh-add-key.service \
    kanata.service \
    llamacpp.service \
    app-nmx2dapplet@autostart.service ; do
    if [ -e "/usr/lib/systemd/user/${unit}" ] || [ -e "${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user/${unit}" ]; then
        printf '[*] Enabling %s\n' "$unit"
        systemctl --user enable "$unit"
    else
        printf '[!] Skipping missing unit: %s\n' "$unit"
    fi
done

# dms.service is pulled in via niri.service.wants (managed by systemctl enable niri)
# Uncomment if you want it enabled independently:
# systemctl --user enable dms.service || true

# Start services that should be running now (oneshot ssh-add-key just enables state).
for unit in ssh-agent.service kanata.service llamacpp.service app-nmx2dapplet@autostart.service; do
    systemctl --user start "$unit" 2>/dev/null || true
done

# Persist user services across reboots even without an active session.
if command -v loginctl >/dev/null 2>&1; then
    loginctl enable-linger "$(id -un)" 2>/dev/null || true
fi

printf '[*] Done. Enabled user units:\n'
systemctl --user list-unit-files --type=service --no-legend --no-pager \
    | grep -w enabled || true

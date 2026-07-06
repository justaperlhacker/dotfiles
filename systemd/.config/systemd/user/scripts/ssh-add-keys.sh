#!/bin/sh
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export SSH_ASKPASS="/usr/bin/ksshaskpass"

for key in ~/.ssh/id_*; do
    [ -f "$key" ] || continue
    if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$key" | awk '{print $2}')"; then
        ssh-add -q "$key"
    fi
done < /dev/null


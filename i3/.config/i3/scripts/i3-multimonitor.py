#!/usr/bin/env python3
import i3ipc

KEYS = {str(i): i for i in range(1, 9)}
MONITOR_SUFFIX = {"HDMI-A-1": "a", "DisplayPort-3": "b"}


def handle(i3, event):
    binding = event.binding
    if binding.command != "nop":
        return
    local_index = KEYS.get(binding.symbol)
    if local_index is None:
        return
    focused = next(w for w in i3.get_workspaces() if w.focused)
    suffix = MONITOR_SUFFIX.get(focused.output)
    if suffix is None:
        return
    target = f"{local_index}{suffix}"
    if target == focused.name:
        return
    if "control" in binding.event_state_mask:
        command = f"move container to workspace {target}"
    elif "shift" in binding.event_state_mask:
        command = f"move container to workspace {target}; workspace {target}"
    else:
        command = f"workspace {target}"
    i3.command(command)


def main():
    i3 = i3ipc.Connection()
    i3.on("binding", handle)
    i3.main()


if __name__ == "__main__":
    main()

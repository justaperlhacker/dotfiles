#!/usr/bin/env bash
# List all effective kitty shortcuts (defaults + kitty.conf) as `key -> action`.
# kitty_mod is resolved to ctrl+shift; hover macOS-only "cmd" bindings are filtered.
# Usage: kitty-shortcuts.sh [linux|mac]
set -euo pipefail
mode="${1:-linux}"

kitty +runpy "
from kitty.options.definition import definition as d
import sys
out = []
for sm in d.iter_all_maps():
    if not sm.as_conf():
        continue
    for line in sm.as_conf():
        line = line.strip()
        if not line.startswith('map '):
            continue
        line = line.replace('kitty_mod', 'ctrl+shift')
        parts = [p for p in line.split() if not p.startswith('--')]
        if len(parts) < 2:
            continue
        key = parts[1]
        action = ' '.join(parts[2:]) if len(parts) > 2 else '(action only)'
        if 'cmd+' in key and '${mode}' != 'mac':
            continue
        out.append(f'{key} -> {action}')
seen = set()
for l in out:
    if l not in seen:
        seen.add(l)
        print(l)
"

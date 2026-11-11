# i3 configuration

## Theme system

The active theme is `themes/active` (a generated symlink, gitignored).
`appearance.conf` includes `themes/active/i3.conf`, which provides both the
client colours and the `$i3bar_*` variables used by `bar.conf`. This means the
i3bar palette follows the selected theme.

`switch-theme` updates the symlink and the rofi/dunst themes, then reloads i3.
It writes these generated, gitignored runtime files:

- `themes/active`
- `rofi/theme-active.rasi`
- `dunst/dunstrc.active`

The tracked `rofi/config.rasi` and `dunst/dunstrc` are stable bases; they are
not rewritten on every switch.

## Automatic light/dark mode

`i3-theme-sync` reads KDE NightTime's sunrise/sunset schedule over D-Bus and
applies it to i3, i3bar, rofi, dunst, GTK, KDE/Qt, kitty and Ghostty. It is
started only from i3's autostart. There is no systemd user unit or XDG
autostart entry for it; the daemon also exits if `i3-msg -t get_version` fails,
so it cannot start itself in a niri or Plasma session.

The automatic theme pair is configured in `theme-sync.conf`:

```ini
DARK=github-dark
LIGHT=github-light
```

Environment variables `I3_DARK_THEME` and `I3_LIGHT_THEME` override those
values (useful for testing). If the KDE daemon cannot provide a schedule, the
script falls back to the `[Times]` values in `~/.config/knighttimerc`.

The running daemon re-reads `theme-sync.conf` on every poll. If you change it
while the session is active, the current mode is re-applied with the new theme
within 60 seconds. To apply immediately, run `i3-theme-sync --mode dark` or
`i3-theme-sync --mode light`.

GTK and KDE/Qt do not have GitHub-specific themes installed, so the sync uses
Breeze Dark/Light for applications. The i3, i3bar, rofi, dunst and terminal
palettes use the GitHub themes.

Useful commands:

```sh
i3-theme-sync --get-mode            # current dark/light decision
i3-theme-sync --mode dark           # force the configured dark theme
i3-theme-sync --mode light          # force the configured light theme
i3-theme-sync --theme github-dark   # apply one theme manually
i3-theme-sync --once                # apply the current mode and exit
```

The sync restarts `knighttimed` after starting the GeoClue demo agent, so KDE
uses its cached location and real sunrise/sunset instead of the 06:00/18:00
timed fallback. Logs live in `~/.local/state/i3-theme-sync/log`.

## Manual theme picker (fzf)

`i3-theme-picker` lists the available i3 themes in fzf and applies the selected
theme to i3, i3bar, rofi, dunst, kitty and Ghostty:

```sh
i3-theme-picker
i3-theme-picker --list
```

If `themes/<name>/mode` exists (`dark` or `light`), the picker also applies the
matching GTK/KDE palette. Manual selection does not change the scheduled-mode
state, so the automatic pair is applied again at the next sunrise/sunset
transition. To make a manual choice permanent, put it in `theme-sync.conf`.

## GitHub themes

Two GitHub Primer themes are included:

- `github-dark` — canvas `#0d1117`, foreground `#e6edf3`, accent `#58a6ff`
- `github-light` — canvas `#ffffff`, foreground `#24292f`, accent `#0969da`

Each theme has:

- `themes/<name>/i3.conf` — client colours and i3bar variables
- `themes/<name>/rofi.rasi`
- `themes/<name>/dunst.conf`
- `themes/<name>/mode` — `dark` or `light` (used by the picker for GTK/KDE)

Matching terminal palettes are installed at:

- `~/.config/kitty/github-{dark,light}.conf`
- `~/.config/ghostty/themes/github-{dark,light}`

## Adding a theme

1. Create `themes/<name>/i3.conf` with the `client.*` colours and the
   `$i3bar_*` variables (see an existing theme for the full list).
2. Optionally add `rofi.rasi`, `dunst.conf`, and a `mode` file containing
   `dark` or `light`.
3. Optionally add a kitty palette at `~/.config/kitty/<name>.conf` and a
   Ghostty theme at `~/.config/ghostty/themes/<name>`.
4. Apply it with `switch-theme <name>` or `i3-theme-picker`.
5. To use it in automatic mode, set it as `DARK` or `LIGHT` in
   `theme-sync.conf`.

## Keyboard

`scripts/set-keymap` applies the same remap as niri and Plasma: Caps Lock is an
additional Left Ctrl and Right Alt is an additional Left Super. It feeds the
keymap through `xkbcomp` with `~/.config/xkb` on the include path because
`setxkbmap` does not forward its `-I` option to `xkbcomp`.

`scripts/xset-keyboard` sets the keyboard repeat rate (300 ms delay, 50 Hz) and
turns the X bell off. It runs from `autostart.conf` with `exec_always`, so
`i3-msg reload` also re-applies the settings.

# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

Clone to `~/.dotfiles`:

```bash
git clone git@github-justaperlhacker:justaperlhacker/dotfiles.git ~/.dotfiles
```

## Install script

`install.pl` is a wrapper around Stow that **backs up any existing file or
directory before it is replaced**, so nothing is ever silently clobbered.

```bash
./install.pl --all                                     # stow every package
./install.pl --package bash --package nvim --package i3  # specific packages
./install.pl --list                                    # list available packages
./install.pl --help                                    # show options
```

`--all` and `--package` cannot be combined. Exit codes: `0` success, `2`
usage error, `1` failure (e.g. Stow conflict).

## Manual Stow usage

Stow creates symlinks from your home directory into the appropriate package directory.

```bash
stow bash             # install one package
stow bash nvim i3     # install several
stow -D bash          # remove symlinks
```

### Packages

| Package           | What it links                                             |
|-------------------|-----------------------------------------------------------|
| `bash`            | `.bashrc`, `.bash_profile`, `.bash_logout`, `.inputrc`, `.config/bash/` |
| `brave`           | `.config/brave-flags.conf`, `.config/brave-flags.d/`, `.local/bin/brave` |
| `DankMaterialShell`| `.config/DankMaterialShell/`                              |
| `doom`            | `.config/doom/`                                           |
| `ghostty`         | `.config/ghostty/` (incl. cursor-trail shaders)           |
| `hypr`            | `.config/hypr/` (Hyprland Lua config + scripts)           |
| `i3`              | `.config/i3/`, `.xprofile`                                |
| `kanata`          | `.config/kanata/`, `.config/systemd/user/kanata.service`  |
| `kde`             | portable `.config/*rc` + `kdeglobals`/`kwalletrc` etc., `.config/xkb/` (keyboard remap) |
| `kitty`           | `.config/kitty/`, `.config/xdg-terminals.list` (default terminal), `.local/share/applications/kitty.desktop` |
| `kilo`            | `.config/kilo/`                                           |
| `LazyVim`         | `.config/LazyVim/`                                        |
| `nano`            | `.config/nano/`                                           |
| `neovide`         | `.config/neovide/`                                        |
| `niri`            | `.config/niri/`, `.config/xdg-desktop-portal/`, `.config/autostart/OneDriveGUI.desktop`, `.config/environment.d/`, `.config/systemd/user/{xembedsniproxy,dms-theme-sync}.service`, `niri.service.d/`, `dms.service.d/` |
| `noctalia`        | `.config/noctalia/`                                       |
| `NvChad`          | `.config/NvChad/`                                         |
| `nvim`            | `.config/nvim/`                                           |
| `perl`            | `.perltidyrc`                                             |
| `pi`              | `.pi/agent/settings.json`, `.pi/agent/models-store.json`  |
| `plasma`          | `.local/share/kwin/scripts/`, `.local/share/applications/tmux-scratchpad.desktop`, `.config/systemd/user/plasma-toggle-tmux@.service` |
| `redshift`        | `.config/redshift/`                                       |
| `scripts`         | `.local/bin/` (incl. `xdg-terminal-exec`)                 |
| `starship`        | `.config/starship.toml`                                   |
| `terminator`      | `.config/terminator/` (incl. `terminator-themes` plugin)  |
| `tmux`            | `.config/tmux/`                                           |
| `vscode`          | `.config/Code/User/`                                      |
| `xresources`      | `.Xresources`, `.Xresources.d/`                           |

### Default terminal (`xdg-terminal-exec`)

Apps whose `.desktop` file sets `Terminal=true` (e.g. Cachy-Update) are launched
by GLib/DMS via `xdg-terminal-exec` on `PATH`. Without it, GLib falls back to a
hardcoded list in which `gnome-terminal` wins over kitty/konsole.

- `scripts` provides `~/.local/bin/xdg-terminal-exec`, a small wrapper that runs
  the first available terminal: kitty → konsole → terminator → gnome-terminal →
  alacritty → foot → ghostty → wezterm → xterm.
- `kitty` provides `~/.config/xdg-terminals.list` (`kitty.desktop`), the
  xdg-terminals spec list.

To use the packaged reference implementation instead, install `xdg-terminal-exec`
from `extra` and remove `~/.local/bin/xdg-terminal-exec` — it shadows the package
because `~/.local/bin` comes first on `PATH`.

### kitty cursor animations (`cursor_trail`)

Cursor animations are the builtin `cursor_trail` feature (kitty 0.37+, custom
shader styles from 0.49). They are **enabled** in `kitty.conf` — `cursor_trail`
set to a value larger than zero turns them on, `0` turns them off:

```conf
# Cursor trail
cursor_trail 2                    # enable; <ms> a cursor must hold still before
                                  # its movement gets a trail (lower = chattier)
cursor_trail_decay 0.2 0.6        # fade-out time range in seconds
                                  # (fastest slowest); lower = snappier fade
cursor_trail_start_threshold 1    # cells moved before the trail starts,
                                  # per axis; default 2 skips tiny steps
# cursor_trail_color #ff9e64      # trail color; default = cursor's color
```

Differences from the stock defaults (`0`, `0.1 0.4`, `2`): trails trigger on
smaller moves and fade a bit slower, tuned for trying to track big cursor
jumps around large code buffers. To tune live, press `CTRL+SHIFT+F5`
(`load_config_file`) to reload `kitty.conf` in the current window; no restart
needed. (`kitty @ load-config` also works, but needs `allow_remote_control`
enabled, which this config leaves off.)

Custom trail styles are set via `custom_shaders` in `kitty.conf`:

| Value                        | Effect                                  |
|------------------------------|-----------------------------------------|
| (none)                       | plain trail (current setup)             |
| `cursor-trail-motion-blur`   | smooths fast moves with motion blur     |
| `cursor-trail-blaze`         | fiery blaze style                       |
| `cursor-trail-railgun`       | particle stream flying off the cursor   |
| `cursor-trail-torpedo`       | torpedo-like particle burst             |
| `cursor-trail-pixiedust`     | fairy-dust particles                    |

The trail follows the text cursor only, and never appears while the cursor is
resting; only movement you can see gets animated.

### niri tray icons (XEmbed → SNI bridge)

DankMaterialShell's tray only speaks StatusNotifierItem, but Wine (EA App via
Lutris) and other legacy X11 apps use the XEmbed protocol. `xembedsniproxy`
bridges the two; without it Wine draws its own floating "tray" window.

niri tears Xwayland down when the last X11 app exits, which kills the proxy
too, so the `niri` package ships it as a systemd user service that is
restarted automatically instead of a one-shot `spawn-at-startup`.

```bash
sudo pacman -S --needed plasma-workspace   # provides /usr/bin/xembedsniproxy
systemctl --user enable --now xembedsniproxy.service
```

The `OneDriveGUI.desktop` autostart entry starts via
`~/.config/niri/scripts/exec-after-sni` because OneDriveGUI checks
`QSystemTrayIcon.isSystemTrayAvailable()` once at startup and silently skips
creating its icon if DMS's SNI host isn't registered yet.

### Hyprland + Noctalia + KDE (CachyOS)

The `hypr` (Hyprland Lua config), `noctalia` (Noctalia v5 shell), and `kde`
(portable KDE/Qt app config) packages provide a Hyprland session running
Noctalia alongside the existing niri session. Install the base packages first:

```bash
sudo pacman -S --needed \
  hyprland xdg-desktop-portal-hyprland noctalia \
  plasma-integration breeze breeze-gtk qqc2-desktop-style \
  kde-cli-tools kio kio-extras \
  kwallet kwallet-pam kwalletmanager \
  polkit-kde-agent xdg-desktop-portal-kde \
  konsole yakuake dolphin qt5ct qt6ct qt5-wayland qt6-wayland \
  power-profiles-daemon bluez bluez-utils networkmanager \
  pipewire wireplumber upower gnome-keyring libsecret \
  ddcutil playerctl wl-clipboard
```

Then `./install.pl --package hypr --package noctalia --package kde`.

`hyprland-portals.conf` (for the Hyprland session) ships inside the `niri`
package's `.config/xdg-desktop-portal/`.

Per-host monitor overrides go in `~/.config/hypr/local.lua` (untracked).

### VS Code custom themes

The custom color themes (Miniwinter, Vague, Kanso, Black Metal Gorgoroth) live
in a standalone project, `justaperlhacker/vscode-themes`, and are installed into
VS Code as the `justaperlhacker.vscode-themes` extension. They are not managed
by Stow.

### Per-machine overrides

Create `~/.config/bash/local` for machine-specific settings (gitignored).

### DMS light/dark sync (niri + GTK + Ghostty)

The `niri` package ships `dms-theme-sync.service`. It is enabled through
`niri.service.wants` (a local `systemctl --user enable` symlink, not stowed),
and keeps the rest of the session in step with DMS's location/sunset mode:

- writes `org.gnome.desktop.interface color-scheme` as `prefer-dark` or
  `prefer-light`. DMS writes `default` when going back to light, which makes
  the XDG portal report "no preference" and Electron apps (Discord) stop
  following the system.
- updates `gtk-application-prefer-dark-theme` in
  `~/.config/gtk-{3,4}.0/settings.ini` and keeps `gtk.css` importing only
  DMS's `dank-colors.css`. GTK3 has no `color-scheme` support, and Plasma's
  `colors.css` otherwise pins the Breeze palette to the last Plasma session.
- sends `SIGUSR2` to running Ghostty instances when DMS regenerates
  `~/.config/ghostty/themes/dankcolors` (Ghostty does not watch theme files).

After stowing on a new machine:

```bash
systemctl --user daemon-reload
systemctl --user enable dms-theme-sync.service
```

DMS must also have `terminalsAlwaysDark=false` for the generated terminal
palettes (Ghostty, kitty, …) to follow light mode.

The DMS-generated theme outputs (`ghostty/.../dankcolors`,
`kitty/.../dank-*.conf`, `wezterm` colors, `zed` theme, `zen.css`) are
gitignored and stow-ignored. On machines installed before `install.pl`
switched to `stow --no-folding`, `~/.config/{ghostty,kitty,wezterm,zed}` may
still be folded symlinks into the repo, so DMS writes those files inside the
repo tree (ignored by git). To have DMS write to real home config dirs
instead, remove the folded symlink and re-stow the package:

```bash
rm ~/.config/ghostty        # removes only the directory symlink
./install.pl --package ghostty
```

Repeat for `kitty`, `wezterm`, and `zed` as needed.

### Brave flags

`/usr/bin/brave` only ever reads `~/.config/brave-flags.conf`, so a
`.local/bin/brave` shim shadows it and layers the files in
`~/.config/brave-flags.d/`:

1. `default.conf` — session/host-agnostic defaults (always applied).
2. `<hostname>.conf` — used when present, otherwise:
3. `default-<session>.conf` — `default-wayland.conf` or `default-x11.conf`.

`~/.config/brave-flags.conf` keeps the common flags that `/usr/bin/brave`
applies itself (e.g. `--password-store`). Chromium honours only one
`--enable-features` value, so keep it to a single comma-separated line per file.

On `destro`, `brave-flags.d/destro.conf` pins the GL ANGLE backend (Vulkan
ANGLE crashes the GPU process on this machine) and enables VA-API
decode/encode on the RX 6700 XT, while keeping the headless RTX 3060 out of the
VA-API path.

### Keyboard remap (Caps Lock → Ctrl, Right Alt → Super)

The `kde` package ships a Plasma/XKB keyboard remap:

- **Caps Lock** acts as an additional Left Ctrl, with no Caps Lock toggling
  (`caps:ctrl_modifier`, a stock xkeyboard-config option).
- **Right Alt** acts as an additional Left Super (`Super_L`), via the local
  option `custom:ralt_super`.
- Every other key is unchanged.

Three pieces make this work, all under `kde/.config/`:

- `kxkbrc` sets `Options=caps:ctrl_modifier,custom:ralt_super` and
  `ResetOldOptions=true` (KWin ignores `Options` without it).
- `xkb/symbols/custom` defines `ralt_super`, which maps `<RALT>` to `Super_L`.
- `xkb/rules/evdev` is a per-user overlay of the system rules. It includes
  `evdev-system`, a symlink to `/usr/share/X11/xkb/rules/evdev`, so
  xkeyboard-config updates still flow through.

KWin reads `kxkbrc` at startup, so **log out and back in** after changing it.
`custom:ralt_super` is not part of xkeyboard-config's option list, so saving
the Keyboard page in System Settings may drop it; re-add it to `Options=` in
`kxkbrc` if that happens.

### Plasma tmux scratchpad (SUPER+F9)

`plasma` packages a KWin script that binds **SUPER+F9** to a niri-style
floating tmux scratchpad, mirroring niri's `Mod+F9` "OpenCode" binding. KWin
cannot spawn processes, so the shortcut starts `plasma-toggle-tmux@.service`,
which runs the `plasma-toggle-tmux` Perl helper (in the `scripts` package) to
do the actual toggle. After stowing, run this once:

```bash
plasma-toggle-tmux --install
```

`--install` enables the KWin script, writes a systemd drop-in pinning the
`PATH` of the perl that ran it (so `Net::DBus` is found even with a perlbrew
perl), installs a session autostart entry that reloads the script (in case KWin
came up before the script was enabled), and daemon-reloads systemd. It also
pins a single **Scratchpads** button
(`tmux-scratchpad.desktop`) to every Icons-only Task Manager. All
scratchpads run kitty with the same `--class tmux-scratchpad`, so their windows
pool under that one button: Plasma shows the window count and scrolling over
it cycles through them. Right-click the button for the per-session toggle
actions (opencode, kilo, work, btop); clicking it with nothing open starts the
`opencode` scratchpad. It uses kitty's stock `Icon=kitty`, while the custom
`kitty.desktop` keeps its ember icon, so manual kitty sessions and scratchpads
are easy to tell apart. The script's `metadata.json` declares
`"X-Plasma-API": "javascript"`, so KWin loads it natively at login **and after
a compositor restart**; without that key KWin silently ignores the script and
the shortcut only works while it has been loaded by hand. **SUPER+F9** then
spawns a
centered, always-on-top Konsole running the `opencode` tmux session,
**SUPER+SHIFT+F9** does the same for `kilo`, and
**SUPER+\\** (backslash) does the same for the `work` session in Konsole, and
**SUPER+F11** for the system monitor in kitty (uses `dgop` if present, else
`htop` → `btop` → `top`); pressing
a binding again while its window is focused closes the window (the tmux session
survives). The window defaults to 90% width × 85% height of the active screen
(`--width`/`--height`), and window class matching handles both Wayland app-ids
(`org.kde.konsole`) and X11 WM_CLASS (`konsole`). Scratchpads get normal window
decorations (titlebar and resize border) even though kitty's global config sets
`hide_window_decorations yes`; pass `--no-border` to keep them frameless. Add
more scratchpads by appending to `sessions` in
`plasma/.local/share/kwin/scripts/plasma-toggle-tmux/contents/code/main.js`.

> **Do not enable** the `plasma-toggle-tmux@*.service` units. They have no
> `[Install]` section on purpose: they are one-shot toggle actions started on
> demand by the KWin shortcut. Enabling them runs a toggle at every login and
> fails, because no scratchpad window exists yet.

#### Dependencies (CachyOS/Arch)

Everything the helper uses at runtime, mapped to the package that provides it.
On a normal Plasma install these are already present except `Net::DBus`.

| Dependency        | Package         | Notes                                                          |
|-------------------|-----------------|----------------------------------------------------------------|
| `Net::DBus` (Perl)| `perl-net-dbus` | Or `cpan -T -i Net::DBus` into a local perlbrew/local::lib perl. |
| `qdbus6`          | `qt6-tools`     | KWin scripting and KGlobalAccel D-Bus calls.                   |
| `kwriteconfig6`   | `kconfig`       | Writes `kwinrc`/`kglobalshortcutsrc` and configures systemd.   |
| `busctl`, `systemctl` | `systemd`   | Session probe (`--load`) and the scratchpad unit.              |
| KWin              | `kwin`          | Provides the `org.kde.KWin` scripting API (Wayland and X11).   |
| `konsole`, `kitty`, `tmux` | `konsole`, `kitty`, `tmux` | Terminals + the tmux sessions the scratchpads run. |

If you build `Net::DBus` from CPAN instead of using the distro package, the
build-only dependencies are `dbus` (libdbus headers), `pkgconf`, and a compiler
(`base-devel`). All Perl modules other than `Net::DBus` are core.

```bash
# distro-package route (makes system perl usable):
sudo pacman -S --needed qt6-tools kconfig systemd konsole kitty tmux perl-net-dbus
```



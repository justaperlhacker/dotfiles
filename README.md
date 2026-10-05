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
Conflicts are moved to `~/.dotfiles/.backup/<timestamp>/` (gitignored).

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
| `i3`              | `.config/i3/`, `.xprofile`                                |
| `kanata`          | `.config/kanata/`, `.config/systemd/user/kanata.service`  |
| `kitty`           | `.config/kitty/`                                          |
| `kilo`            | `.config/kilo/`                                           |
| `LazyVim`         | `.config/LazyVim/`                                        |
| `nano`            | `.config/nano/`                                           |
| `neovide`         | `.config/neovide/`                                        |
| `niri`            | `.config/niri/`, `.config/xdg-desktop-portal/`            |
| `NvChad`          | `.config/NvChad/`                                         |
| `nvim`            | `.config/nvim/`                                           |
| `perl`            | `.perltidyrc`                                             |
| `pi`              | `.pi/agent/settings.json`, `.pi/agent/auth.json`, `.pi/agent/models-store.json` |
| `plasma`          | `.local/share/kwin/scripts/`, `.config/systemd/user/plasma-toggle-tmux@.service` |
| `redshift`        | `.config/redshift/`                                       |
| `scripts`         | `.local/bin/`                                             |
| `starship`        | `.config/starship.toml`                                   |
| `tmux`            | `.config/tmux/`                                           |
| `xresources`      | `.Xresources`, `.Xresources.d/`                           |

### Per-machine overrides

Create `~/.config/bash/local` for machine-specific settings (gitignored).

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

### Plasma tmux scratchpad (SUPER+F9)

`plasma` packages a KWin script that binds **SUPER+F9** to a niri-style
floating tmux scratchpad, mirroring niri's `Mod+F9` "OpenCode" binding. KWin
cannot spawn processes, so the shortcut starts `plasma-toggle-tmux@.service`,
which runs the `plasma-toggle-tmux` Perl helper (in the `scripts` package) to
do the actual toggle. After stowing, run this once:

```bash
plasma-toggle-tmux --install
```

`--install` enables and loads the KWin script, writes a systemd drop-in so the
unit uses the perlbrewed perl that has `Net::DBus`, installs a session
autostart entry that reloads the script each login (KWin does not reliably
auto-load user scripts), and daemon-reloads systemd. **SUPER+F9** then spawns a
centered, always-on-top Konsole running the `opencode` tmux session, and
**SUPER+\\** (backslash) does the same for the `work` session in Konsole, and
**SUPER+F11** for the system monitor in kitty (uses `dgop` if present, else
`htop` → `btop` → `top`); pressing
a binding again while its window is focused closes the window (the tmux session
survives). The window defaults to 90% width × 85% height of the active screen
(`--width`/`--height`), and window class matching handles both Wayland app-ids
(`org.kde.konsole`) and X11 WM_CLASS (`konsole`). Add more scratchpads by
appending to `sessions` in
`plasma/.local/share/kwin/scripts/plasma-toggle-tmux/contents/code/main.js`.

#### Dependencies (CachyOS/Arch)

Everything the helper uses at runtime, mapped to the package that provides it.
On a normal Plasma install these are already present except `Net::DBus`.

| Dependency        | Package         | Notes                                                          |
|-------------------|-----------------|----------------------------------------------------------------|
| `Net::DBus` (Perl)| `perl-net-dbus` | Or `cpan -T -i Net::DBus` into the perlbrew perl (what this box uses). |
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



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
| `brave`           | `.config/brave-flags.conf`                                 |
| `DankMaterialShell`| `.config/DankMaterialShell/`                              |
| `doom`            | `.config/doom/`                                           |
| `i3`              | `.config/i3/`, `.xprofile`                                |
| `kanata`          | `.config/kanata/`, `.config/systemd/user/kanata.service`  |
| `LazyVim`         | `.config/LazyVim/`                                        |
| `nano`            | `.config/nano/`                                           |
| `neovide`         | `.config/neovide/`                                        |
| `niri`            | `.config/niri/`, `.config/xdg-desktop-portal/`            |
| `NvChad`          | `.config/NvChad/`                                         |
| `nvim`            | `.config/nvim/`                                           |
| `perl`            | `.perltidyrc`                                             |
| `redshift`        | `.config/redshift/`                                       |
| `starship`        | `.config/starship.toml`                                   |
| `tmux`            | `.config/tmux/`                                           |
| `xresources`      | `.Xresources`, `.Xresources.d/`                           |

### Per-machine overrides

Create `~/.config/bash/local` for machine-specific settings (gitignored).

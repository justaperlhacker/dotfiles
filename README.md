# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

Clone to `~/.dotfiles`:

```bash
git clone git@github-justaperlhacker:justaperlhacker/dotfiles.git ~/.dotfiles
```

## Usage

Stow creates symlinks from your home directory into the appropriate package directory.

```bash
cd ~/.dotfiles
stow <package>
```

### Packages

| Package     | What it links                                          |
|-------------|--------------------------------------------------------|
| `bash`      | `.bashrc`, `.bash_profile`, `.inputrc`, `.config/bash/` |
| `starship`  | `.config/starship.toml`                                |
| `tmux`      | `.config/tmux/`                                        |
| `xresources`| `.Xresources`, `.Xresources.d/`                        |

To install everything at once:

```bash
stow bash starship tmux xresources
```

To remove symlinks:

```bash
stow -D bash
```

### Per-machine overrides

Create `~/.config/bash/local` for machine-specific settings (gitignored).

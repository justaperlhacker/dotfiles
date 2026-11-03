# ghostty stow package

Links `~/.config/ghostty/` — the config, the `dankcolors` theme, and a
cursor-trail shader pack.

The cursor trail shaders are copied from
[hackr-sh/ghostty-shaders](https://github.com/hackr-sh/ghostty-shaders)
(repo has no license file; upstream attribution kept in the shaders' header
comments):

- `cursor_blaze.glsl` — Neovide-style animated trail (default in `config`)
- `smear_cursor_blocks.glsl` — block-smear alternative (swap the
  `custom-shader` line in `config` to use)

Ghostty >= 1.2 is required for the trail (cursor uniforms for custom
shaders). Shader edits reload live, no restart needed.

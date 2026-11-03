# ghostty stow package

Links `~/.config/ghostty/` — the config, the `dankcolors` theme, and a
cursor-trail shader pack.

The cursor trail shaders are copied from
[hackr-sh/ghostty-shaders](https://github.com/hackr-sh/ghostty-shaders)
(repo has no license file; upstream attribution kept in the shaders' header
comments):

- `cursor_blaze.glsl` — fire-style trail (from hackr-sh, no license file)
- `cursor_warp.glsl` — smooth eased cursor smear, from
  [sahaj-b/ghostty-cursor-shaders](https://github.com/sahaj-b/ghostty-cursor-shaders)
  (MIT; the upstream repo also has cursor_sweep, cursor_tail, ripple_cursor
  and sonic_boom variants)
- `smear_cursor_blocks.glsl` — blocky smear (from hackr-sh)

Ghostty >= 1.2 is required for the trail (cursor uniforms for custom
shaders). Shader edits reload live, no restart needed.

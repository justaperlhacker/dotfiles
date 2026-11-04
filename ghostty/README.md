# ghostty stow package

Links `~/.config/ghostty/` — the config and the color-scheme themes
(`TokyoNight Terminal Dark` from the Gogh collection, `dankcolors` as an
alternative).

`shaders/cursor_smear_fade-kittymatch.glsl` is the active cursor-trail
shader, patched to mirror the kitty `cursor_trail` setup that was the
original goal (all-moves trail, ~0.3s decay, trail color = cursor color).
Upstream source + the exact patch is documented in the shader's header.
Structural gap vs kitty that can't be tuned away: the trail draws over
text instead of under it — that's the ghostty shader surface, not a config
choice. Revisit if Ghostty ships a first-party cursor-trail feature or Kwi
implements one.

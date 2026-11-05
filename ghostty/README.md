# ghostty stow package

Links `~/.config/ghostty/` — the config and the color-scheme themes
(`TokyoNight Terminal Dark` from the Gogh collection, `dankcolors` as an
alternative).

## Themes

`themes/Ghost Terminal` is a dark theme built from cool-retro-term's
"Ghost Terminal" preset: background `#0b1014`, foreground `#a6b3c0`, and
the cool-retro-term ANSI palette. It also disables cursor blinking, like
the preset.

```ini
# theme = Ghost Terminal   # dark-only
```

The theme sets `cursor-color = #a6b3c0` and `cursor-text = #0b1014`, so the
cursor stays visible on the dark background. For a white/light background,
use a dark `cursor-color` in the theme or config.

`themes/Ghost Terminal Light` is the light counterpart: background
`#a6b3c0`, foreground `#0b1014`, cursor `#4c505e` (dark gray), with a
darkened palette for contrast. To follow the system light/dark setting:

```ini
# theme = dark:Ghost Terminal,light:Ghost Terminal Light
```

## Cursor shaders

`shaders/cursor_hybrid-konsole-kitty.glsl` is the main hybrid cursor
shader and the default alternative. The active shader is currently
`cursor_ghost-crt.glsl` (see below). The hybrid combines the two
source-accurate shaders:

- **Konsole for small moves** — a 200 ms OutCubic shear/taper morph from
  the old cursor rect. This is what makes typing and key repeat feel
  smooth.
- **kitty for large jumps** — the per-corner exponential trail from
  `kitty/cursor_trail.c`, which produces the long directional smear.

The blend is based on movement distance in cursor cells:

- `<= 1.5` cells: pure Konsole
- `>= 3.5` cells: pure kitty
- in between: blended corner geometry

Both sides are tunable at the top of the shader (`HYBRID_SMALL_CELLS`,
`HYBRID_LARGE_CELLS`, the Konsole trail extension, and the kitty decay
values). It supports `block`, `bar`, and `underline`; the style is
auto-detected from Ghostty.

Active config:

```ini
cursor-style = block
custom-shader = shaders/cursor_ghost-crt.glsl
custom-shader = shaders/crt_noise.glsl
custom-shader = shaders/crt_scanlines.glsl
```

## Alternatives

`shaders/cursor_morph-konsole.glsl` is the pure Konsole shader. It
mirrors the profile option "Animation: Make the cursor animate smoothly":
a 200 ms OutCubic morph with the old quad sheared/tapered from the
movement delta. It supports block, bar, and underline:

- `block` — Konsole block morph plus a Ghostty-only trailing extension
  (`KONSOLE_BLOCK_TRAIL_EXTEND`). Set it to `0.0` for the exact Konsole
  morph.
- `bar` — Konsole I-beam animation: the previous full cell morphs into
  the thin bar. This is the streak from Konsole's default `CursorShape=1`
  profile.
- `underline` — same, with the underline strip as the target.

For bar/underline, Ghostty only exposes the shape rect, so the shader
reconstructs the previous cell using `KONSOLE_CELL_ASPECT` (default 0.6,
tuned for JetBrains Mono).

```ini
# cursor-style = bar
# custom-shader = shaders/cursor_morph-konsole.glsl
```

`shaders/cursor_trail-kitty.glsl` is the pure kitty shader. It follows
`kitty/cursor_trail.c`: each cursor corner eases exponentially toward its
target, with the per-corner decay interpolated from 0.2 s (leading) to
0.6 s (trailing) — the values from the `kitty.conf` in this repo. It also
implements kitty's 1-cell start threshold, the half-cell "needs render"
cutoff, and the `kitty/shaders/trail.slang` current-cursor mask.

```ini
# cursor-style = block
# custom-shader = shaders/cursor_trail-kitty.glsl
```

`shaders/cursor_ghost-crt.glsl` emulates the Cool-Retro-Term Ghost
Terminal cursor: a fading previous-cursor ghost plus a banded phosphor
trail along long jumps. It is cursor-only, since Ghostty has no
full-screen burn-in buffer. For small forward moves (right/down) it draws
`GHOST_EXTRA_COUNT` extra ghosts behind the previous cursor, spaced by
`GHOST_EXTRA_SPACING` and fading with `GHOST_EXTRA_FALLOFF`. Large jumps,
backspace, and left/up moves only get the trail along the actual path, so
they never grow ghosts on the side the cursor didn't travel from. Extra
ghosts are also skipped over empty cells, which keeps the first prompt
from growing ghosts before any text has been typed. On long jumps the
trail fades from the old position (dim) toward the new cursor (bright),
and the old cursor ghost is dimmed with distance. `GHOST_DURATION` is
0.525 s (25% faster than 0.7), and `GHOST_BAND_AMOUNT` (0.35) softens the banding so it reads as
a streak instead of flickering lines. Tune those, `GHOST_SPACING_CELLS`,
and the `GHOST_*_ALPHA` values at the top of the shader. On light
backgrounds it boosts opacity and darkens the ghost color via
`GHOST_LIGHT_BOOST`, `GHOST_LIGHT_POWER`, and `GHOST_LIGHT_DARKEN`.

```ini
# custom-shader = shaders/cursor_ghost-crt.glsl
```

`shaders/crt_noise.glsl` adds the Cool-Retro-Term `staticNoise` effect:
a tiled scrolling grain applied as a background/foreground tint, plus a
small static grain. It stacks after the cursor shader. The scroll restarts
cleanly when the surface regains focus (`iTimeFocus`), so returning to the
window doesn't leave stale lines or squares. Tune `NOISE_STRENGTH`
(default 0.02; raise for stronger grain), `NOISE_SCALE`, `NOISE_PERIOD`,
`NOISE_TIME_A/B`, and `NOISE_VIGNETTE`. The grain uses a fixed pixel
scale, so window resizing doesn't change its density. Comment out its
`custom-shader` line to disable it.

`shaders/crt_scanlines.glsl` adds a single horizontal sliding scanline —
no static raster lines. Tune `SCANLINE_STRENGTH` (default 0.004),
`SCANLINE_SWEEP_TIME` (6.7 s per pass), `SCANLINE_INTERVAL` (9 s total,
including the pause), and `SCANLINE_WIDTH` (default 12 px). Comment out its
`custom-shader` line to disable it.

`shaders/cursor_smear_fade-kittymatch.glsl` is the older kitty-inspired
approximation (fixed ~0.3 s hexagon trail with a distance fade). It is
kept for comparison. All cursor shaders here draw over text and mask the
current cursor rect.

## Limitations

Custom shaders are stateless. Ghostty exposes only the previous and
current cursor rects, not kitty's persistent in-flight corner state or its
8-move history. A single cursor jump matches the source animations
closely; rapid successive moves restart from the previous cursor rect.
Kitty's `cursor_trail` millisecond trigger delay is also not exposed by
Ghostty.

The cursor uniforms are only updated while the cursor glyph is rendered,
so a move made during the cursor's blink-off phase can miss the animation.
Normal typing/output resets the blink timer, so this is mostly visible on
arrow-key moves that land in an off phase.

## Other

The config disables the terminal bell with
`bell-features = no-system,no-audio,no-attention,no-title,no-border`.

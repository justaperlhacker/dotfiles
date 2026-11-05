# ghostty stow package

Links `~/.config/ghostty/` — the config and the color-scheme themes
(`TokyoNight Terminal Dark` from the Gogh collection, `dankcolors` as an
alternative).

## Cursor shaders

`shaders/cursor_hybrid-konsole-kitty.glsl` is the active cursor-animation
shader. It combines the two source-accurate shaders:

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
cursor-style = bar
custom-shader = shaders/cursor_hybrid-konsole-kitty.glsl
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

`shaders/cursor_ghost-crt.glsl` emulates the Cool-Retro-Term "Ghost
Terminal" cursor persistence. It keeps the previous cursor as a fading
ghost while typing and repeats copies along the path of a long jump, with
a soft phosphor glow. Cool-Retro-Term gets this from its full-screen
`burn_in.frag` feedback buffer; Ghostty has no previous-frame buffer, so
this is a cursor-only approximation using the previous/current cursor and
the movement path.

Tunables at the top of the shader: `GHOST_DURATION` (default 0.45 s,
matching the Ghost Terminal preset's `burnIn` 0.2), `GHOST_COUNT`,
`GHOST_SPACING_CELLS`, `GHOST_*_ALPHA`, and `GHOST_GLOW`.

```ini
# custom-shader = shaders/cursor_ghost-crt.glsl
```

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

The ghost shader can't reproduce Cool-Retro-Term's full-screen burn-in
feedback buffer. It only draws cursor ghosts from the previous/current
cursor and the movement path, so the text itself does not leave
phosphor trails.

The cursor uniforms are only updated while the cursor glyph is rendered,
so a move made during the cursor's blink-off phase can miss the animation.
Normal typing/output resets the blink timer, so this is mostly visible on
arrow-key moves that land in an off phase.

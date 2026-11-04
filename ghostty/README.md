# ghostty stow package

Links `~/.config/ghostty/` — the config and the color-scheme themes
(`TokyoNight Terminal Dark` from the Gogh collection, `dankcolors` as an
alternative).

No cursor-trail shaders: Ghostty's cursor animation surface is user GLSL
custom shaders, and none of the community smear/trail shaders (hackr-sh,
sahaj-b, KroneCorylus) come close to a first-party cursor-trail feature
(kitty `cursor_trail`) or editor-layer smear (smear-cursor.nvim) — cell-
quantized, no phosphor accumulation. If Ghostty or Kwi ships a native
cursor animation option, that's the moment to revisit.

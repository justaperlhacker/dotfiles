-- Input devices (mirrors niri: click-to-focus, flat accel, natural scroll).

hl.config({
  input = {
    kb_layout = "us",
    numlock_by_default = true,
    follow_mouse = 0,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      disable_while_typing = true,
    },
  },
})

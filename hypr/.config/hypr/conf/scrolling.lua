-- Native scrolling layout tuned to match niri's sliding tiling.

hl.config({
  general = {
    layout = "scrolling",
  },
  scrolling = {
    column_width = 0.5,
    explicit_column_widths = "0.333,0.5,0.667",
    follow_focus = true,
    focus_fit_method = 1,
    fullscreen_on_one_column = false,
    direction = "right",
    wrap_focus = true,
    wrap_swapcol = true,
  },
})

local wezterm = require("wezterm") ---@type Wezterm
local config = wezterm.config_builder() ---@type Config

-------------------------------------------------------
-- General
-------------------------------------------------------
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 0,
  fade_out_duration_ms = 0,
}
config.window_close_confirmation = "NeverPrompt"

-- Start maximized
wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)


-------------------------------------------------------
-- Appearance
-------------------------------------------------------
-- Fallback scheme; scheme.lua overrides this per OS dark/light mode.
config.color_scheme = "tokyonight_night"
config.window_background_opacity = 0.95
config.window_decorations = 'TITLE|RESIZE'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_frame = {
  --inactive_titlebar_bg = "none",
  --active_titlebar_bg = "none",
  inactive_titlebar_bg = "#333333",
  active_titlebar_bg = "#333333",
}

-------------------------------------------------------
-- Theme (see scheme.lua): appearance-aware dark/light
-- scheme management; add the fuzzy picker key.
-------------------------------------------------------
local scheme = require("scheme")
scheme.apply(config)

-------------------------------------------------------
-- font
-------------------------------------------------------
config.font = wezterm.font_with_fallback({
  "HE_TERMINAL Nerd Font",
  "JetBrainsMono Nerd Font",
}, { weight = "Medium" })
config.font_size = 12
--config.line_height = 1.0
config.bold_brightens_ansi_colors = "BrightOnly"

-- cursor
config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
}
config.default_cursor_style = "SteadyBlock"

-------------------------------------------------------
-- tab
-------------------------------------------------------
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = true
config.show_close_tab_button_in_tabs = true
config.tab_max_width = 48

-------------------------------------------------------
-- keys (see keybinds.lua)
-------------------------------------------------------
require("keybinds").apply(config)

return config
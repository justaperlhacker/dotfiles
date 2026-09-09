local wezterm = require("wezterm") ---@type Wezterm
local config = wezterm.config_builder() ---@type Config

-- General

config.font_size = 12
--config.line_height = 1.2
config.font = wezterm.font("HE_TERMINAL Nerd Font")
--config.color_scheme = "base16-gruvbox-dark-hard"
config.color_scheme = "tokyonight_night"

config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
}
config.default_cursor_style ="SteadyBlock"

config.window_decorations = 'TITLE|RESIZE'
config.window_padding = {
  left = 4,
  right = 0,
  top = 0,
  bottom = 0,
}
config.use_fancy_tab_bar = true
config.show_close_tab_button_in_tabs = true
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 0,
  fade_out_duration_ms = 0,
}
config.bold_brightens_ansi_colors = "BrightOnly"


-- Theme picker: Ctrl+Shift+E opens a fuzzy list of the 1000+ built-in
-- schemes. The choice is saved to scheme.txt and applied; the saved
-- scheme is re-applied on startup, so picks persist across restarts.
-- (A state file is safer than rewriting this config.)
local scheme_file = wezterm.config_dir .. "/scheme.txt"
local builtin_schemes = wezterm.color.get_builtin_schemes()

local function read_saved_scheme()
  local f = io.open(scheme_file, "r")
  if not f then
    return nil
  end
  local name = f:read("*l")
  f:close()
  if name and builtin_schemes[name] then
    return name
  end
  return nil
end

local saved_scheme = read_saved_scheme()
if saved_scheme then
  config.color_scheme = saved_scheme
end

local schemes = {}
for name in pairs(builtin_schemes) do
  table.insert(schemes, { id = name, label = name })
end
table.sort(schemes, function(a, b)
  return a.id < b.id
end)

config.keys = {
  -- New tab (GNOME Terminal muscle memory; not a WezTerm default on Linux)
  {
    key = "T",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "E",
    mods = "CTRL|SHIFT",
    action = wezterm.action.InputSelector({
      title = "Color schemes",
      choices = schemes,
      fuzzy = true,
      action = wezterm.action_callback(function(window, pane, id, label)
        if not id then
          return
        end
        local f = io.open(scheme_file, "w")
        if f then
          f:write(id .. "\n")
          f:close()
        end
        window:set_config_overrides({ color_scheme = id })
      end),
    }),
  },
}

-- Kitty-style tab selection: Ctrl+1..9 selects tabs 1-9, Ctrl+0 selects tab 10.
-- (Overrides the default Ctrl+0 reset-font-size; Ctrl+Shift+0 still does that.)
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "CTRL",
    action = wezterm.action.ActivateTab(i - 1),
  })
end
table.insert(config.keys, {
  key = "0",
  mods = "CTRL",
  action = wezterm.action.ActivateTab(9),
})

-- Start maximized
wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
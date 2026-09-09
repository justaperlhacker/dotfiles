-- keybinds.lua - keybindings for wezterm.lua.
--
--   local keybinds = require("keybinds")
--   keybinds.apply(config)

local wezterm = require("wezterm")
local scheme = require("scheme")

local M = {}

function M.apply(config)
  config.keys = {
    -- New tab (GNOME Terminal muscle memory; not a WezTerm default on Linux)
    {
      key = "T",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    -- Appearance-aware scheme picker (see scheme.lua), tagged [dark]/[light]
    {
      key = "E",
      mods = "CTRL|SHIFT",
      action = wezterm.action.InputSelector({
        title = "Color schemes",
        choices = scheme.picker_choices(),
        fuzzy = true,
        action = wezterm.action_callback(scheme.on_pick),
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
end

return M
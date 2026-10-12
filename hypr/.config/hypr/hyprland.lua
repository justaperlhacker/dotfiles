-- Hyprland configuration (Lua).
-- Modules live in conf/ and load in order.
-- Per-host overrides (untracked, optional): ~/.config/hypr/local.lua

require("conf.env")
require("conf.monitors")
require("conf.input")
require("conf.appearance")
require("conf.scrolling")
require("conf.workspaces")
require("conf.windows")
require("conf.keybinds")
require("conf.autostart")

pcall(require, "local")

-- scheme.lua - appearance-aware scheme management for WezTerm.
--
-- Detects the OS dark/light mode and applies one of two schemes kept in
-- scheme.txt (a state file, so it survives rewrites of this config):
--
--   # comments and blank lines are kept when the file is rewritten
--   dark=Some Dark Scheme
--   light=Some Light Scheme
--
-- Usage from wezterm.lua:
--   local scheme = require("scheme")
--   scheme.apply(config)              -- set color_scheme + register handlers
--   scheme.picker_choices()           -- {id,label}[] for the fuzzy picker
--   scheme.on_pick(window, pane, id)  -- save a pick and apply it
--
-- Picking a scheme in the fuzzy picker (Ctrl+Shift+E) stores it under the
-- slot matching its background lightness. The slot matching the current OS
-- appearance is applied on startup and re-applied when the OS theme changes
-- (WezTerm reloads the config via the XDG Desktop Portal on GNOME; on Wayland
-- we also poll through update-right-status).

local wezterm = require("wezterm")

local M = {}

local scheme_file = wezterm.config_dir .. "/scheme.txt"
local builtin_schemes = wezterm.color.get_builtin_schemes()

-- Classify a scheme as dark or light from the lightness of its background
-- (the same heuristic the WezTerm docs use in their own examples).
local function scheme_mode(name)
  local scheme = builtin_schemes[name]
  if not scheme then
    return nil
  end
  local ok, bg = pcall(wezterm.color.parse, scheme.background)
  if not ok then
    return nil
  end
  local _, _, l = bg:hsla()
  return l < 0.5 and "dark" or "light"
end

-- OS appearance: "Dark", "Light", "DarkHighContrast", ...
-- wezterm.gui is nil when the config is evaluated by the mux server.
local function os_mode()
  local appearance = "Dark"
  if wezterm.gui then
    appearance = wezterm.gui.get_appearance()
  end
  return appearance:find("Dark") and "dark" or "light"
end

local scheme_state = {}

local function load_scheme_state()
  local f = io.open(scheme_file, "r")
  if f then
    for line in f:lines() do
      local key, value = line:match("^%s*(%w+)%s*=%s*(.-)%s*$")
      if (key == "dark" or key == "light") and builtin_schemes[value] then
        scheme_state[key] = value
      elseif not line:match("^%s*#") then
        -- Legacy single-name format: migrate the bare scheme name.
        local name = line:match("^%s*(.-)%s*$")
        local m = scheme_mode(name)
        if m and builtin_schemes[name] and not scheme_state[m] then
          scheme_state[m] = name
        end
      end
    end
    f:close()
  end
end

local function save_scheme_state()
  local lines = {}
  local f = io.open(scheme_file, "r")
  if f then
    for line in f:lines() do
      lines[#lines + 1] = line
    end
    f:close()
  end
  local out, found = {}, {}
  for _, line in ipairs(lines) do
    if line:match("^%s*dark%s*=") then
      if scheme_state.dark then
        out[#out + 1] = "dark=" .. scheme_state.dark
      end
      found.dark = true
    elseif line:match("^%s*light%s*=") then
      if scheme_state.light then
        out[#out + 1] = "light=" .. scheme_state.light
      end
      found.light = true
    else
      out[#out + 1] = line
    end
  end
  if (not found.dark) and scheme_state.dark then
    out[#out + 1] = "dark=" .. scheme_state.dark
  end
  if (not found.light) and scheme_state.light then
    out[#out + 1] = "light=" .. scheme_state.light
  end
  local w = io.open(scheme_file, "w")
  if w then
    w:write(table.concat(out, "\n"), "\n")
    w:close()
  end
end

load_scheme_state()

-- Apply the scheme matching the current OS appearance, then register the
-- handlers that swap schemes when the OS theme changes (and clear any stale
-- color_scheme override left by the picker). Config reloads call apply()
-- again with a fresh module state.
function M.apply(config)
  config.color_scheme = scheme_state[os_mode()] or config.color_scheme

  local function assert_for_mode(window, mode)
    local overrides = window:get_config_overrides() or {}
    local scheme = scheme_state[mode] or config.color_scheme
    if overrides.color_scheme ~= scheme then
      overrides.color_scheme = scheme
      window:set_config_overrides(overrides)
    end
  end

  -- Re-assert the scheme after every reload (including appearance-driven
  -- ones). Only set when the value actually changes, or set_config_overrides
  -- would trigger another reload in an infinite loop.
  wezterm.on("window-config-reloaded", function(window)
    assert_for_mode(window, os_mode())
  end)

  -- Some Wayland compositors don't emit window-config-reloaded when the OS
  -- appearance changes, so poll it here as the WezTerm docs recommend for
  -- Wayland. Only acts when the mode actually flips; otherwise it's a no-op.
  local last_mode = os_mode()
  wezterm.on("update-right-status", function(window)
    local mode = os_mode()
    if mode ~= last_mode then
      last_mode = mode
      assert_for_mode(window, mode)
    end
  end)
end

-- Sorted list of every built-in scheme for the fuzzy picker, each tagged with
-- the slot it will land in: "Name  [dark]" / "Name  [light]".
function M.picker_choices()
  local choices = {}
  for name in pairs(builtin_schemes) do
    local m = scheme_mode(name)
    table.insert(choices, {
      id = name,
      label = m and (name .. "  [" .. m .. "]") or name,
    })
  end
  table.sort(choices, function(a, b)
    return a.id < b.id
  end)
  return choices
end

-- Callback for the picker: remember the pick in the slot matching its
-- background lightness and apply it to the window immediately.
function M.on_pick(window, pane, id)
  if not id then
    return
  end
  local m = scheme_mode(id)
  if m then
    scheme_state[m] = id
    save_scheme_state()
  end
  local overrides = window:get_config_overrides() or {}
  overrides.color_scheme = id
  window:set_config_overrides(overrides)
end

return M
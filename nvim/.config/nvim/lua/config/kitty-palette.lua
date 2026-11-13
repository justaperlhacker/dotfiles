-- Build a kitty ANSI palette map for recoloring kraihnight.
--
-- The kitty files are generated/updated outside Neovim (wallpaper-driven), so
-- nothing is cached: every theme switch re-reads the file for the requested
-- background.
--
-- Point M.files anywhere you like. `current-theme.conf` is the theme kitty is
-- actually using right now; the *-theme.auto.conf pair is what the desktop
-- shell maintains for dark/light mode.

local M = {}

local kitty = vim.fn.expand("~/.config/kitty")
M.files = {
  dark = kitty .. "/dark-theme.auto.conf",
  light = kitty .. "/light-theme.auto.conf",
}

local function parse(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local colors = {}
  for line in file:lines() do
    local key, value = line:match("^%s*([%w_]+)%s+([#%x]+)%s*$")
    if key and value then
      colors[key] = value:lower()
    end
  end
  file:close()

  if not colors.background or not colors.foreground then
    return nil
  end
  return colors
end

local function rgb(hex)
  local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
  if not r then
    return nil
  end
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

local function hex(color)
  return ("#%02x%02x%02x"):format(
    math.floor(color[1] + 0.5),
    math.floor(color[2] + 0.5),
    math.floor(color[3] + 0.5)
  )
end

-- Blend `a` towards `b`; t = 0 keeps a, t = 1 gives b.
local function mix(a, b, t)
  local ca, cb = rgb(a), rgb(b)
  if not ca or not cb then
    return a
  end
  return hex({
    ca[1] + (cb[1] - ca[1]) * t,
    ca[2] + (cb[2] - ca[2]) * t,
    ca[3] + (cb[3] - ca[3]) * t,
  })
end

local function luminance(color)
  local c = rgb(color)
  if not c then
    return 0
  end
  return (0.2126 * c[1] + 0.7152 * c[2] + 0.0722 * c[3]) / 255
end

--- Vague's semantic roles, filled from the kitty ANSI palette.
---@param background "dark"|"light"
---@return table<string,string>|nil palette for require("vague").setup()
function M.vague(background)
  local path = M.files[background == "light" and "light" or "dark"]
  local p = parse(path)
  if not p then
    return nil
  end

  local bg, fg = p.background, p.foreground
  local dark = luminance(bg) < 0.5

  local ansi = {}
  for i = 0, 15 do
    ansi[i] = p["color" .. i] or fg
  end

  local function surface(t)
    return mix(bg, fg, t)
  end

  return {
    bg = bg,
    fg = fg,
    inactiveBg = surface(dark and 0.06 or 0.05),
    line = surface(dark and 0.10 or 0.07),
    floatBorder = ansi[8],
    comment = ansi[8],
    builtin = ansi[6],
    func = ansi[4],
    string = ansi[2],
    number = ansi[3],
    property = ansi[7],
    constant = ansi[3],
    parameter = ansi[6],
    visual = p.selection_background or surface(0.15),
    error = ansi[1],
    warning = ansi[3],
    hint = ansi[6],
    operator = fg,
    keyword = ansi[5],
    type = ansi[6],
    search = p.selection_background or ansi[3],
    plus = ansi[2],
    delta = ansi[1],
  }
end

--- Map every hardcoded color in colors/kraihnight.lua onto the kitty palette.
--- Keys are lowercase, exactly as substituted by colors/kitty.lua.
---@param background "dark"|"light"
---@return table<string,string>|nil
function M.kraihnight(background)
  local path = M.files[background == "light" and "light" or "dark"]
  local p = parse(path)
  if not p then
    return nil
  end

  local bg, fg = p.background, p.foreground
  local dark = luminance(bg) < 0.5

  local ansi = {}
  for i = 0, 15 do
    ansi[i] = p["color" .. i] or fg
  end

  -- Surfaces and tints are not expressible in kitty, so derive them from the
  -- background/foreground/ANSI colors.
  local function surface(t)
    return mix(bg, fg, t)
  end

  local function tint(color, t)
    return mix(bg, color, t)
  end

  return {
    -- Backgrounds, borders, surfaces
    ["#1a1a1a"] = bg,                  -- Normal bg
    ["#1e1e1e"] = surface(0.03),       -- floats
    ["#232323"] = surface(0.06),       -- tabline / cursorline
    ["#303030"] = surface(0.12),       -- borders / splits
    ["#34383c"] = surface(0.16),       -- linenr / nontext
    ["#000000"] = bg,                  -- inverted popup fg
    ["#404040"] = p.selection_background or surface(0.20), -- Visual

    -- Foregrounds
    ["#f9f9f9"] = fg,
    ["#e6e6e6"] = fg,
    ["#ffffff"] = fg,
    ["#8a9597"] = ansi[8],             -- muted
    ["#726d73"] = mix(fg, bg, 0.5),    -- comments / POD

    -- Syntax
    ["#9fac7f"] = ansi[2],             -- string / number / boolean
    ["#d6b67f"] = ansi[3],             -- keyword / conditional / todo
    ["#899ab4"] = ansi[4],             -- identifier / preproc / include
    ["#ab8252"] = ansi[6],             -- function / title / tag / navic
    ["#d87d5f"] = ansi[5],             -- type / typedef
    ["#ac98ac"] = ansi[5],             -- special / regex / POD special
    ["#d08356"] = ansi[1],             -- constant / debug
    ["#b98a8a"] = ansi[1],             -- diagnostics error / spell bad
    ["#d08770"] = ansi[6],             -- html tags
    ["#dad085"] = ansi[4],             -- directory / neotree dir icons

    -- Inverted menu + cursor
    ["#9cbbde"] = ansi[4],             -- Pmenu bg
    ["#b0d0f0"] = p.cursor or fg,     -- Cursor bg

    -- Translucent-looking accents
    ["#a2a96f"] = tint(ansi[3], 0.35), -- MatchParen bg
    ["#5b5b2b"] = tint(ansi[3], 0.30), -- Search bg
    ["#602020"] = tint(ansi[1], 0.35), -- Error bg

    -- Diff backgrounds
    ["#2b251a"] = tint(ansi[3], 0.12), -- DiffChange
    ["#2b2020"] = tint(ansi[1], 0.12), -- DiffDelete
    ["#202b20"] = tint(ansi[2], 0.12), -- DiffAdd
    ["#20202b"] = tint(ansi[4], 0.12), -- DiffText
  }
end

---@param background "dark"|"light"
---@return string|nil the file the palette was read from
function M.source(background)
  local path = M.files[background == "light" and "light" or "dark"]
  return parse(path) and path or nil
end

--- The terminal's text selection pair.
---
--- Some kitty themes (including upstream Solarized Osaka Light) set
--- selection_background equal to the normal background, which makes a
--- selection invisible. Fall back to a visible tint in that case so Neovim
--- does not inherit the same problem.
---@param background "dark"|"light"
---@return { bg: string, fg: string }|nil
function M.selection(background)
  local path = M.files[background == "light" and "light" or "dark"]
  local p = parse(path)
  if not p then
    return nil
  end

  local bg, fg = p.background, p.foreground
  local dark = luminance(bg) < 0.5
  local selection_bg = p.selection_background
  local selection_fg = p.selection_foreground

  if not selection_bg or selection_bg == bg then
    selection_bg = mix(bg, fg, dark and 0.30 or 0.18)
  end
  if not selection_fg or selection_fg == fg then
    selection_fg = fg
  end

  return { bg = selection_bg, fg = selection_fg }
end

return M

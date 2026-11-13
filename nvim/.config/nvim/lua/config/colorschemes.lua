local colorscheme = {}

-- Earthy / warm / forest vibes
-- colorscheme.name = "everforest"
-- colorscheme.name = "gruvbox"
-- colorscheme.name = "gruvbox-material"
-- colorscheme.name = "gruber-darker"
-- colorscheme.name = "kimbox"
-- colorscheme.name = "miniwinter"
-- colorscheme.name = "miasma"
-- colorscheme.name = "darkearth"
-- colorscheme.name = "zenbones"
-- colorscheme.name = "zenburn"
-- colorscheme.name = "chocolatier"
-- colorscheme.name = "ayu"
-- colorscheme.name = "bamboo"
-- colorscheme.name = "vinyl"
-- colorscheme.name = "everblush" -- from uwu.vim repo

-- Monochrome / minimal / low-saturation
-- colorscheme.name = "vague"
-- colorscheme.name = "base16-black-metal-gorgoroth"
-- colorscheme.name = "black-metal-gorgoroth"
-- colorscheme.name = "monochrome"
-- colorscheme.name = "cosec-twilight"
-- colorscheme.name = "github-monochrome"
-- colorscheme.name = "naysayer"
-- colorscheme.name = "kanso"
-- coloescheme.name = "fleury"

-- Purple / moody / twilight vibes
-- colorscheme.name = "kanagawa"
-- colorscheme.name = "dracula"
-- colorscheme.name = "melange"
-- colorscheme.name = "doom-one"
-- colorscheme.name = "vampire"
-- colorscheme.name = "papercolor"

-- Cool / nordic / structured vibes
-- colorscheme.name = "adwaita" -- GNOME Adwaita
-- colorscheme.name = "nord"
-- colorscheme.name = "nordic"
-- colorscheme.name = "nightfox"
-- colorscheme.name = "tokyonight"
-- colorscheme.name = "onedark" -- Atom One Dark
-- colorscheme.name = "moonfly"
-- colorscheme.name = "nightfly"
-- colorscheme.name = "modus"
-- colorscheme.name = "modus-themes"
-- colorscheme.name = "bluloco"

-- Red / blood / crimson vibes
-- colorscheme.name = "vscode-red" -- local port of the VS Code built-in "Red" theme
-- colorscheme.name = "neofusion"
-- colorscheme.name = "alduin"
-- colorscheme.name = "sierra"
-- colorscheme.name = "srcery"

-- Warm / floral / twilight vibes
-- colorscheme.name = "rose-pine"
-- colorscheme.name = "toast"

-- GitHub (variants from projekt0n/github-nvim-theme)
-- colorscheme.name = "github_dark" -- lighter dark (#30363d)
-- colorscheme.name = "github_dark_default" -- GitHub Dark Default (#0d1117)
-- colorscheme.name = "github_dark_dimmed" -- dimmed dark (#22272e)
-- colorscheme.name = "github_light"
-- colorscheme.name = "github_light_default"

-- 10x Editor ports (all 41 stock schemes, colors/10x-*.lua)
-- colorscheme.name = "10x-sunset" -- 10x default
-- colorscheme.name = "10x-terracotta"
-- colorscheme.name = "10x-monokai"
-- colorscheme.name = "10x-gruvbox-dark"
-- colorscheme.name = "10x-solarized-dark"
-- colorscheme.name = "10x-icing"
-- colorscheme.name = "10x-vs-plus-vax"

-- Solarized (plugins in lua/plugins/colorscheme.lua)
-- colorscheme.dark = "solarized-osaka"
-- colorscheme.light = "solarized-osaka-light"
-- colorscheme.dark = "solarized-osaka-vivid"
-- colorscheme.dark = "solarized-high" -- high contrast, follows 'background'
-- colorscheme.light = "solarized-high"

-- Active theme, one per background. Neovim follows the local clock (dark
-- between sunset and sunrise; see lua/config/auto-background.lua). Both themes
-- must be installed; `fallback` is used if either fails to load.
--
-- "kitty" reuses vague.nvim's highlight groups, adds the Perl/POD/Raku groups
-- from kraihnight, and takes the palette from the matching kitty theme
-- (colors/kitty.lua + lua/config/kitty-palette.lua), so terminal and editor
-- match. It picks the palette by 'background', hence the same name both sides.
--colorscheme.dark = "kitty"
--colorscheme.light = "kitty"
-- colorscheme.dark = "vague"
-- colorscheme.dark = "sequoia-monochrome-dark"
-- colorscheme.light = "modus_operandi"
-- colorscheme.dark = "monochrome"
-- colorscheme.dark = "kanso"
-- colorscheme.dark = "vscode-red"
-- colorscheme.dark = "miniwinter"
-- colorscheme.dark = "kraihnight"
-- colorscheme.dark = "fleury"
--colorscheme.dark = "nord"
--colorscheme.dark = "onedark"
colorscheme.dark = "github_dark_default"
colorscheme.light = "github_light_default"

colorscheme.fallback = "default"

local auto = require("config.auto-background")
local applying = false

-- Post-colorscheme overrides: keep the theme's colors, add italic comments,
-- and strip bold from every highlight group.
local function strip_bold()
  for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
    local changed = false
    if hl.bold then
      hl.bold = nil
      changed = true
    end
    if hl.cterm and hl.cterm.bold then
      hl.cterm.bold = nil
      changed = true
    end
    if changed then
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

-- This leaves a nice underline
local cursorline_previous
local cursorline_underlined = false

local function toggle_underlined_cursorline()
  if cursorline_underlined then
    vim.api.nvim_set_hl(0, "CursorLine", cursorline_previous or {})
    cursorline_previous = nil
    cursorline_underlined = false
    return
  end

  cursorline_previous = vim.api.nvim_get_hl(0, { name = "CursorLine" })
  local hl = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })
  hl.underline = true
  vim.api.nvim_set_hl(0, "CursorLine", hl)
  cursorline_underlined = true
end

vim.keymap.set("n", "<S-F3>", toggle_underlined_cursorline, { desc = "Toggle underlined cursorline" })

local function apply_overrides()
  vim.cmd("highlight Comment gui=italic cterm=italic")
  vim.api.nvim_set_hl(0, "VertSplit", {})
  strip_bold()
end

local function apply()
  if applying then
    return
  end
  applying = true

  local background = vim.o.background == "light" and "light" or "dark"
  local name = background == "light" and colorscheme.light or colorscheme.dark

  if vim.o.background ~= background then
    auto.internal = true
    vim.o.background = background
    auto.internal = false
  end

  local ok, err = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.notify(("[colorschemes.lua] colorscheme '%s' failed: %s"):format(tostring(name), tostring(err)))
    pcall(vim.cmd.colorscheme, colorscheme.fallback)
  end

  apply_overrides()
  applying = false
end

local group = vim.api.nvim_create_augroup("ConfigColorscheme", { clear = true })

-- True while a colorscheme is being sourced. Themes may set 'background'
-- themselves; that must not be mistaken for a manual `:set background`.
local switching = false

vim.api.nvim_create_autocmd("ColorSchemePre", {
  group = group,
  callback = function()
    switching = true
    vim.schedule(function()
      switching = false
    end)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    -- By the time this fires, a colorscheme reload caused by a 'background'
    -- change is finished, so the OptionSet handler below can tell it apart
    -- from a theme that is still being sourced (and sets 'background' itself).
    switching = false
    apply_overrides()
    -- A theme picked by hand (e.g. through Telescope) that conflicts with the
    -- clock is a deliberate override: stop following until `:Theme auto`.
    if not applying and vim.o.background ~= auto.detect() then
      auto.lock()
    end
  end,
})

-- `nested` is required: applying a colorscheme triggers ColorSchemePre, which
-- lazy.nvim needs in order to load the plugin that ships the theme.
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "BackgroundChanged",
  nested = true,
  callback = apply,
})

-- Changing 'background' directly (e.g. unimpaired's `yob`) takes over from the
-- clock but still swaps in the matching colorscheme.
vim.api.nvim_create_autocmd("OptionSet", {
  group = group,
  pattern = "background",
  nested = true,
  callback = function()
    if applying or switching or auto.internal then
      return
    end
    auto.lock()
    apply()
    vim.notify(("[theme] %s background — :Theme auto to follow the clock"):format(vim.o.background))
  end,
})

local function clock_string()
  if auto.options.light_at and auto.options.dark_at then
    return ("light %s, dark %s (fixed times)"):format(auto.options.light_at, auto.options.dark_at)
  end

  local sunrise, sunset, polar = auto.sun_times()
  if sunrise and sunset then
    local function format(hours)
      local minutes = math.floor(hours * 60 + 0.5) % (24 * 60)
      return ("%02d:%02d"):format(math.floor(minutes / 60), minutes % 60)
    end
    return ("sunrise %s, sunset %s"):format(format(sunrise), format(sunset))
  end
  return polar == "day" and "sun never sets" or "sun never rises"
end

vim.api.nvim_create_user_command("Theme", function(opts)
  local arg = opts.args

  if arg == "auto" then
    auto.follow()
    vim.notify(("[theme] following the clock (%s background)"):format(vim.o.background))
  elseif arg == "status" then
    local mode = auto.is_following() and "following the clock" or "manual override"
    vim.notify(("[theme] %s / %s — %s, %s"):format(vim.o.background, tostring(vim.g.colors_name), mode, clock_string()))
  elseif arg == "toggle" then
    auto.lock()
    auto.set(vim.o.background == "light" and "dark" or "light")
  elseif arg == "dark" or arg == "light" then
    auto.lock()
    auto.set(arg)
  else
    vim.notify("Usage: :Theme [dark|light|toggle|auto|status]", vim.log.levels.WARN)
  end
end, {
  nargs = "?",
  desc = "Switch Neovim's dark/light theme",
  complete = function()
    return { "dark", "light", "toggle", "auto", "status" }
  end,
})

-- Pick the theme for the current time, start the clock, and apply it.
auto.start()
apply()
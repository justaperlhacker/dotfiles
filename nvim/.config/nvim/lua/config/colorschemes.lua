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
-- colorscheme.name = "nord"
-- colorscheme.name = "nordic"
-- colorscheme.name = "nightfox"
-- colorscheme.name = "tokyonight"
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

-- 10x Editor ports (all 41 stock schemes, colors/10x-*.lua)
-- colorscheme.name = "10x-sunset" -- 10x default
-- colorscheme.name = "10x-terracotta"
-- colorscheme.name = "10x-monokai"
-- colorscheme.name = "10x-gruvbox-dark"
-- colorscheme.name = "10x-solarized-dark"
-- colorscheme.name = "10x-icing"
-- colorscheme.name = "10x-vs-plus-vax"

-- Active theme
colorscheme.name = "vague"
-- colorscheme.name = "monochrome"
-- colorscheme.name = "kanso"
-- colorscheme.name = "vscode-red"
-- colorscheme.name = "miniwinter"
-- colorscheme.name = "kraihnight"
-- colorscheme.name = "fleury"

colorscheme.fallback = "default"
colorscheme.background = "dark"

vim.opt.background = colorscheme.background

local ok, err = pcall(vim.cmd.colorscheme, colorscheme.name)
if not ok then
  vim.notify("[colorschemes.lua] colorscheme '" .. tostring(colorscheme.name) .. "' failed: " .. tostring(err))
  vim.cmd.colorscheme(colorscheme.fallback)
end

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

apply_overrides()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("ConfigColorOverrides", { clear = true }),
  callback = apply_overrides,
})
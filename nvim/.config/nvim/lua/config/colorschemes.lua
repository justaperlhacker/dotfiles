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

-- Editor utilities / focus tools
-- colorscheme.name = "zen-mode"

-- Active theme
-- colorscheme.name = "vague"
-- colorscheme.name = "monochrome"
-- colorscheme.name = "kanso"
-- colorscheme.name = "vscode-red"
-- colorscheme.name = "miniwinter"
colorscheme.name = "kraihlight"

colorscheme.fallback = "default"
colorscheme.background = "dark"

vim.opt.background = colorscheme.background

local ok, err = pcall(vim.cmd.colorscheme, colorscheme.name)
if not ok then
  vim.notify("[colorschemes.lua] colorscheme '" .. tostring(colorscheme.name) .. "' failed: " .. tostring(err))
  vim.cmd.colorscheme(colorscheme.fallback)
end

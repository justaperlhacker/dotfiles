-- Colorscheme gallery for the `<leader>cs` Telescope picker.
--
-- The active theme is `kraihlight` (local, in colors/) and is applied by
-- lua/config/colorschemes.lua AFTER plugins load — so nothing here may
-- apply a theme at startup. Every remote theme below is deferred to
-- VeryLazy: zero blocking startup cost, but installed and ready by the
-- time you open the picker. No per-theme setup() calls: themes fall back
-- to their defaults on preview; add a config block back only for the
-- theme you promote to daily driver.
local Later = { event = "VeryLazy" }
local function T(spec)
  return vim.tbl_extend("force", { event = Later.event }, spec)
end

return {
  -- Minimal / monochrome
  T({ "vague-theme/vague.nvim", name = "vague" }),
  T({ "webhooked/kanso.nvim" }),
  T({ "metalelf0/black-metal-theme-neovim" }),
  T({ "idr4n/github-monochrome.nvim", name = "github-monochrome" }),
  T({ "kdheepak/monochrome.nvim", name = "monochrome" }),
  T({ "nvim-mini/mini.hues", name = "miniwinter", version = false }),
  T({ "CosecSecCot/cosec-twilight.nvim", name = "cosec-twilight", dependencies = { "rktjmp/lush.nvim" } }),

  -- Blue / cool-toned
  T({ "catppuccin/nvim", name = "catppuccin" }),
  T({ "folke/tokyonight.nvim", name = "tokyonight" }),
  T({ "uloco/bluloco.nvim", dependencies = { "rktjmp/lush.nvim" } }),
  T({ "EdenEast/nightfox.nvim", name = "nightfox" }),
  T({ "bluz71/vim-moonfly-colors", name = "moonfly" }),
  T({ "bluz71/vim-nightfly-guicolors", name = "nightfly" }),
  T({ "AlexvZyl/nordic.nvim", name = "nordic" }),

  -- Nordic / cool-contrast (startup apply removed; kraihlight is active)
  T({ "shaunsingh/nord.nvim", name = "nord" }),
  T({ "navarasu/onedark.nvim", name = "onedark" }),
  T({ "doums/darcula", name = "darcula" }),

  -- Purple / moody / twilight
  T({ "dracula/vim", name = "dracula" }),
  T({ "rebelot/kanagawa.nvim", name = "kanagawa" }),
  T({ "GustavoPrietoP/doom-themes.nvim" }),

  -- Warm / floral / twilight
  T({ "rose-pine/neovim", name = "rose-pine" }),
  T({ "jsit/toast.vim", name = "toast" }),
  {
    -- Local port of Ryan Fleury's 4coder theme (colors/fleury.lua)
    -- Activate with: :colorscheme fleury
    "fleury",
    dir = vim.fn.stdpath("config") .. "/colors",
    event = "VeryLazy",
  },
  {
    -- Local theme (colors/kraihlight.lua) -- the ACTIVE theme,
    -- applied by lua/config/colorschemes.lua
    "kraihlight",
    dir = vim.fn.stdpath("config") .. "/colors",
    event = "VeryLazy",
  },

  -- Earthy / retro / forest
  T({ "ellisonleao/gruvbox.nvim", name = "gruvbox" }),
  T({ "sainnhe/gruvbox-material" }),
  T({ "kamwitsta/vinyl.nvim" }),
  T({ "xero/miasma.nvim", name = "miasma" }),
  T({ "ptdewey/darkearth-nvim", name = "darkearth" }),

  T({ "ribru17/bamboo.nvim" }),
  T({ "savq/melange-nvim", name = "melange" }),

  -- Red / crimson
  {
    -- Local port of the VS Code built-in "Red" theme (colors/vscode-red.lua)
    -- Activate with: :colorscheme vscode-red
    "vscode-red",
    dir = vim.fn.stdpath("config") .. "/colors",
    event = "VeryLazy",
  },
  T({ "diegoulloao/neofusion.nvim", name = "neofusion" }),
  T({ "AlessandroYorba/Alduin", name = "alduin" }),
  T({ "AlessandroYorba/Sierra", name = "sierra" }),
  T({ "srcery-colors/srcery-vim", name = "srcery" }),

  -- Lush-based / custom handcrafted
  T({ "zenbones-theme/zenbones.nvim", dependencies = "rktjmp/lush.nvim" }),
  T({ "jnurmine/Zenburn", name = "zenburn" }),
  T({ "ViViDboarder/wombat.nvim" }),

  -- Green / ambient / eye-friendly
  T({ "sainnhe/everforest", name = "everforest" }),
  T({ "Mangeshrex/uwu.vim", name = "everblush" }),
  T({ "blazkowolf/gruber-darker.nvim", name = "gruber-darker" }),
  T({ "ayu-theme/ayu-vim", name = "ayu" }),
  T({ "qaptoR-nvim/chocolatier.nvim", name = "chocolatier" }),
  T({ "lmburns/kimbox", name = "kimbox" }),
  T({ "piyush-ppradhan/naysayer.vim", name = "naysayer" }),

  -- Accessible / light-capable (ship light variants or high-legibility palettes)
  T({ "protesilaos/modus-themes", name = "modus-themes" }),
  T({ "NLKNguyen/papercolor-theme", name = "PaperColor" }),
}
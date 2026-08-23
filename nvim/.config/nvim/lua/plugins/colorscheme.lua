return {
  -- Minimal / monochrome
  {
    "vague-theme/vague.nvim",
    name = "vague",
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme("vague")
    -- end,
  },

  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanso").setup({
        --minimal = true,
      })
    end,
  },

  {
    "metalelf0/black-metal-theme-neovim",
    lazy = false,
    priority = 1000,
    config = function()
      require("black-metal").setup({
        -- optional configuration here, e.g.:
        -- Can be one of: bathory | burzum | dark-funeral | darkthrone | emperor | gorgoroth | immortal | impaled-nazarene | khold | marduk | mayhem | nile | taake | thyrfing | venom | windir
        theme = "gorgoroth",
        -- Can be one of: 'light' | 'dark', or set via vim.o.background
        variant = "dark",

        trve = true, -- switch this to false if you want light variants
        code_style = {
          comments = "italic",
          keywords = "italic",
        }
      })
      require("black-metal").load()
    end,
  },

  {
    "idr4n/github-monochrome.nvim",
    name = "github-monochrome",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  {
    "kdheepak/monochrome.nvim",
    name = "monochrome",
    lazy = false,
    priority = 1000,
    --opts = {},
  },

  {
    "nvim-mini/mini.hues",
    name = "miniwinter",
    version = false,
    lazy = false,
    priority = 1000,
  },

  {
    "CosecSecCot/cosec-twilight.nvim",
    name = "cosec-twilight",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
  },

  -- Blue / cool-toned
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 900,
    config = function()
      local ok, mod = pcall(require, "catppuccin")
      if ok and type(mod.setup) == "function" then
        mod.setup({})
      end
    end,
  },

  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 900,
    config = function()
      local ok, mod = pcall(require, "tokyonight")
      if ok and type(mod.setup) == "function" then
        mod.setup({})
      end
    end,
  },

  {
    'uloco/bluloco.nvim',
    lazy = false,
    priority = 1000,
    dependencies = { 'rktjmp/lush.nvim' },
    config = function()
      -- your optional config goes here, see below.
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    lazy = false,
    priority = 900,
    config = function()
      local ok, mod = pcall(require, "nightfox")
      if ok and type(mod.setup) == "function" then
        mod.setup({})
      end
    end,
  },

  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 900,
    -- vimscript theme: no Lua setup available
  },

  {
    "bluz71/vim-nightfly-guicolors",
    name = "nightfly",
    lazy = false,
    priority = 900,
    -- vimscript theme: no Lua setup available
  },
  { "savq/melange-nvim",    name = "melange" },

  { "AlexvZyl/nordic.nvim", name = "nordic" },

  -- Nordic / cool-contrast
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    lazy = false,
    priority = 900,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_uniform_diff_background = true

      -- Set the colorscheme
      vim.cmd.colorscheme("nord")

      -- Darken the background after colorscheme loads
      vim.api.nvim_set_hl(0, "Normal", { bg = "#0f1419" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "#0f1419" })
    end,
  },

  {
    "navarasu/onedark.nvim",
    name = "onedark",
    lazy = false,
    priority = 900,
    config = function()
      local ok, mod = pcall(require, "onedark")
      if ok and type(mod.setup) == "function" then
        mod.setup({})
      end
    end,
  },

  {
    "dracula/vim",
    name = "dracula",
    lazy = false,
    priority = 900,
    -- vimscript theme: no Lua setup available
  },

  {
    "doums/darcula",
    name = "darcula",
    lazy = false,
    priority = 800,
    -- vimscript theme: no Lua setup available
  },

  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 900,
    config = function()
      -- config
    end
  },

  -- Warm / floral / twilight
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 900,
    config = function()
      local ok, mod = pcall(require, "rose-pine")
      if ok and type(mod.setup) == "function" then
        mod.setup({})
      end
    end,
  },

  {
    "jsit/toast.vim",
    name = "toast",
    lazy = false,
    priority = 900,
    -- vimscript theme: warm red/orange accents; automatic light/dark variants
  },

  -- Earthy / retro / forest
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 900,
    config = function()
      local ok, mod = pcall(require, "gruvbox")
      if ok and type(mod.setup) == "function" then
        mod.setup({
          contrast = "hard",
          transparent = false,
          dim_inactive = false,
        })
      end
    end,
  },

  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_background = "hard"
    end,
  },

  {
    "kamwitsta/vinyl.nvim",
    config = function()
      require("vinyl").setup({
        variant = "darker",   -- the default is "lighter"
        overrides = {
          ["@string"] = {fg="#00ff00"},
        },
      })
    end
  },

  {
    "xero/miasma.nvim",
    name = "miasma",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- options
    end,
  },

  {
    "ptdewey/darkearth-nvim",
    name = "darkearth",
    lazy = false,
    priority = 1000,
    -- fennel-built theme: no Lua setup available
  },

  {
    "folke/zen-mode.nvim",
    lazy = false,
    priority = 1000,
    opts = {}
  },

  {
    'ribru17/bamboo.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('bamboo').setup {
        -- optional configuration here
      }
      require('bamboo').load()
    end,
  },

  -- Red / crimson
  {
    -- Local port of the VS Code built-in "Red" theme (colors/vscode-red.lua)
    -- Activate with: :colorscheme vscode-red
    "vscode-red",
    dir = vim.fn.stdpath("config") .. "/colors",
    lazy = false,
  },

  {
    "diegoulloao/neofusion.nvim",
    name = "neofusion",
    lazy = false,
    priority = 900,
    config = function()
      local ok, mod = pcall(require, "neofusion")
      if ok and type(mod.setup) == "function" then
        mod.setup({})
      end
    end,
  },

  {
    "AlessandroYorba/Alduin",
    name = "alduin",
    lazy = false,
    priority = 900,
    -- vimscript theme: no Lua setup available
  },

  {
    "AlessandroYorba/Sierra",
    name = "sierra",
    lazy = false,
    priority = 900,
    -- vimscript theme: no Lua setup available
  },

  {
    "srcery-colors/srcery-vim",
    name = "srcery",
    lazy = false,
    priority = 900,
    -- vimscript theme: no Lua setup available
  },

  -- Lush-based / custom handcrafted
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "jnurmine/Zenburn",
    name = "zenburn",
    lazy = false,
    priority = 1000,
  },

  { "ViViDboarder/wombat.nvim" },

  -- Green / ambient / eye-friendly
  {
    "sainnhe/everforest",
    name = "everforest",
    lazy = false,
    priority = 900,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_enable_italic = true
      vim.g.everforest_disable_italic_comment = false
      vim.g.everforest_better_performance = true
    end,
  },

  {
    -- NOTE: uwu.vim actually ships Everblush (teal/green), not red
    "Mangeshrex/uwu.vim",
    name = "everblush",
    lazy = false,
    priority = 900,
    -- vimscript theme: activate with :colorscheme everblush
  },

  {
    "blazkowolf/gruber-darker.nvim",
    name = "gruber-darker",
    lazy = false,
    priority = 800,
    config = function()
      local ok, mod = pcall(require, "gruber-darker")
      if ok and type(mod.setup) == "function" then
        mod.setup({})
      end
    end,
  },

  {
    "ayu-theme/ayu-vim",
    name = "ayu",
    lazy = false,
    priority = 900,
    -- vimscript theme: no Lua setup available
  },

  {
    "qaptoR-nvim/chocolatier.nvim",
    name = "chocolatier",
    lazy = false,
    priority = 800,
    config = function()
      local ok, mod = pcall(require, "chocolatier")
      if ok and type(mod.setup) == "function" then
        mod.setup({})
      end
    end,
  },

  {
    "lmburns/kimbox",
    name = "kimbox",
    lazy = false,
    priority = 800,
    -- vimscript theme: no Lua setup available
  },

  {
    "protesilaos/modus-themes",
    name = "modus-themes",
    lazy = false,
    priority = 800,
    config = function()
      -- modus-themes is mostly Vimscript; set minimal options if desired
      vim.g.modus_themes_enable_bold = 1
    end,
  },

  {
    "GustavoPrietoP/doom-themes.nvim",
    lazy = false,
    priority = 800,
  },

  {
    "piyush-ppradhan/naysayer.vim",
    name = "naysayer",
    lazy = false,
    priority = 1000,
  },

  {
    "NLKNguyen/papercolor-theme",
    name = "PaperColor",
    lazy = false,
    priority = 1000,
  },


}
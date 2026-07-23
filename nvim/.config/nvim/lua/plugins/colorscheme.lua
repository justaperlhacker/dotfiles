return {
  {
    "vague-theme/vague.nvim",
    name = "vague",
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme("vague")
    -- end,
  },
  {
    "idr4n/github-monochrome.nvim",
    name = "github-monochrome",
    lazy = false,
    priority = 1000,    
    opts = {},
  },

  { "kdheepak/monochrome.nvim" },
  {
    "nvim-mini/mini.hues",
    name = "miniwinter",
    version = false,
    lazy = false,
    priority = 1000,
  },

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
  { "savq/melange-nvim", name = "melange" },
	{ "AlexvZyl/nordic.nvim", name = "nordic" },
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

  --{ "romgrk/doom-one.vim", name = "doom-one" },
  
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
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 900,
    config = function()
      local ok, mod = pcall(require, "gruvbox")
      if ok and type(mod.setup) == "function" then
        mod.setup({})
      end
    end,
  },

  {
    "sainnhe/everforest",
    name = "everforest",
    lazy = false,
    priority = 900,
    config = function()
      vim.g.everforest_background = vim.g.everforest_background or "medium"
    end,
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
}

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    local dashboard = require('dashboard')
    
    dashboard.setup({
      theme = 'hyper',
      config = {
        header = {
          '',
          '',
          ' ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
          ' ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
          ' ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
          ' ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
          ' ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
          ' ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
          '',
          '',
        },
        shortcut = {
          {
            desc = ' Find File',
            group = '@property',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            desc = ' Find Word',
            group = '@function',
            action = 'Telescope live_grep',
            key = 'w',
          },
          {
            desc = ' Recent Files',
            group = 'Label',
            action = 'Telescope oldfiles',
            key = 'r',
          },
          {
            desc = ' Explorer',
            group = '@constant',
            action = 'require("lazy").load({ plugins = { "neo-tree.nvim" } }); vim.cmd("Neotree toggle")',
            key = 'e',
          },
          {
            desc = ' Colorschemes',
            group = 'Number',
            action = 'Telescope colorscheme',
            key = 'c',
          },
          {
            desc = ' New File',
            group = 'Number',
            action = 'enew',
            key = 'n',
          },
          {
            desc = ' Config',
            group = '@constant',
            action = 'edit ~/.dotfiles/nvim/.config/nvim/init.lua',
            key = 'C',
          },
          {
            desc = ' Quit',
            group = 'DiagnosticError',
            action = 'qa',
            key = 'q',
          },
        },
        footer = {
          '',
          '🚀 Dashboard loaded successfully',
        },
      },
    })
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-telescope/telescope.nvim' }
}
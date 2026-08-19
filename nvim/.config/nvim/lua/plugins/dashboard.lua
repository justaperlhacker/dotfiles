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
            desc = ' Recent Files',
            group = 'Label',
            action = 'Telescope oldfiles',
            key = 'r',
          },
          {
            desc = ' Find Word',
            group = '@function',
            action = 'Telescope live_grep',
            key = 'w',
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
            key = 'c',
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
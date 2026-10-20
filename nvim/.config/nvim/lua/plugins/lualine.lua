return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'auto'
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_c = {
          {
            function()
              local navic = require('nvim-navic')
              if navic.is_available() then
                return navic.get_location()
              end
              return ''
            end,
            cond = function()
              return pcall(function() return require('nvim-navic').is_available() end)
            end,
          }
        },
      },
    })
  end
}
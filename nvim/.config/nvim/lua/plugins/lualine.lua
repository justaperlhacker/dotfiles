return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local mode_map = {
      ['NORMAL']     = 'NO',
      ['O-PENDING']  = 'OP',
      ['INSERT']     = 'IN',
      ['VISUAL']     = 'VI',
      ['V-LINE']     = 'VL',
      ['V-BLOCK']    = 'VB',
      ['SELECT']     = 'SE',
      ['S-LINE']     = 'SL',
      ['S-BLOCK']    = 'SB',
      ['REPLACE']    = 'RE',
      ['V-REPLACE']  = 'VR',
      ['COMMAND']    = 'CM',
      ['EX']         = 'EX',
      ['MORE']       = 'MO',
      ['CONFIRM']    = 'CF',
      ['SHELL']      = 'SH',
      ['TERMINAL']   = 'TR',
    }
    
    require('lualine').setup({
      options = {
        theme = 'auto'
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              return mode_map[str] or str:sub(1, 2)
            end,
          }
        },
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

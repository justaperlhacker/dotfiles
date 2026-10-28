return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function max_width(ratio)
      return function()
        return math.floor(vim.o.columns * ratio)
      end
    end

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
      -- Top bar: tab pages on the left, open buffers on the right.
      tabline = {
        lualine_a = {
          { 'tabs', mode = 2, path = 0, max_length = max_width(0.35) },
        },
        lualine_z = {
          { 'buffers', mode = 0, show_modified_status = true, max_length = max_width(0.55) },
        },
      },
    })
  end
}

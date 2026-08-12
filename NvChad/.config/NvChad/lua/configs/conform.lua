local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    perl = { "perltidy" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  -- disable automatic formatting on save
  format_on_save = false,
}

return options

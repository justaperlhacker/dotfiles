return {
  "tummetott/reticle.nvim",
  event = "VeryLazy",
  opts = {
    -- Enable cursorline on startup (and keep cursorcolumn off)
    on_startup = {
      cursorline = true,
      cursorcolumn = false,
    },
    -- Automatically disable line highlight when typing in insert mode
    disable_in_insert = true,

    -- Prevent reticle from messing with specific UI popups/trees
    ignore = {
      cursorline = {
        "NvimTree",
        "lazy",
        "mason",
        "TelescopePrompt",
      },
    },
  },
}



return { 
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.config")
    config.setup({
      ensure_installed = { "lua", "python", "bash", "markdown", "yaml", "json", "c", "vim", "vimdoc", "javascript", "html" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}





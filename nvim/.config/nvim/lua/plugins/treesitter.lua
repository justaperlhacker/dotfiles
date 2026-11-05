return { 
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.config")
    config.setup({
      ensure_installed = { "lua", "python", "perl", "bash", "markdown", "markdown_inline", "yaml", "json", "c", "cpp", "c3", "vim", "vimdoc", "javascript", "html", "zig" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}





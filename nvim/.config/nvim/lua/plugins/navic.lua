return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  event = "LspAttach",
  config = function()
    require("nvim-navic").setup({
      separator = " > ",
      highlight = true,
      depth_limit = 5,
      depth_limit_indicator = "…",
      lsp = {
        auto_attach = true,
        preference = { "lua_ls", "ts_ls", "basedpyright", "roslyn_ls", "perllsp" },
      },
    })
  end,
}

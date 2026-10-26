return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "markdown_inline" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.icons",
  },
  keys = {
    { "<leader>rm", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Toggle markdown render" },
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}

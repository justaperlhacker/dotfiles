return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>b", group = "Buffers" },
      { "<leader>c", group = "Compile" },
      { "<leader>t", group = "Tabs" },
    },
  },
}
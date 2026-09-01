return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File Explorer" },
    { "<leader>E", "<cmd>Neotree toggle<cr>", desc = "File Explorer" },
    { "<leader>o", "<cmd>Neotree toggle position=right document_symbols<cr>", desc = "Outline (Tagbar)" },
    { "<leader>O", "<cmd>Neotree toggle float document_symbols<cr>", desc = "Outline (float)" },
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      window = {
        width = 30,
      },
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      default_source = "filesystem",
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
      },
      document_symbols = {
        window = {
          mappings = {
            ["<cr>"] = "jump_to_symbol",
            ["o"] = "jump_to_symbol",
            ["<C-r>"] = false,
          },
        },
      },
    })
  end,
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    indent = { enabled = true },
    terminal = { enabled = true },
    lazygit = { enabled = true },
    zen = { enabled = true }
  },
  keys = {
    -- Terminal toggles live in lua/plugins/toggleterm.lua
    -- Lazygit
    { "<leader>gL", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<F11>", function() Snacks.lazygit() end, mode = { "n", "t" }, desc = "Lazygit" },
    -- Window zoom (vim-maximizer style)
    { "<F3>", function() Snacks.zen.zoom() end, mode = { "n", "v", "i", "t" }, desc = "Toggle maximize window" },
    { "<leader>sm", function() Snacks.zen.zoom() end, desc = "Toggle maximize window" },
  },
}
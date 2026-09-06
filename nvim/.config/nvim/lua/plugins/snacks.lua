return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    indent = { enabled = true },
    terminal = { enabled = true },
    lazygit = { enabled = true }
  },
  keys = {
    -- Terminal
    { "<c-/>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle Terminal" },
    { "<c-_>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "which_key_ignore" },
    -- Lazygit
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
  },
}
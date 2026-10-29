return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { "<C-/>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle Terminal" },
    { "<C-_>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "which_key_ignore" },
    { "<F12>", "<cmd>ToggleTerm direction=float<cr>", mode = { "n", "t" }, desc = "Toggle Floating Terminal" },
    { "<leader>Th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (horizontal)" },
    { "<leader>Tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Terminal (vertical)" },
    { "<leader>Tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal (float)" },
  },
  opts = {
    direction = "horizontal",
    size = 20,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    close_on_exit = true,
    auto_scroll = true,
    shading_factor = 2,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
      width = function() return math.floor(vim.o.columns * 0.8) end,
      height = function() return math.floor(vim.o.lines * 0.8) end,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- toggleterm's own defaults don't touch <C-\>; <Esc> is quicker than <C-\><C-n>.
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })
  end,
}

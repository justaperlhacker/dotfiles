vim.opt.guicursor = {
  "n:block",          -- normal mode
  "i:beam",           -- insert mode
  "v:underline",      -- visual mode
  "c:block",          -- command mode
  "a:block",          -- all modes fallback
}

require("smear_cursor").setup()

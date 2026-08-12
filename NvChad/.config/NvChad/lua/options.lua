require "nvchad.options"

local opt = vim.opt

opt.cursorlineopt = 'both' -- to enable cursorline!

-- cursor
opt.guicursor = {
  "n:block",          -- normal mode: block (Windows-like)
  "i:ver25",          -- insert mode: vert beam
  "ci:ver25",         -- command-insert, visual: vert beam
  "ve:ver25",         -- visual: vert beam
  "r-cr:hor20",       -- replace, command-replace: horizontal bar
  "o:hor50",          -- operator-pending: thicker bar
}

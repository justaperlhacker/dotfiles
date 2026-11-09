-- Zig: 4-space indent, in line with the zig standard formatter/style guide.
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- Format through the compiler's own formatter (zls uses the same one, but
-- this also works when zls isn't attached). Buffer-local so it overrides the
-- global perltidy mapping.
vim.keymap.set("n", "<leader>pf", "<cmd>%!zig fmt --stdin<cr>", {
  buffer = true,
  desc = "Format buffer with zig fmt",
})

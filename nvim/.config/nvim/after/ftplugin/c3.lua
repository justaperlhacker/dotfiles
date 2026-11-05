-- C3: 4-space indent per C3 style conventions.
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

vim.bo.includeexpr = "v:lua.require'config.gf'.c3(v:fname)"
vim.bo.suffixesadd = ".c3"

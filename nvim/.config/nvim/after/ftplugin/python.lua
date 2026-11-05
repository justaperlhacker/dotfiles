vim.bo.includeexpr = "v:lua.require'config.gf'.python(v:fname)"
vim.bo.suffixesadd = ".py"

-- PEP 8: 4-space indent, never tabs.
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- python's structure is indentation, so fold by indent (default elsewhere is treesitter)
vim.bo.foldmethod = "indent"

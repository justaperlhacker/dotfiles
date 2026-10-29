vim.bo.includeexpr = "v:lua.require'config.gf'.perl(v:fname)"
vim.bo.suffixesadd = ".pm,.pod,.pl,.t"

-- Perl fallback defaults: hard tabs, 4-column width. A project .editorconfig
-- still wins when present (editorconfig.nvim applies after FileType).
vim.bo.expandtab = false
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 0

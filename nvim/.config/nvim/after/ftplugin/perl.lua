vim.bo.includeexpr = "v:lua.require'config.gf'.perl(v:fname)"
vim.bo.suffixesadd = ".pm,.pod,.pl,.t"

-- Perl Best Practices: 4-column indent in spaces (matches perltidy's
-- default -i=4 and PBP's ProhibitHardTabs). A project .editorconfig still
-- wins when present (editorconfig.nvim applies after FileType).
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

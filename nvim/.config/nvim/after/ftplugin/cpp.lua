vim.bo.includeexpr = "v:lua.require'config.gf'.c(v:fname)"
vim.bo.suffixesadd = ".h,.hpp,.hxx,.h++,.hh,.cc,.cpp,.cxx"

-- C++: spaces, 2-wide (Google / LLVM convention). A project .editorconfig
-- still wins when present (editorconfig.nvim applies after FileType).
vim.bo.expandtab = true
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

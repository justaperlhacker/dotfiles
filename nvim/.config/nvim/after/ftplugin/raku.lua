vim.bo.includeexpr = "v:lua.require'config.gf'.raku(v:fname)"
vim.bo.suffixesadd = ".rakumod,.pm6,.pm,.raku,.rakutest,.p6"

-- Match the Perl Best Practices style used for Perl: 4-column indent in
-- spaces. A project .editorconfig still wins when present.
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

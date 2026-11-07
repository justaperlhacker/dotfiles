vim.bo.includeexpr = "v:lua.require'config.gf'.python(v:fname)"
vim.bo.suffixesadd = ".py"

-- PEP 8: 4-space indent, never tabs.
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- python's structure is indentation, so fold by indent (default elsewhere is treesitter)
-- 'foldmethod' is window-local, so it must go through vim.wo, never vim.bo.
-- vim.bo rejects it on every supported Neovim version (0.9: "not a buffer
-- option"; 0.10+: "'buf' cannot be passed for window-local option").
if vim.fn.has("nvim-0.10") == 1 then
  -- 0.10+ can address the current window/buffer explicitly.
  vim.wo[0][0].foldmethod = "indent"
else
  -- 0.9.x only supports the implicit current-window accessor.
  vim.wo.foldmethod = "indent"
end

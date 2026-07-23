local on_attach = function(_, bufnr)
  local bmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end
  bmap("gd", vim.lsp.buf.definition, "Go to Definition")
  bmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
  bmap("gr", vim.lsp.buf.references, "References")
  bmap("gi", vim.lsp.buf.implementation, "Go to Implementation")
  bmap("K", vim.lsp.buf.hover, "Hover")
  bmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  bmap("<leader>rn", vim.lsp.buf.rename, "Rename")
  bmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")
  bmap("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
  bmap("]d", vim.diagnostic.goto_next, "Next Diagnostic")
  bmap("<leader>q", vim.diagnostic.setloclist, "Diagnostics to Location List")
end

local servers = { "lua_ls", "ts_ls", "pyright" }
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = on_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  })
  vim.lsp.enable(server)
end

-- Perl::LanguageServer (installed via CPAN, not mason)
vim.lsp.config("perlLanguageServer", {
  on_attach = on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  cmd = { "perl", "-MPerl::LanguageServer", "-e", "Perl::LanguageServer->run()" },
  filetypes = { "perl" },
})
vim.lsp.enable("perlLanguageServer")

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

-- Completion capabilities from blink.cmp (eager-loaded, see plugins/completion.lua).
-- Falls back to stock capabilities if blink is unavailable.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok and blink.get_lsp_capabilities then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

local servers = { "lua_ls", "ts_ls", "basedpyright" }
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable(server)
end

-- Roslyn (mason: roslyn-language-server) needs pull-based diagnostics
-- enabled, otherwise no diagnostics are reported
vim.lsp.config("roslyn_ls", {
  on_attach = on_attach,
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    textDocument = { diagnostic = { dynamicRegistration = true } },
  }),
})
vim.lsp.enable("roslyn_ls")

-- Perl language server: Rust-backed `perllsp` (matches the NvChad setup)
vim.lsp.config("perllsp", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "perllsp", "--stdio" },
  filetypes = { "perl" },
  root_markers = { "cpanfile", "Makefile.PL", "Build.PL", ".git" },
})
vim.lsp.enable("perllsp")

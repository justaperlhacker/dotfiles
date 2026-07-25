--require("nvchad.configs.lspconfig").defaults()

-- local servers = { "html", "cssls" }
-- vim.lsp.enable(servers)
-- read :h vim.lsp.config for changing options of lsp servers 


-- Load NvChad's default LSP mappings & capabilities
require("nvchad.configs.lspconfig").defaults()

local nvf = require "nvchad.configs.lspconfig"

-- Helper to apply NvChad defaults to any server config
local function add_server(name, config)
  vim.lsp.config[name] = vim.tbl_deep_extend("force", {
    on_attach = nvf.on_attach,
    on_init = nvf.on_init,
    capabilities = nvf.capabilities,
  }, config or {})

  vim.lsp.enable(name)
end

----------------------------------------------------------------------
-- Standard Servers
----------------------------------------------------------------------
for _, server in ipairs { "html", "cssls" } do
  add_server(server)
end

----------------------------------------------------------------------
-- Custom Servers
----------------------------------------------------------------------
add_server("perllsp", {
  cmd = { "perllsp", "--stdio" },
  filetypes = { "perl" },
  root_markers = { "cpanfile", "Makefile.PL", "Build.PL", ".git" },
})




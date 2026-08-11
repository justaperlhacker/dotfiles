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
  on_attach = function(client, bufnr)
    nvf.on_attach(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    if client.server_capabilities.textDocumentSync then
      client.server_capabilities.textDocumentSync.willSaveWaitUntil = false
    end
  end,
})

----------------------------------------------------------------------
-- Roslyn C# Language Server
-- Install with :MasonInstall roslyn-language-server
----------------------------------------------------------------------
local fs = vim.fs

-- Roslyn uses pull-based diagnostics; re-request them once the
-- workspace finishes loading, otherwise diagnostics can be missing.
local function roslyn_refresh_diagnostics(client)
  local capabilities = vim
    .iter(client.dynamic_capabilities.capabilities.diagnosticProvider or {})
    :map(function(cap)
      return cap.registerOptions.identifier
    end)
    :totable()

  for buf, _ in pairs(client.attached_buffers) do
    if vim.api.nvim_buf_is_loaded(buf) then
      for _, cap in pairs(capabilities) do
        client:request("textDocument/diagnostic", {
          identifier = cap,
          textDocument = vim.lsp.util.make_text_document_params(buf),
        }, nil, buf)
      end
    end
  end
end

local function roslyn_on_init(client)
  nvf.on_init(client)
  local root_dir = client.config.root_dir
  if not root_dir then
    return
  end

  -- Open the solution first so Roslyn loads the whole workspace
  for entry, type in fs.dir(root_dir) do
    if type == "file" and (vim.endswith(entry, ".sln") or vim.endswith(entry, ".slnx")) then
      client:notify("solution/open", { solution = vim.uri_from_fname(fs.joinpath(root_dir, entry)) })
      return
    end
  end

  -- Otherwise open all projects at the root
  local projects = {}
  for entry, type in fs.dir(root_dir) do
    if type == "file" and vim.endswith(entry, ".csproj") then
      projects[#projects + 1] = vim.uri_from_fname(fs.joinpath(root_dir, entry))
    end
  end
  if #projects > 0 then
    client:notify("project/open", { projects = projects })
  end
end

add_server("roslyn_ls", {
  cmd = { "roslyn-language-server", "--stdio" },
  filetypes = { "cs" },
  root_markers = { ".sln", ".slnx", ".csproj" },
  -- dynamicRegistration must be true or Roslyn reports no diagnostics
  capabilities = vim.tbl_deep_extend("force", nvf.capabilities, {
    textDocument = { diagnostic = { dynamicRegistration = true } },
  }),
  on_init = roslyn_on_init,
  handlers = {
    ["workspace/projectInitializationComplete"] = function(_, _, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client then
        roslyn_refresh_diagnostics(client)
      end
      return vim.NIL
    end,
  },
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "fullSolution",
      dotnet_compiler_diagnostics_scope = "fullSolution",
    },
    ["csharp|completion"] = {
      dotnet_show_name_completion_suggestions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_provide_regex_completions = true,
    },
  },
})




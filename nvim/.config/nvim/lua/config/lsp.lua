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
  bmap("[d", function()
    vim.diagnostic.jump({ count = -vim.v.count1 })
  end, "Prev Diagnostic")
  bmap("]d", function()
    vim.diagnostic.jump({ count = vim.v.count1 })
  end, "Next Diagnostic")
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

-- Raku language server (mason: raku-navigator).
-- rakuPath is absolute so syntax checking works even when the rakubrew
-- shell hook hasn't run (e.g. GUI clients like Neovide). Update it if you
-- switch Rakudo versions (`ls ~/.rakubrew/versions`).
vim.lsp.config("raku_navigator", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "raku-navigator", "--stdio" },
  filetypes = { "raku" },
  root_markers = { ".git" },
  settings = {
    -- NOTE: the server requests section "raku" (not "raku_navigator"),
    -- so the key must be `raku` for rakuPath to take effect.
    raku = {
      rakuPath = "/home/johnm/.rakubrew/versions/moar-2026.07/bin/raku",
    },
  },
})
vim.lsp.enable("raku_navigator")

-- Perl language server: Rust-backed `perllsp` (matches the NvChad setup)
vim.lsp.config("perllsp", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = function(dispatchers)
    -- perllsp reads PERL5LIB at startup (before workspace/configuration is
    -- applied), so give it the perlbrew site_perl dirs up front. Otherwise the
    -- first parse can't see Moo / Types::Standard and reports PL701 falsely.
    local env = vim.fn.environ()
    if (env.PERL5LIB or "") == "" then
      local perl = vim.fn.exepath("perl")
      if perl ~= "" then
        local dirs = vim.fn.systemlist({
          perl,
          "-e",
          [[print join(qq{\n}, grep { m{site_perl|vendor_perl} } @INC)]],
        })
        if vim.v.shell_error == 0 and #dirs > 0 then
          env.PERL5LIB = table.concat(dirs, ":")
        end
      end
    end
    return vim.lsp.rpc.start({ "perllsp", "--stdio" }, dispatchers, { env = env })
  end,
  filetypes = { "perl" },
  root_markers = { "cpanfile", "Makefile.PL", "Build.PL", ".git" },
  settings = {
    -- perllsp ships with system @INC disabled (include_paths only). Enabling
    -- this makes it probe the detected interpreter (perlbrew 5.44) for @INC,
    -- which is where Moo / Types::Standard / Type::Params live.
    -- includePaths is intentionally omitted so a project's .perl-lsp.toml
    -- include_paths (loaded at workspace init) is not overwritten.
    perl = {
      workspace = {
        useSystemInc = true,
        usePerl5lib = true,
      },
    },
  },
})
vim.lsp.enable("perllsp")

-- Work around perllsp emitting one broad function/method semantic token for an
-- entire single-line call (e.g. `has 'target' => ( is => 'ro', isa => Str );`).
-- That token overrides syntax highlighting for the whole line. Drop only those
-- whole-line marks and let the normal Perl highlighting show through.
vim.api.nvim_create_autocmd("LspTokenUpdate", {
  callback = function(args)
    local data = args.data or {}
    local token = data.token
    local client_id = data.client_id
    if not token or not client_id then
      return
    end

    local client = vim.lsp.get_client_by_id(client_id)
    if
      not client
      or client.name ~= "perllsp"
      or (token.type ~= "function" and token.type ~= "method")
      or token.start_col ~= 0
      or token.end_line ~= token.line
    then
      return
    end

    local line = vim.api.nvim_buf_get_lines(args.buf, token.line, token.line + 1, false)[1]
    if not line then
      return
    end

    -- The broad token usually stops just before the trailing semicolon.
    local suffix = line:sub(token.end_col + 1)
    if token.end_col < #line and not suffix:match("^[%s;]*$") then
      return
    end

    local ns = vim.api.nvim_get_namespaces()["nvim.lsp.semantic_tokens:" .. client_id]
    if not ns then
      return
    end

    local marks =
      vim.api.nvim_buf_get_extmarks(args.buf, ns, { token.line, 0 }, { token.line, token.end_col }, {})
    for _, mark in ipairs(marks) do
      vim.api.nvim_buf_del_extmark(args.buf, ns, mark[1])
    end
  end,
})

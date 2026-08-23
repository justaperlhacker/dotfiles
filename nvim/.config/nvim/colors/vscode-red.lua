-- vscode-red: Neovim port of the Visual Studio Code built-in "Red" theme
-- Palette sourced from microsoft/vscode extensions/theme-red/themes/Red-color-theme.json

vim.cmd("highlight clear")
vim.o.background = "dark"
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "vscode-red"

local c = {
  bg          = "#390000", -- editor.background
  bg_dark     = "#300000", -- editorWidget.background
  bg_sidebar  = "#330000", -- sideBar.background
  bg_status   = "#700000", -- statusBar.background
  bg_title    = "#770000", -- titleBar.activeBackground
  bg_activity = "#580000", -- activityBar.background
  bg_visual   = "#750000", -- editor.selectionBackground
  bg_line     = "#4d0000", -- editor.lineHighlightBackground (blended)
  border      = "#580000",
  ws          = "#c10000", -- editorWhitespace.foreground
  fg          = "#F8F8F8", -- editor.foreground
  fg_dim      = "#cf9090",
  link        = "#FFD0AA", -- editorLink.activeForeground
  remote      = "#cc3333", -- statusBarItem.remoteBackground
  red         = "#ff5555",
  orange      = "#ce9178",
  yellow      = "#ffd75f",
  green       = "#98c379",
  cyan        = "#56d4dd",
  blue        = "#82aaff",
  magenta     = "#ff79c6",
  none        = "NONE",
}

local hi = function(group, opts)
  opts.default = false
  vim.api.nvim_set_hl(0, group, opts)
end

local link = function(from, to)
  vim.api.nvim_set_hl(0, from, { link = to, default = false })
end

-- Terminal palette (red-tinted ANSI)
vim.g.terminal_color_0  = "#300000"
vim.g.terminal_color_1  = "#ff5555"
vim.g.terminal_color_2  = "#98c379"
vim.g.terminal_color_3  = "#ffd75f"
vim.g.terminal_color_4  = "#82aaff"
vim.g.terminal_color_5  = "#ff79c6"
vim.g.terminal_color_6  = "#56d4dd"
vim.g.terminal_color_7  = "#F8F8F8"
vim.g.terminal_color_8  = "#8f5050"
vim.g.terminal_color_9  = "#ff8888"
vim.g.terminal_color_10 = "#b5e890"
vim.g.terminal_color_11 = "#ffe49c"
vim.g.terminal_color_12 = "#aac4ff"
vim.g.terminal_color_13 = "#ffa3d6"
vim.g.terminal_color_14 = "#8ee4ea"
vim.g.terminal_color_15 = "#ffffff"

-- Base
hi("Normal",           { fg = c.fg, bg = c.bg })
hi("NormalNC",         { fg = c.fg, bg = c.bg })
hi("NormalFloat",      { fg = c.fg, bg = c.bg_dark })
hi("FloatBorder",      { fg = c.border, bg = c.bg_dark })
hi("FloatTitle",       { fg = c.link, bg = c.bg_dark, bold = true })
hi("EndOfBuffer",      { fg = c.bg, bg = c.none })
hi("ColorColumn",      { bg = "#450000" })
hi("Conceal",          { fg = c.fg_dim, bg = c.none })
hi("Cursor",           { fg = c.bg, bg = c.fg })
hi("CursorColumn",     { bg = c.bg_line })
hi("CursorLine",       { bg = c.bg_line })
hi("Directory",        { fg = c.link, bold = true })
hi("Error",            { fg = c.red, bg = c.none })
hi("ErrorMsg",         { fg = c.red, bg = c.none })
hi("WarningMsg",       { fg = c.yellow, bg = c.none })
hi("ModeMsg",          { fg = c.fg_dim, bg = c.none })
hi("MoreMsg",          { fg = c.green, bg = c.none })
hi("Question",         { fg = c.green, bg = c.none })
hi("SpecialKey",       { fg = c.ws, bg = c.none })
hi("Title",            { fg = c.link, bg = c.none, bold = true })
hi("Whitespace",       { fg = c.ws, bg = c.none })
hi("NonText",          { fg = c.ws, bg = c.none })

-- Lines / signs
hi("LineNr",           { fg = "#9e5252", bg = c.none })
hi("CursorLineNr",     { fg = "#ffbbbb", bg = c.bg_line, bold = true }) -- editorLineNumber.activeForeground
hi("SignColumn",       { fg = c.fg_dim, bg = c.none })
hi("Folded",           { fg = c.fg_dim, bg = c.bg_sidebar })
hi("FoldColumn",       { fg = c.border, bg = c.none })
hi("WinSeparator",     { fg = c.border, bg = c.none })
link("VertSplit", "WinSeparator")

-- Selection / search
hi("Visual",           { bg = c.bg_visual })
hi("VisualNOS",        { bg = c.bg_visual })
hi("Search",           { fg = c.fg, bg = "#991111" })
hi("IncSearch",        { fg = c.bg, bg = c.remote, bold = true })
hi("CurSearch",        { fg = c.bg, bg = c.remote, bold = true })
hi("Substitute",       { fg = c.bg, bg = c.remote })
hi("MatchParen",       { fg = c.fg, bg = c.bg_visual, bold = true })

-- UI chrome
hi("StatusLine",       { fg = c.fg, bg = c.bg_status })
hi("StatusLineNC",     { fg = c.fg_dim, bg = c.bg_sidebar })
hi("TabLine",          { fg = c.fg_dim, bg = "#300a0a" })   -- tab.inactiveBackground
hi("TabLineFill",      { bg = c.bg_sidebar })               -- editorGroupHeader.tabsBackground
hi("TabLineSel",       { fg = c.fg, bg = "#490000", bold = true }) -- tab.activeBackground
hi("Pmenu",            { fg = c.fg, bg = c.bg_dark })
hi("PmenuSel",         { fg = c.fg, bg = c.bg_activity, bold = true })
hi("PmenuSbar",        { bg = c.bg_dark })
hi("PmenuThumb",       { bg = c.border })
hi("WildMenu",         { fg = c.bg, bg = c.remote })
hi("WinBar",           { fg = c.fg_dim, bg = c.bg })
hi("WinBarNC",         { fg = c.fg_dim, bg = c.bg })

-- Diffs
hi("DiffAdd",          { fg = c.green, bg = "#163a16" })
hi("DiffChange",       { fg = c.yellow, bg = "#463500" })
hi("DiffDelete",       { fg = c.red, bg = "#6b0000" })
hi("DiffText",         { fg = c.bg, bg = c.yellow, bold = true })
hi("Added",            { fg = c.green })
hi("Changed",          { fg = c.yellow })
hi("Removed",          { fg = c.red })

-- Spelling
hi("SpellBad",   { fg = c.red, underline = true, sp = c.red })
hi("SpellCap",   { fg = c.blue, underline = true, sp = c.blue })
hi("SpellLocal", { fg = c.cyan, underline = true, sp = c.cyan })
hi("SpellRare",  { fg = c.magenta, underline = true, sp = c.magenta })

-- Diagnostics
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn",  { fg = c.yellow })
hi("DiagnosticInfo",  { fg = c.blue })
hi("DiagnosticHint",  { fg = c.cyan })
hi("DiagnosticOk",    { fg = c.green })
hi("DiagnosticVirtualTextError", { fg = c.red })
hi("DiagnosticVirtualTextWarn",  { fg = c.yellow })
hi("DiagnosticVirtualTextInfo",  { fg = c.blue })
hi("DiagnosticVirtualTextHint",  { fg = c.cyan })
hi("DiagnosticVirtualTextOk",    { fg = c.green })
hi("DiagnosticUnderlineError",   { underline = true, sp = c.red })
hi("DiagnosticUnderlineWarn",    { underline = true, sp = c.yellow })
hi("DiagnosticUnderlineInfo",    { underline = true, sp = c.blue })
hi("DiagnosticUnderlineHint",    { underline = true, sp = c.cyan })
hi("DiagnosticUnderlineOk",      { underline = true, sp = c.green })

-- Syntax
hi("Comment",        { fg = "#a8766c", italic = true })
hi("Constant",       { fg = "#ffaaaa" })
hi("String",         { fg = c.orange })
hi("Character",      { fg = c.orange })
hi("Number",         { fg = "#ffb86c" })
hi("Boolean",        { fg = "#ff9d9d" })
hi("Float",          { fg = "#ffb86c" })
hi("Identifier",     { fg = c.fg })
hi("Function",       { fg = c.link })
hi("Statement",      { fg = "#ff7778", bold = true })
hi("Conditional",    { fg = "#ff7778", bold = true })
hi("Repeat",         { fg = "#ff7778", bold = true })
hi("Label",          { fg = "#ff9d9d" })
hi("Operator",       { fg = "#e0999a" })
hi("Keyword",        { fg = "#ff7778", bold = true })
hi("Exception",      { fg = c.red, bold = true })
hi("PreProc",        { fg = c.magenta })
hi("Include",        { fg = c.magenta })
hi("Define",         { fg = c.magenta })
hi("Macro",          { fg = c.magenta })
hi("PreCondit",      { fg = c.magenta })
hi("Type",           { fg = "#ffc9c9" })
hi("StorageClass",   { fg = "#ff7778" })
hi("Structure",      { fg = "#ffc9c9" })
hi("Typedef",        { fg = "#ffc9c9" })
hi("Special",        { fg = c.cyan })
hi("SpecialChar",    { fg = c.cyan })
hi("Tag",            { fg = c.link })
hi("Delimiter",      { fg = "#e0999a" })
hi("SpecialComment", { fg = "#c98a7d", italic = true })
hi("Debug",          { fg = c.red })
hi("Underlined",     { fg = c.link, underline = true })
hi("Bold",           { bold = true })
hi("Italic",         { italic = true })
hi("Todo",           { fg = c.bg, bg = c.yellow, bold = true })

-- Treesitter
link("@comment", "Comment")
link("@string", "String")
link("@character", "Character")
link("@number", "Number")
link("@boolean", "Boolean")
link("@float", "Float")
link("@constant", "Constant")
link("@constant.builtin", "Constant")
link("@constant.macro", "Macro")
link("@module", "Type")
link("@label", "Label")
link("@operator", "Operator")
link("@keyword", "Keyword")
link("@keyword.function", "Keyword")
link("@keyword.operator", "Operator")
link("@exception", "Exception")
link("@punctuation.bracket", "Delimiter")
link("@punctuation.delimiter", "Delimiter")
link("@variable", "Identifier")
link("@variable.builtin", "Identifier")
link("@variable.parameter", "Identifier")
link("@variable.member", "Identifier")
link("@function", "Function")
link("@function.builtin", "Function")
link("@function.macro", "Macro")
link("@method", "Function")
link("@constructor", "Type")
link("@type", "Type")
link("@type.builtin", "Type")
link("@property", "Identifier")
link("@field", "Identifier")

-- LSP semantic tokens
link("@lsp.type.namespace", "@module")
link("@lsp.type.class", "@type")
link("@lsp.type.enum", "@type")
link("@lsp.type.interface", "@type")
link("@lsp.type.struct", "@type")
link("@lsp.type.parameter", "@variable.parameter")
link("@lsp.type.variable", "@variable")
link("@lsp.type.property", "@property")
link("@lsp.type.function", "@function")
link("@lsp.type.method", "@method")
link("@lsp.type.macro", "Macro")
link("@lsp.type.decorator", "PreProc")

-- Plugin touches
hi("TelescopeBorder",     { fg = c.border, bg = c.bg })
hi("TelescopePromptTitle", { fg = c.bg, bg = c.remote, bold = true })
hi("TelescopeResultsTitle", { fg = c.bg, bg = c.link, bold = true })
hi("TelescopePreviewTitle", { fg = c.bg, bg = c.green, bold = true })
hi("WhichKeyFloat",        { bg = c.bg_dark })
hi("NormalFloatSB",        { bg = c.bg_dark })

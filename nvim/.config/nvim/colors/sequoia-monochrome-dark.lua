-- sequoia-monochrome-dark: Neovim port of the Sequoia "Monochrome Dark" theme
-- Palette sourced from Sequoia-Theme/color-palette (tokens.json) and the
-- upstream Neovim port (Sequoia-Theme/neovim colors/sequoia-monochrome-dark.lua).
-- (https://github.com/Sequoia-Theme)
--
-- Signature traits preserved:
--   * near-black neutral background (#0f1014), soft gray text (#868690)
--   * deliberately low-saturation, monochrome syntax (blue-gray accents)
--   * muted blue-gray selection / active-tab highlights (#817c9c at low alpha)
--   * italic identifiers, functions and comments

vim.cmd("highlight clear")
vim.o.background = "dark"
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "sequoia-monochrome-dark"

local c = {
  bg          = "#0f1014", -- background
  bg_dark     = "#0b0c0f", -- surface (darker)
  bg_sidebar  = "#111216", -- surface
  bg_status   = "#111216", -- surface
  bg_title    = "#111216", -- surface
  bg_activity = "#202028", -- selection (rgb 32,32,40)
  bg_visual   = "#202028", -- selection
  bg_line     = "#16171c", -- current line
  border      = "#43444d", -- comment
  ws          = "#43444d", -- comment
  fg          = "#868690", -- foreground
  fg_dim      = "#575861", -- muted
  link        = "#b6bac8", -- accent
  remote      = "#e2e4ed", -- bright accent
  red         = "#999eb2", -- error
  operator    = "#575861", -- operator
  orange      = "#626983", -- constant
  yellow      = "#626983", -- keyword
  green       = "#626983", -- support
  sum_green   = "#7c829d",
  cyan        = "#b6bac8",
  blue        = "#7c829d",
  magenta     = "#e2e4ed",
  preproc     = "#999eb2",
  fn          = "#999eb2", -- function
  type_yellow = "#7c829d", -- type
  tag_orange  = "#999eb2",
  comment     = "#43444d",
  string      = "#d3d5de",
  number      = "#626983",
  variable    = "#b6bac8",
  none        = "NONE",
}

local hi = function(group, opts)
  opts.default = false
  vim.api.nvim_set_hl(0, group, opts)
end

local link = function(from, to)
  vim.api.nvim_set_hl(0, from, { link = to, default = false })
end

-- Terminal palette (Sequoia Monochrome Dark ANSI)
vim.g.terminal_color_0  = "#131317"
vim.g.terminal_color_1  = "#999eb2"
vim.g.terminal_color_2  = "#626983"
vim.g.terminal_color_3  = "#d3d5de"
vim.g.terminal_color_4  = "#7c829d"
vim.g.terminal_color_5  = "#e2e4ed"
vim.g.terminal_color_6  = "#b6bac8"
vim.g.terminal_color_7  = "#868690"
vim.g.terminal_color_8  = "#575861"
vim.g.terminal_color_9  = "#999eb2"
vim.g.terminal_color_10 = "#626983"
vim.g.terminal_color_11 = "#d3d5de"
vim.g.terminal_color_12 = "#7c829d"
vim.g.terminal_color_13 = "#e2e4ed"
vim.g.terminal_color_14 = "#b6bac8"
vim.g.terminal_color_15 = "#868690"

-- Base
hi("Normal",           { fg = c.fg, bg = c.bg })
hi("NormalNC",         { fg = c.fg, bg = c.bg })
hi("NormalFloat",      { fg = c.fg, bg = c.bg_dark })
hi("FloatBorder",      { fg = c.border, bg = c.bg_dark })
hi("FloatTitle",       { fg = c.link, bg = c.bg_dark, bold = true })
hi("EndOfBuffer",      { fg = c.bg, bg = c.none })
hi("ColorColumn",      { bg = c.bg_line })
hi("Conceal",          { fg = c.fg_dim, bg = c.none })
hi("Cursor",           { fg = c.bg, bg = c.type_yellow })
hi("CursorColumn",     { bg = c.bg_line })
hi("CursorLine",       { bg = c.bg_line })
hi("Directory",        { fg = c.link, bold = true })
hi("Error",            { fg = c.red, bg = c.none })
hi("ErrorMsg",         { fg = c.red, bg = c.none })
hi("WarningMsg",       { fg = c.tag_orange, bg = c.none })
hi("ModeMsg",          { fg = c.fg_dim, bg = c.none })
hi("MoreMsg",          { fg = c.green, bg = c.none })
hi("Question",         { fg = c.green, bg = c.none })
hi("SpecialKey",       { fg = c.ws, bg = c.none })
hi("Title",            { fg = c.link, bg = c.none, bold = true })
hi("Whitespace",       { fg = c.ws, bg = c.none })
hi("NonText",          { fg = c.ws, bg = c.none })

-- Lines / signs
hi("LineNr",           { fg = c.ws, bg = c.none })
hi("CursorLineNr",     { fg = c.fg, bg = c.bg_line, bold = true })
hi("SignColumn",       { fg = c.fg_dim, bg = c.none })
hi("Folded",           { fg = c.fg_dim, bg = c.bg_sidebar })
hi("FoldColumn",       { fg = c.border, bg = c.none })
hi("WinSeparator",     { fg = c.border, bg = c.none })
link("VertSplit", "WinSeparator")

-- Selection / search
hi("Visual",           { bg = c.bg_visual })
hi("VisualNOS",        { bg = c.bg_visual })
hi("Search",           { fg = c.fg, bg = c.bg_visual })
hi("IncSearch",        { fg = c.bg, bg = c.link, bold = true })
hi("CurSearch",        { fg = c.bg, bg = c.link, bold = true })
hi("Substitute",       { fg = c.bg, bg = c.link })
hi("MatchParen",       { fg = c.link, bg = c.bg_visual, bold = true })

-- UI chrome
hi("StatusLine",       { fg = c.fg, bg = c.bg_status })
hi("StatusLineNC",     { fg = c.comment, bg = c.bg_dark })
hi("TabLine",          { fg = c.comment, bg = c.bg_dark })
hi("TabLineFill",      { bg = c.bg_sidebar })
hi("TabLineSel",       { fg = c.fg, bg = c.bg_activity, bold = true })
hi("Pmenu",            { fg = c.fg, bg = c.bg_sidebar })
hi("PmenuSel",         { fg = c.fg, bg = c.bg_activity, bold = true })
hi("PmenuSbar",        { bg = c.bg_dark })
hi("PmenuThumb",       { bg = c.border })
hi("WildMenu",         { fg = c.bg, bg = c.link })
hi("WinBar",           { fg = c.fg_dim, bg = c.bg })
hi("WinBarNC",         { fg = c.fg_dim, bg = c.bg })

-- Diffs
hi("DiffAdd",          { fg = c.blue, bg = "#262933" })
hi("DiffChange",       { fg = c.link, bg = "#1a1c24" })
hi("DiffDelete",       { fg = c.red, bg = "#34353c" })
hi("DiffText",         { fg = c.bg, bg = c.link, bold = true })
hi("Added",            { fg = c.blue })
hi("Changed",          { fg = c.link })
hi("Removed",          { fg = c.red })

-- Spelling
hi("SpellBad",   { fg = c.red, underline = true, sp = c.red })
hi("SpellCap",   { fg = c.blue, underline = true, sp = c.blue })
hi("SpellLocal", { fg = c.cyan, underline = true, sp = c.cyan })
hi("SpellRare",  { fg = c.magenta, underline = true, sp = c.magenta })

-- Diagnostics
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn",  { fg = c.tag_orange })
hi("DiagnosticInfo",  { fg = c.blue })
hi("DiagnosticHint",  { fg = c.cyan })
hi("DiagnosticOk",    { fg = c.green })
hi("DiagnosticVirtualTextError", { fg = c.red })
hi("DiagnosticVirtualTextWarn",  { fg = c.tag_orange })
hi("DiagnosticVirtualTextInfo",  { fg = c.blue })
hi("DiagnosticVirtualTextHint",  { fg = c.cyan })
hi("DiagnosticVirtualTextOk",    { fg = c.green })
hi("DiagnosticUnderlineError",   { underline = true, sp = c.red })
hi("DiagnosticUnderlineWarn",    { underline = true, sp = c.tag_orange })
hi("DiagnosticUnderlineInfo",    { underline = true, sp = c.blue })
hi("DiagnosticUnderlineHint",    { underline = true, sp = c.cyan })
hi("DiagnosticUnderlineOk",      { underline = true, sp = c.green })

-- Syntax (Sequoia Monochrome Dark roles)
hi("Comment",        { fg = c.comment, italic = true })
hi("Constant",       { fg = c.orange })
hi("String",         { fg = c.string })
hi("Character",      { fg = c.string })
hi("Number",         { fg = c.number })
hi("Boolean",        { fg = c.number })
hi("Float",          { fg = c.number })
hi("Identifier",     { fg = c.variable, italic = true })
hi("Function",       { fg = c.fn, italic = true })
hi("Statement",      { fg = c.yellow })
hi("Conditional",    { fg = c.yellow })
hi("Repeat",         { fg = c.yellow })
hi("Label",          { fg = c.yellow })
hi("Operator",       { fg = c.operator })
hi("Keyword",        { fg = c.yellow })
hi("Exception",      { fg = c.red })
hi("PreProc",        { fg = c.orange })
hi("Include",        { fg = c.orange })
hi("Define",         { fg = c.preproc })
hi("Macro",          { fg = c.orange })
hi("PreCondit",      { fg = c.preproc })
hi("Type",           { fg = c.type_yellow })
hi("StorageClass",   { fg = c.yellow })
hi("Structure",      { fg = c.type_yellow })
hi("Typedef",        { fg = c.type_yellow })
hi("Special",        { fg = c.type_yellow })
hi("SpecialChar",    { fg = c.string })
hi("Tag",            { fg = c.type_yellow })
hi("Delimiter",      { fg = c.operator })
hi("SpecialComment", { fg = c.comment, italic = true })
hi("Debug",          { fg = c.red })
hi("Underlined",     { fg = c.fn, underline = true })
hi("Bold",           { bold = true })
hi("Italic",         { italic = true })
hi("Todo",           { fg = c.bg, bg = c.link, bold = true })

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
hi("@variable.builtin", { fg = c.yellow })
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

-- Legacy vim-regex fallback (treesitter off)
link("luaFunction", "Function")
link("luaFuncCall", "Function")

-- Perl-specific highlights
link("perlPackageRef", "Type")
link("perlPackage", "Type")
link("perlPackageDecl", "Type")

hi("perlPOD", { fg = c.comment, italic = true })
hi("podCommand", { fg = c.yellow })
hi("podCmdText", { fg = c.comment, italic = true })

hi("podOrdinary", { fg = c.fg })
link("podVerbatim", "String")
hi("podSpecial", { fg = c.magenta })
link("podTodo", "Todo")
link("podFormat", "Special")

link("perlHereDoc", "String")
link("perlHereDocStart", "Delimiter")
link("perlIndentedHereDoc", "String")

hi("perlMatch", { fg = c.magenta })
hi("perlMatchStartEnd", { fg = c.magenta })
hi("perlSpecialMatch", { fg = c.magenta })

-- Raku (Perl 6) -- filetype raku; .raku, .pm6, .rakumod, .rakutest, .p6
link("rakuPackage", "Type")
hi("rakuPackageScope", { fg = c.yellow })
hi("rakuTwigil", { fg = c.orange })
hi("rakuBareSigil", { fg = c.orange })
link("rakuVariable", "Identifier")
link("rakuVarName", "Identifier")
link("rakuVarStorage", "Identifier")
hi("rakuVarExclam", { fg = c.yellow })
link("rakuIdentifier", "Identifier")
link("rakuType", "Type")
hi("rakuTypeConstraint", { fg = c.type_yellow })
hi("rakuDeclare", { fg = c.yellow })
hi("rakuDeclareRegex", { fg = c.yellow })
link("rakuConditional", "Conditional")
link("rakuException", "Exception")
hi("rakuFlowControl", { fg = c.yellow })
link("rakuClosureTrait", "Identifier")
link("rakuContext", "Operator")
link("rakuHyperOp", "Operator")
link("rakuOperator", "Operator")
link("rakuSetOp", "Operator")
hi("rakuBlockLabel", { fg = c.yellow })
link("rakuNumber", "Number")
hi("rakuVersion", { fg = c.orange })
link("rakuInclude", "Include")

-- Raku strings / interpolation
link("rakuString", "String")
link("rakuStringDQ", "String")
link("rakuStringSQ", "String")
link("rakuStringQ", "String")
link("rakuStringAngle", "String")
hi("rakuStringSpecial", { fg = c.magenta })
hi("rakuStringSpecial2", { fg = c.magenta })
link("rakuKey", "String")
hi("rakuShebang", { fg = c.comment, italic = true })

-- Raku regex / match operators
hi("rakuMatch", { fg = c.magenta })
hi("rakuMatchBare", { fg = c.magenta })
link("rakuMatchVar", "Identifier")
hi("rakuSubstitution", { fg = c.magenta })
hi("rakuTransliteration", { fg = c.magenta })
hi("rakuRxMeta", { fg = c.remote })
hi("rakuRxAnchor", { fg = c.remote })
hi("rakuRxCharClass", { fg = c.magenta })
hi("rakuRxAssertGroup", { fg = c.magenta })

-- Raku POD / documentation
hi("rakuPod", { fg = c.comment, italic = true })
link("rakuPodFormat", "Special")
link("rakuPodCode", "String")
hi("rakuPodComment", { fg = c.comment, italic = true })
hi("rakuPodDelim", { fg = c.yellow })

-- Raku attention / error
link("rakuAttention", "Todo")
link("rakuError", "Error")

-- Plugin touches
hi("TelescopeBorder",       { fg = c.border, bg = c.bg })
hi("TelescopePromptTitle",  { fg = c.bg, bg = c.link, bold = true })
hi("TelescopeResultsTitle", { fg = c.bg, bg = c.link, bold = true })
hi("TelescopePreviewTitle", { fg = c.bg, bg = c.green, bold = true })
hi("WhichKeyFloat",         { bg = c.bg_dark })
hi("NormalFloatSB",         { bg = c.bg_dark })

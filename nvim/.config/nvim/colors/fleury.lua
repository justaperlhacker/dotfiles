-- fleury: Neovim port of Ryan Fleury's 4coder theme
-- Palette sourced from 4coder-archive/4coder_fleury theme-fleury.4coder
-- (https://github.com/Dion-Systems/4coder_fleury/blob/master/theme-fleury.4coder)
-- 4coder colors are 0xAARRGGBB; the alpha byte is dropped below.
--
-- Signature traits preserved:
--   * near-black warm background, tan text, dim-gray italic comments
--   * "syntax crap" dimmed to brown (#5c4d3c), operators in red
--   * gold keywords, orange constants, burnt-orange functions

vim.cmd("highlight clear")
vim.o.background = "dark"
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "fleury"

local c = {
  bg          = "#020202", -- defcolor_back
  bg_dark     = "#101010", -- defcolor_line_numbers_back
  bg_sidebar  = "#222425", -- defcolor_margin
  bg_status   = "#222425", -- defcolor_margin
  bg_title    = "#222425", -- defcolor_margin
  bg_activity = "#63523d", -- defcolor_margin_hover / _active
  bg_visual   = "#303040", -- defcolor_highlight
  bg_line     = "#1e1e1e", -- defcolor_highlight_cursor_line
  border      = "#63523d", -- defcolor_margin_hover
  ws          = "#404040", -- defcolor_line_numbers_text
  fg          = "#b99468", -- defcolor_text_default
  fg_dim      = "#5c4d3c", -- fleury_color_syntax_crap
  link        = "#fcaa05", -- defcolor_base
  remote      = "#de8150", -- defcolor_pop1
  red         = "#ff0000", -- defcolor_pop2 / special_character / error_annotation
  operator    = "#bd2d2d", -- fleury_color_operators
  orange      = "#ffa900", -- str/char/int/float/bool constants + include
  yellow      = "#f0c674", -- defcolor_keyword (gold)
  green       = "#6eb535", -- fleury_color_index_constant
  sum_green   = "#a7eb13", -- fleury_color_index_sum_type
  cyan        = "#8ffff2", -- fleury_color_brace_highlight
  blue        = "#2895c7", -- fleury_color_index_macro
  magenta     = "#c9598a", -- fleury_color_index_decl
  preproc     = "#dc7575", -- defcolor_preproc
  fn          = "#de451f", -- fleury_color_index_function
  type_yellow = "#edb211", -- fleury_color_index_product_type
  tag_orange  = "#ffae00", -- fleury_color_index_comment_tag
  comment     = "#666666", -- defcolor_comment
  none        = "NONE",
}

local hi = function(group, opts)
  opts.default = false
  vim.api.nvim_set_hl(0, group, opts)
end

local link = function(from, to)
  vim.api.nvim_set_hl(0, from, { link = to, default = false })
end

-- Terminal palette (warm dark ANSI)
vim.g.terminal_color_0  = "#020202"
vim.g.terminal_color_1  = "#bd2d2d"
vim.g.terminal_color_2  = "#6eb535"
vim.g.terminal_color_3  = "#f0c674"
vim.g.terminal_color_4  = "#2895c7"
vim.g.terminal_color_5  = "#c9598a"
vim.g.terminal_color_6  = "#8ffff2"
vim.g.terminal_color_7  = "#b99468"
vim.g.terminal_color_8  = "#666666"
vim.g.terminal_color_9  = "#ff0000"
vim.g.terminal_color_10 = "#a7eb13"
vim.g.terminal_color_11 = "#ffae00"
vim.g.terminal_color_12 = "#6fb3e0"
vim.g.terminal_color_13 = "#e08bb0"
vim.g.terminal_color_14 = "#bffff5"
vim.g.terminal_color_15 = "#f0dcc0"

-- Base
hi("Normal",           { fg = c.fg, bg = c.bg })
hi("NormalNC",         { fg = c.fg, bg = c.bg })
hi("NormalFloat",      { fg = c.fg, bg = c.bg_dark })
hi("FloatBorder",      { fg = c.border, bg = c.bg_dark })
hi("FloatTitle",       { fg = c.link, bg = c.bg_dark, bold = true })
hi("EndOfBuffer",      { fg = c.bg, bg = c.none })
hi("ColorColumn",      { bg = c.bg_line })
hi("Conceal",          { fg = c.fg_dim, bg = c.none })
hi("Cursor",           { fg = c.bg, bg = "#00ee00" }) -- defcolor_cursor cycles green first
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
hi("Search",           { fg = c.bg, bg = "#494949" }) -- defcolor_mark
hi("IncSearch",        { fg = c.bg, bg = c.remote, bold = true })
hi("CurSearch",        { fg = c.bg, bg = c.remote, bold = true })
hi("Substitute",       { fg = c.bg, bg = c.remote })
hi("MatchParen",       { fg = c.cyan, bg = c.bg_visual, bold = true })

-- UI chrome
hi("StatusLine",       { fg = c.fg, bg = c.bg_status })
hi("StatusLineNC",     { fg = c.comment, bg = c.bg_sidebar })
hi("TabLine",          { fg = c.comment, bg = c.bg_dark })
hi("TabLineFill",      { bg = c.bg_sidebar })
hi("TabLineSel",       { fg = c.fg, bg = c.bg_activity, bold = true })
hi("Pmenu",            { fg = c.fg, bg = c.bg_dark })
hi("PmenuSel",         { fg = c.fg, bg = c.bg_activity, bold = true })
hi("PmenuSbar",        { bg = c.bg_dark })
hi("PmenuThumb",       { bg = c.border })
hi("WildMenu",         { fg = c.bg, bg = c.remote })
hi("WinBar",           { fg = c.fg_dim, bg = c.bg })
hi("WinBarNC",         { fg = c.fg_dim, bg = c.bg })

-- Diffs
hi("DiffAdd",          { fg = c.green, bg = "#0f2a0f" })
hi("DiffChange",       { fg = c.yellow, bg = "#2a230f" })
hi("DiffDelete",       { fg = c.red, bg = "#3a0000" }) -- defcolor_highlight_junk
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

-- Syntax (authentic fleury roles; comments deliberately not italic)
hi("Comment",        { fg = c.comment, italic = true }) -- matches global italic in config/options.lua
hi("Constant",       { fg = c.orange })
hi("String",         { fg = c.orange })
hi("Character",      { fg = c.orange })
hi("Number",         { fg = c.orange })
hi("Boolean",        { fg = c.orange })
hi("Float",          { fg = c.orange })
hi("Identifier",     { fg = c.fg })
hi("Function",       { fg = c.fn })
hi("Statement",      { fg = c.yellow })
hi("Conditional",    { fg = c.yellow })
hi("Repeat",         { fg = c.yellow })
hi("Label",          { fg = c.remote })
hi("Operator",       { fg = c.operator })
hi("Keyword",        { fg = c.yellow })
hi("Exception",      { fg = c.red, bold = true })
hi("PreProc",        { fg = c.preproc })
hi("Include",        { fg = c.orange })
hi("Define",         { fg = c.preproc })
hi("Macro",          { fg = c.blue })
hi("PreCondit",      { fg = c.preproc })
hi("Type",           { fg = c.type_yellow })
hi("StorageClass",   { fg = c.yellow })
hi("Structure",      { fg = c.type_yellow })
hi("Typedef",        { fg = c.type_yellow })
hi("Special",        { fg = c.preproc })
hi("SpecialChar",    { fg = c.red })
hi("Tag",            { fg = c.link })
hi("Delimiter",      { fg = c.fg_dim }) -- fleury "syntax crap": ; ( ) dimmed
hi("SpecialComment", { fg = c.tag_orange, italic = true })
hi("Debug",          { fg = c.red })
hi("Underlined",     { fg = c.link, underline = true })
hi("Bold",           { bold = true })
hi("Italic",         { italic = true })
hi("Todo",           { fg = c.bg, bg = c.tag_orange, bold = true })

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
hi("@variable.builtin", { fg = c.yellow }) -- distinct like kraihlight ($_, @_ ...)
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

-- Legacy vim-regex fallback (treesitter off): same as kraihlight
link("luaFunction", "Function")
link("luaFuncCall", "Function")

-- Perl-specific highlights (same roles as kraihlight, fleury palette)
link("perlPackageRef", "Type")
link("perlPackage", "Type")
link("perlPackageDecl", "Type")

-- Perl POD / documentation (italic, like all comments)
hi("perlPOD", { fg = c.comment, italic = true })
hi("podCommand", { fg = c.yellow })
hi("podCmdText", { fg = c.comment, italic = true })

-- Standalone .pod files (pod filetype)
hi("podCommand", { fg = c.yellow })
hi("podCmdText", { fg = c.comment, italic = true })
hi("podOrdinary", { fg = c.fg })
link("podVerbatim", "String")
hi("podSpecial", { fg = c.magenta })
link("podTodo", "Todo")
link("podFormat", "Special")

-- Perl heredocs
link("perlHereDoc", "String")
link("perlHereDocStart", "Delimiter")
link("perlIndentedHereDoc", "String")

-- Perl regex / match operators (s///, m//, tr///)
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
hi("TelescopePromptTitle",  { fg = c.bg, bg = c.remote, bold = true })
hi("TelescopeResultsTitle", { fg = c.bg, bg = c.link, bold = true })
hi("TelescopePreviewTitle", { fg = c.bg, bg = c.green, bold = true })
hi("WhichKeyFloat",         { bg = c.bg_dark })
hi("NormalFloatSB",         { bg = c.bg_dark })

-- nightjar: Neovim port of the Nightjar theme
-- Shared palette with the Code::Blocks theme in ~/Projects/codeblocks-nightjar
-- and the Doom Emacs theme in ~/.config/doom/themes/doom-nightjar-theme.el.
--
-- Nightjar is a dark, blue-black theme with purple keywords, mint operators,
-- green strings, coral numbers and amber types.

vim.cmd("highlight clear")
vim.o.background = "dark"
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "nightjar"

local c = {
  bg           = "#0f141a",
  bg_dark      = "#0c1014",
  bg_sidebar   = "#121820",
  bg_status    = "#1a2430",
  bg_title     = "#1a2430",
  bg_activity  = "#2e3d52",
  bg_visual    = "#2e3d52",
  bg_line      = "#161e28",
  bg_code      = "#131a22",
  cursor       = "#e6edf3",
  border       = "#263140",
  ws           = "#2b3644",
  fg           = "#d8e1ea",
  fg_dim       = "#7d8b9a",
  line_nr      = "#5c6b7d",
  comment      = "#6f7f92",
  doc_comment  = "#93a4b8",
  keyword      = "#c792ea",
  string       = "#c3e88d",
  number       = "#f78c6c",
  constant     = "#ffcb6b",
  type_yellow  = "#ffcb6b",
  fn           = "#82aaff",
  operator     = "#7fdbca",
  preproc      = "#89ddff",
  tag          = "#f07178",
  link         = "#82c8ff",
  error        = "#ff6b6b",
  warning      = "#ffb454",
  info         = "#82aaff",
  hint         = "#7fdbca",
  success      = "#c3e88d",
  user         = "#82dcd2",
  match_bg     = "#3a4a5c",
  label_bg     = "#82aaff",
  none         = "NONE",
}

local hi = function(group, opts)
  opts.default = false
  vim.api.nvim_set_hl(0, group, opts)
end

local link = function(from, to)
  vim.api.nvim_set_hl(0, from, { link = to, default = false })
end

-- Terminal palette (matches the Nightjar editor palette)
vim.g.terminal_color_0  = c.bg_dark
vim.g.terminal_color_1  = c.error
vim.g.terminal_color_2  = c.string
vim.g.terminal_color_3  = c.constant
vim.g.terminal_color_4  = c.fn
vim.g.terminal_color_5  = c.keyword
vim.g.terminal_color_6  = c.hint
vim.g.terminal_color_7  = c.fg
vim.g.terminal_color_8  = c.line_nr
vim.g.terminal_color_9  = "#ff8a8a"
vim.g.terminal_color_10 = "#d7f0a8"
vim.g.terminal_color_11 = "#ffe08a"
vim.g.terminal_color_12 = "#a6c8ff"
vim.g.terminal_color_13 = "#ddb3f5"
vim.g.terminal_color_14 = "#a6f0e2"
vim.g.terminal_color_15 = "#ffffff"

-- Base
hi("Normal",           { fg = c.fg, bg = c.bg })
hi("NormalNC",         { fg = c.fg, bg = c.bg })
hi("NormalFloat",      { fg = c.fg, bg = c.bg_sidebar })
hi("FloatBorder",      { fg = c.border, bg = c.bg_sidebar })
hi("FloatTitle",       { fg = c.keyword, bg = c.bg_sidebar, bold = true })
hi("EndOfBuffer",      { fg = c.bg, bg = c.none })
hi("ColorColumn",      { bg = c.bg_line })
hi("Conceal",          { fg = c.fg_dim, bg = c.none })
hi("Cursor",           { fg = c.bg, bg = c.cursor })
hi("lCursor",          { fg = c.bg, bg = c.cursor })
hi("CursorIM",         { fg = c.bg, bg = c.cursor })
hi("TermCursor",       { fg = c.bg, bg = c.cursor })
hi("CursorColumn",     { bg = c.bg_line })
hi("CursorLine",       { bg = c.bg_line })
hi("Directory",        { fg = c.fn, bold = true })
hi("Error",            { fg = c.error, bg = c.none })
hi("ErrorMsg",         { fg = c.error, bg = c.none })
hi("WarningMsg",       { fg = c.warning, bg = c.none })
hi("ModeMsg",          { fg = c.fg_dim, bg = c.none })
hi("MoreMsg",          { fg = c.success, bg = c.none })
hi("Question",         { fg = c.success, bg = c.none })
hi("SpecialKey",       { fg = c.ws, bg = c.none })
hi("Title",            { fg = c.keyword, bg = c.none, bold = true })
hi("Whitespace",       { fg = c.ws, bg = c.none })
hi("NonText",          { fg = c.ws, bg = c.none })
hi("MatchParen",       { fg = c.hint, bg = c.bg_visual, bold = true })

-- Lines / signs
hi("LineNr",           { fg = c.line_nr, bg = c.bg_dark })
hi("CursorLineNr",     { fg = c.fg, bg = c.bg_line, bold = true })
hi("SignColumn",       { fg = c.fg_dim, bg = c.bg_dark })
hi("Folded",           { fg = c.fg_dim, bg = c.bg_sidebar })
hi("FoldColumn",       { fg = c.border, bg = c.bg_dark })
hi("WinSeparator",     { fg = c.border, bg = c.bg })
link("VertSplit", "WinSeparator")

-- Selection / search
hi("Visual",           { bg = c.bg_visual })
hi("VisualNOS",        { bg = c.bg_visual })
hi("Search",           { fg = c.fg, bg = c.match_bg })
hi("IncSearch",        { fg = c.bg, bg = c.warning, bold = true })
hi("CurSearch",        { fg = c.bg, bg = c.warning, bold = true })
hi("Substitute",       { fg = c.bg, bg = c.warning })

-- UI chrome
hi("StatusLine",       { fg = c.fg, bg = c.bg_status })
hi("StatusLineNC",     { fg = c.fg_dim, bg = c.bg_sidebar })
hi("TabLine",          { fg = c.fg_dim, bg = c.bg_dark })
hi("TabLineFill",      { bg = c.bg_sidebar })
hi("TabLineSel",       { fg = c.fg, bg = c.bg_title, bold = true })
hi("Pmenu",            { fg = c.fg, bg = c.bg_sidebar })
hi("PmenuSel",         { fg = c.fg, bg = c.bg_activity, bold = true })
hi("PmenuSbar",        { bg = c.bg_sidebar })
hi("PmenuThumb",       { bg = c.border })
hi("WildMenu",         { fg = c.bg, bg = c.keyword })
hi("WinBar",           { fg = c.fg_dim, bg = c.bg })
hi("WinBarNC",         { fg = c.fg_dim, bg = c.bg })
hi("QuickFixLine",     { bg = c.bg_activity })

-- Diffs
hi("DiffAdd",          { fg = c.string, bg = "#1b2e22" })
hi("DiffChange",       { fg = c.warning, bg = "#1e2b3a" })
hi("DiffDelete",       { fg = c.error, bg = "#3a1d24" })
hi("DiffText",         { fg = c.bg, bg = c.warning, bold = true })
hi("Added",            { fg = c.string })
hi("Changed",          { fg = c.warning })
hi("Removed",          { fg = c.error })

-- Spelling
hi("SpellBad",   { fg = c.error, underline = true, sp = c.error })
hi("SpellCap",   { fg = c.info, underline = true, sp = c.info })
hi("SpellLocal", { fg = c.hint, underline = true, sp = c.hint })
hi("SpellRare",  { fg = c.keyword, underline = true, sp = c.keyword })

-- Diagnostics
hi("DiagnosticError", { fg = c.error })
hi("DiagnosticWarn",  { fg = c.warning })
hi("DiagnosticInfo",  { fg = c.info })
hi("DiagnosticHint",  { fg = c.hint })
hi("DiagnosticOk",    { fg = c.success })
hi("DiagnosticVirtualTextError", { fg = c.error, bg = "#3a1f24" })
hi("DiagnosticVirtualTextWarn",  { fg = c.warning, bg = "#3d2718" })
hi("DiagnosticVirtualTextInfo",  { fg = c.info, bg = "#1b2c3d" })
hi("DiagnosticVirtualTextHint",  { fg = c.hint, bg = "#172b2c" })
hi("DiagnosticVirtualTextOk",    { fg = c.success, bg = "#1b2e22" })
hi("DiagnosticUnderlineError",   { underline = true, sp = c.error })
hi("DiagnosticUnderlineWarn",    { underline = true, sp = c.warning })
hi("DiagnosticUnderlineInfo",    { underline = true, sp = c.info })
hi("DiagnosticUnderlineHint",    { underline = true, sp = c.hint })
hi("DiagnosticUnderlineOk",      { underline = true, sp = c.success })
hi("DiagnosticFloatingError",    { fg = c.error, bg = c.bg_sidebar })
hi("DiagnosticFloatingWarn",     { fg = c.warning, bg = c.bg_sidebar })
hi("DiagnosticFloatingInfo",     { fg = c.info, bg = c.bg_sidebar })
hi("DiagnosticFloatingHint",     { fg = c.hint, bg = c.bg_sidebar })
hi("DiagnosticFloatingOk",       { fg = c.success, bg = c.bg_sidebar })
hi("DiagnosticSignError",        { fg = c.error, bg = c.bg_dark })
hi("DiagnosticSignWarn",         { fg = c.warning, bg = c.bg_dark })
hi("DiagnosticSignInfo",         { fg = c.info, bg = c.bg_dark })
hi("DiagnosticSignHint",         { fg = c.hint, bg = c.bg_dark })
hi("DiagnosticSignOk",           { fg = c.success, bg = c.bg_dark })

-- Syntax
hi("Comment",        { fg = c.comment, italic = true })
hi("Constant",       { fg = c.constant })
hi("String",         { fg = c.string })
hi("Character",      { fg = c.type_yellow })
hi("Number",         { fg = c.number })
hi("Boolean",        { fg = c.number })
hi("Float",          { fg = c.number })
hi("Identifier",     { fg = c.fg })
hi("Function",       { fg = c.fn })
hi("Statement",      { fg = c.keyword })
hi("Conditional",    { fg = c.keyword })
hi("Repeat",         { fg = c.keyword })
hi("Label",          { fg = c.type_yellow })
hi("Operator",       { fg = c.operator })
hi("Keyword",        { fg = c.keyword })
hi("Exception",      { fg = c.error, bold = true })
hi("PreProc",        { fg = c.preproc })
hi("Include",        { fg = c.preproc })
hi("Define",         { fg = c.preproc })
hi("Macro",          { fg = c.preproc })
hi("PreCondit",      { fg = c.preproc })
hi("Type",           { fg = c.type_yellow })
hi("StorageClass",   { fg = c.keyword })
hi("Structure",      { fg = c.type_yellow })
hi("Typedef",        { fg = c.type_yellow })
hi("Special",        { fg = c.preproc })
hi("SpecialChar",    { fg = c.type_yellow })
hi("Tag",            { fg = c.tag })
hi("Delimiter",      { fg = c.operator })
hi("SpecialComment", { fg = c.doc_comment, italic = true })
hi("Debug",          { fg = c.error })
hi("Underlined",     { fg = c.link, underline = true })
hi("Bold",           { bold = true })
hi("Italic",         { italic = true })
hi("Todo",           { fg = c.bg, bg = c.warning, bold = true })

-- Treesitter
link("@comment", "Comment")
link("@comment.documentation", "SpecialComment")
link("@string", "String")
link("@string.documentation", "String")
link("@string.escape", "SpecialChar")
link("@string.regexp", "Number")
link("@string.special", "SpecialChar")
link("@string.special.symbol", "Constant")
link("@character", "Character")
link("@character.special", "SpecialChar")
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
link("@keyword.import", "Include")
link("@keyword.type", "StorageClass")
link("@keyword.modifier", "StorageClass")
link("@keyword.repeat", "Repeat")
link("@keyword.return", "Keyword")
link("@keyword.conditional", "Conditional")
link("@keyword.exception", "Exception")
link("@exception", "Exception")
link("@punctuation.bracket", "Delimiter")
link("@punctuation.delimiter", "Delimiter")
link("@punctuation.special", "Special")
link("@variable", "Identifier")
hi("@variable.builtin", { fg = c.hint })
link("@variable.parameter", "Identifier")
link("@variable.member", "Identifier")
link("@function", "Function")
link("@function.builtin", "Function")
link("@function.macro", "Macro")
link("@function.call", "Function")
link("@method", "Function")
link("@method.call", "Function")
link("@constructor", "Type")
link("@type", "Type")
link("@type.builtin", "Type")
link("@type.qualifier", "StorageClass")
link("@property", "Identifier")
link("@field", "Identifier")
link("@namespace", "Type")
link("@attribute", "PreProc")
link("@tag", "Tag")
link("@tag.attribute", "Type")
link("@tag.delimiter", "Delimiter")
link("@text.title", "Title")
link("@text.literal", "String")
link("@text.uri", "Underlined")
link("@text.reference", "Underlined")
hi("@text.emphasis", { italic = true })
hi("@text.strong", { bold = true })
hi("@text.strike", { strikethrough = true })
link("@text.diff.add", "DiffAdd")
link("@text.diff.delete", "DiffDelete")
link("@markup.heading", "Title")
link("@markup.link", "Underlined")
link("@markup.link.label", "Underlined")
link("@markup.link.url", "Underlined")
link("@markup.raw", "String")
link("@markup.raw.block", "String")
hi("@markup.italic", { italic = true })
hi("@markup.bold", { bold = true })
hi("@markup.strikethrough", { strikethrough = true })
link("@markup.quote", "Comment")
link("@markup.list", "Operator")
link("@diff.plus", "DiffAdd")
link("@diff.minus", "DiffDelete")
link("@diff.delta", "DiffChange")
link("@spell", "SpellBad")
link("@nospell", "Normal")

-- LSP semantic tokens
link("@lsp.type.namespace", "@namespace")
link("@lsp.type.class", "@type")
link("@lsp.type.enum", "@type")
link("@lsp.type.interface", "@type")
link("@lsp.type.struct", "@type")
link("@lsp.type.parameter", "@variable.parameter")
link("@lsp.type.variable", "@variable")
link("@lsp.type.property", "@property")
link("@lsp.type.function", "@function")
link("@lsp.type.method", "@method")
link("@lsp.type.macro", "@function.macro")
link("@lsp.type.decorator", "PreProc")
link("@lsp.type.builtinType", "@type.builtin")

-- Legacy vim-regex fallback
link("luaFunction", "Function")
link("luaFuncCall", "Function")

-- Perl-specific highlights
link("perlPackageRef", "Type")
link("perlPackage", "Type")
link("perlPackageDecl", "Type")
hi("perlPOD", { fg = c.comment, italic = true })
hi("podCommand", { fg = c.keyword })
hi("podCmdText", { fg = c.comment, italic = true })
hi("podOrdinary", { fg = c.fg })
link("podVerbatim", "String")
hi("podSpecial", { fg = c.number })
link("podTodo", "Todo")
link("podFormat", "Special")
link("perlHereDoc", "String")
link("perlHereDocStart", "Delimiter")
link("perlIndentedHereDoc", "String")
hi("perlMatch", { fg = c.number })
hi("perlMatchStartEnd", { fg = c.number })
hi("perlSpecialMatch", { fg = c.number })

-- Raku (Perl 6) -- filetype raku
link("rakuPackage", "Type")
hi("rakuPackageScope", { fg = c.keyword })
hi("rakuTwigil", { fg = c.number })
hi("rakuBareSigil", { fg = c.number })
link("rakuVariable", "Identifier")
link("rakuVarName", "Identifier")
link("rakuVarStorage", "Identifier")
hi("rakuVarExclam", { fg = c.keyword })
link("rakuIdentifier", "Identifier")
link("rakuType", "Type")
hi("rakuTypeConstraint", { fg = c.type_yellow })
hi("rakuDeclare", { fg = c.keyword })
hi("rakuDeclareRegex", { fg = c.keyword })
link("rakuConditional", "Conditional")
link("rakuException", "Exception")
hi("rakuFlowControl", { fg = c.keyword })
link("rakuClosureTrait", "Identifier")
link("rakuContext", "Operator")
link("rakuHyperOp", "Operator")
link("rakuOperator", "Operator")
link("rakuSetOp", "Operator")
hi("rakuBlockLabel", { fg = c.keyword })
link("rakuNumber", "Number")
hi("rakuVersion", { fg = c.number })
link("rakuInclude", "Include")
link("rakuString", "String")
link("rakuStringDQ", "String")
link("rakuStringSQ", "String")
link("rakuStringQ", "String")
link("rakuStringAngle", "String")
hi("rakuStringSpecial", { fg = c.number })
hi("rakuStringSpecial2", { fg = c.number })
link("rakuKey", "String")
hi("rakuShebang", { fg = c.comment, italic = true })
hi("rakuMatch", { fg = c.number })
hi("rakuMatchBare", { fg = c.number })
link("rakuMatchVar", "Identifier")
hi("rakuSubstitution", { fg = c.number })
hi("rakuTransliteration", { fg = c.number })
hi("rakuRxMeta", { fg = c.keyword })
hi("rakuRxAnchor", { fg = c.keyword })
hi("rakuRxCharClass", { fg = c.number })
hi("rakuRxAssertGroup", { fg = c.number })
hi("rakuPod", { fg = c.comment, italic = true })
link("rakuPodFormat", "Special")
link("rakuPodCode", "String")
hi("rakuPodComment", { fg = c.comment, italic = true })
hi("rakuPodDelim", { fg = c.keyword })
link("rakuAttention", "Todo")
link("rakuError", "Error")

-- Telescope
hi("TelescopeNormal",        { fg = c.fg, bg = c.bg_sidebar })
hi("TelescopeBorder",        { fg = c.border, bg = c.bg_sidebar })
hi("TelescopeTitle",         { fg = c.bg, bg = c.keyword, bold = true })
hi("TelescopePromptTitle",   { fg = c.bg, bg = c.keyword, bold = true })
hi("TelescopeResultsTitle",  { fg = c.bg, bg = c.fn, bold = true })
hi("TelescopePreviewTitle",  { fg = c.bg, bg = c.string, bold = true })
hi("TelescopeSelection",     { fg = c.fg, bg = c.bg_activity })
hi("TelescopeSelectionCaret", { fg = c.keyword })
hi("TelescopeMatching",      { fg = c.link, bold = true })
hi("TelescopePromptPrefix",  { fg = c.keyword })
hi("TelescopeResultsIdentifier", { fg = c.fn })
hi("TelescopeResultsComment", { fg = c.comment, italic = true })
hi("TelescopeResultsDiffAdd", { fg = c.string })
hi("TelescopeResultsDiffChange", { fg = c.warning })
hi("TelescopeResultsDiffDelete", { fg = c.error })

-- Neo-tree
hi("NeoTreeNormal",          { fg = c.fg, bg = c.bg })
hi("NeoTreeNormalNC",        { fg = c.fg, bg = c.bg })
hi("NeoTreeWinSeparator",    { fg = c.border, bg = c.bg })
hi("NeoTreeDirectoryName",   { fg = c.fn })
hi("NeoTreeDirectoryIcon",   { fg = c.fn })
hi("NeoTreeFileName",        { fg = c.fg })
hi("NeoTreeFileIcon",        { fg = c.fg_dim })
hi("NeoTreeRootName",        { fg = c.keyword, bold = true })
hi("NeoTreeGitAdded",        { fg = c.success })
hi("NeoTreeGitModified",     { fg = c.warning })
hi("NeoTreeGitDeleted",      { fg = c.error })
hi("NeoTreeGitUntracked",    { fg = c.fg_dim })
hi("NeoTreeIndentMarker",    { fg = c.ws })
hi("NeoTreeExpander",        { fg = c.fg_dim })
hi("NeoTreeSymbolicLinkTarget", { fg = c.link })

-- Snacks (picker, notifier, indent guides, terminal)
hi("SnacksPickerNormal",     { fg = c.fg, bg = c.bg_sidebar })
hi("SnacksPickerBorder",     { fg = c.border, bg = c.bg_sidebar })
hi("SnacksPickerTitle",      { fg = c.bg, bg = c.keyword, bold = true })
hi("SnacksPickerPrompt",     { fg = c.keyword })
hi("SnacksPickerInput",      { fg = c.fg, bg = c.bg_dark })
hi("SnacksPickerList",       { fg = c.fg, bg = c.bg_sidebar })
hi("SnacksPickerSelection",  { fg = c.fg, bg = c.bg_activity })
hi("SnacksPickerMatch",      { fg = c.link, bold = true })
hi("SnacksPickerDir",        { fg = c.fn })
hi("SnacksPickerFile",       { fg = c.fg })
hi("SnacksNotifierInfo",     { fg = c.info })
hi("SnacksNotifierWarn",     { fg = c.warning })
hi("SnacksNotifierError",    { fg = c.error })
hi("SnacksNotifierDebug",    { fg = c.fg_dim })
hi("SnacksNotifierTrace",    { fg = c.keyword })
hi("SnacksIndent",           { fg = c.ws })
hi("SnacksIndentScope",      { fg = c.border })
hi("SnacksIndentChunk",      { fg = c.border })

-- blink.cmp
hi("BlinkCmpMenu",           { fg = c.fg, bg = c.bg_sidebar })
hi("BlinkCmpMenuBorder",     { fg = c.border, bg = c.bg_sidebar })
hi("BlinkCmpMenuSelection",  { fg = c.fg, bg = c.bg_activity })
hi("BlinkCmpLabel",          { fg = c.fg })
hi("BlinkCmpLabelMatch",     { fg = c.link, bold = true })
hi("BlinkCmpLabelDescription", { fg = c.fg_dim })
hi("BlinkCmpKind",           { fg = c.fn })
hi("BlinkCmpKindFunction",   { fg = c.fn })
hi("BlinkCmpKindMethod",     { fg = c.fn })
hi("BlinkCmpKindVariable",   { fg = c.fg })
hi("BlinkCmpKindKeyword",    { fg = c.keyword })
hi("BlinkCmpKindClass",      { fg = c.type_yellow })
hi("BlinkCmpKindInterface",  { fg = c.type_yellow })
hi("BlinkCmpKindStruct",     { fg = c.type_yellow })
hi("BlinkCmpKindModule",     { fg = c.type_yellow })
hi("BlinkCmpKindSnippet",    { fg = c.user })
hi("BlinkCmpDoc",            { fg = c.fg, bg = c.bg_sidebar })
hi("BlinkCmpDocBorder",      { fg = c.border, bg = c.bg_sidebar })
hi("BlinkCmpSignatureHelp",  { fg = c.fg, bg = c.bg_sidebar })
hi("BlinkCmpSignatureHelpBorder", { fg = c.border, bg = c.bg_sidebar })

-- Which-key
hi("WhichKey",         { fg = c.keyword })
hi("WhichKeyGroup",    { fg = c.fn })
hi("WhichKeyDesc",     { fg = c.fg })
hi("WhichKeyFloat",    { bg = c.bg_sidebar })
hi("WhichKeySeparator", { fg = c.fg_dim })
hi("WhichKeyValue",    { fg = c.fg_dim })

-- Dashboard
hi("DashboardHeader",   { fg = c.keyword, bold = true })
hi("DashboardCenter",   { fg = c.fg })
hi("DashboardShortcut", { fg = c.link })
hi("DashboardFooter",   { fg = c.fg_dim, italic = true })

-- Git signs / diffview / fugitive
hi("GitSignsAdd",       { fg = c.success })
hi("GitSignsChange",    { fg = c.warning })
hi("GitSignsDelete",    { fg = c.error })
hi("GitSignsAddNr",     { fg = c.success })
hi("GitSignsChangeNr",  { fg = c.warning })
hi("GitSignsDeleteNr",  { fg = c.error })
hi("diffAdded",         { fg = c.success })
hi("diffRemoved",       { fg = c.error })
hi("diffChanged",       { fg = c.warning })
hi("DiffviewNormal",    { fg = c.fg, bg = c.bg })
hi("DiffviewFilePanelTitle", { fg = c.keyword, bold = true })
hi("DiffviewFilePanelCounter", { fg = c.link })
hi("DiffviewFilePanelFileName", { fg = c.fg })

-- DAP
hi("DapBreakpoint",        { fg = c.error })
hi("DapBreakpointCondition", { fg = c.warning })
hi("DapLogPoint",          { fg = c.info })
hi("DapStopped",           { fg = c.warning })
hi("DapUIVariable",        { fg = c.fg })
hi("DapUIScope",           { fg = c.keyword })
hi("DapUIType",            { fg = c.type_yellow })
hi("DapUIValue",           { fg = c.fg })
hi("DapUIModifiedValue",   { fg = c.warning, bold = true })
hi("DapUIDecoration",      { fg = c.border })
hi("DapUIThread",          { fg = c.success })
hi("DapUIStoppedThread",   { fg = c.warning })
hi("DapUIFrameName",       { fg = c.fg })
hi("DapUISource",          { fg = c.link })
hi("DapUILineNumber",      { fg = c.fg_dim })
hi("DapUIFloatBorder",     { fg = c.border, bg = c.bg_sidebar })
hi("DapUIWatchesEmpty",    { fg = c.error })

-- Navic
hi("NavicText",            { fg = c.fg_dim })
hi("NavicSeparator",       { fg = c.fg_dim })

-- mini.icons
hi("MiniIconsAzure",  { fg = c.info })
hi("MiniIconsBlue",   { fg = c.fn })
hi("MiniIconsCyan",   { fg = c.hint })
hi("MiniIconsGreen",  { fg = c.success })
hi("MiniIconsGrey",   { fg = c.fg_dim })
hi("MiniIconsOrange", { fg = c.number })
hi("MiniIconsPurple", { fg = c.keyword })
hi("MiniIconsRed",    { fg = c.error })
hi("MiniIconsYellow", { fg = c.warning })

-- render-markdown.nvim
hi("RenderMarkdownH1", { fg = c.keyword, bold = true })
hi("RenderMarkdownH2", { fg = c.fn, bold = true })
hi("RenderMarkdownH3", { fg = c.hint, bold = true })
hi("RenderMarkdownH4", { fg = c.type_yellow, bold = true })
hi("RenderMarkdownH5", { fg = c.number, bold = true })
hi("RenderMarkdownH6", { fg = c.string, bold = true })
hi("RenderMarkdownCode", { bg = c.bg_code })
hi("RenderMarkdownQuote", { fg = c.comment, italic = true })
hi("RenderMarkdownBullet", { fg = c.keyword })

-- ToggleTerm
hi("ToggleTerm1", { fg = c.keyword })
hi("ToggleTerm2", { fg = c.fn })
hi("ToggleTerm3", { fg = c.hint })
hi("ToggleTerm4", { fg = c.type_yellow })
hi("ToggleTerm5", { fg = c.number })
hi("ToggleTerm6", { fg = c.string })

local opt = vim.opt

-- Tab / Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true  -- use spaces instead of tabs
opt.smartindent = true  -- autoindent new lines
opt.autoindent = true -- copy indent from current line when starting a new line

-- Enable break indent
opt.breakindent = true

-- line numbers
opt.number = true -- show line numbers
opt.relativenumber = true -- show relative line numbers
opt.numberwidth = 2 -- set number column width to 2 {default 4}
opt.ruler = true -- show the cursor position all the time

-- sign column
--opt.signcolumn = "auto" -- only show signcolumn when needed
opt.signcolumn = "yes" -- always show the signcolumn to prevent shifting


-- disable line wrap
opt.wrap = false


-- Better buffer navigation
opt.scrolloff = 8 -- minimum number of lines to keep above and below the cursor
opt.sidescrolloff = 4 -- minimum number of columns to keep to the left and right of the cursor

-- Enable mouse mode
opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
opt.clipboard:append('unnamedplus')


-- Search Settings
opt.incsearch = true -- show matches as you type
opt.hlsearch = true -- highlight all matches
opt.wrapscan = true -- searches wrap around the end of the file
opt.ignorecase = true -- case-insensitive searching UNLESS \C or capital in search
opt.smartcase = true -- case-sensitive if uppercase in search expression

opt.grepprg = "rg --vimgrep" -- Use ripgrep if available
opt.grepformat = "%f:%l:%c:%m" -- filename, line number, column, content



-- show matching braces
opt.showmatch = true

-- show the status line all the time
opt.laststatus=2

opt.wildmenu = true -- Enable command-line completion menu
opt.wildmode = "list:longest"
--opt.wildmode = "longest:full,full" -- Completion mode for command-line
opt.wildignorecase = true -- Case-insensitive tab completion in commands


opt.cmdheight = 1 -- command line height
-- opt.cmdheight = 2 -- more space for displaying messages


-- spell checking
opt.spell = true -- enable spell checking
opt.spelllang = "en" -- set spell check language
opt.iskeyword:append("-") -- treat dashes as part of words

-- make sure your terminal supports this
opt.termguicolors = true

-- set backgrounds to dark
opt.background = "dark"

opt.title = true -- set the terminal title to the value of the titlestring
opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title will be set to

-- highlight color column
opt.colorcolumn = "100"

-- highlight current line
opt.cursorline = true

-- Decrease update time
opt.updatetime = 300 -- faster completion (4000ms default)
opt.timeoutlen = 500 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.ttimeoutlen = 10 -- time to wait for a key code sequence to complete (in milliseconds)
opt.lazyredraw = false -- redraw while executing macros (butter UX)
opt.redrawtime = 10000 -- Timeout for syntax highlighting redraw

opt.autoread = true -- automatically read a file when it is changed from the outside
opt.autowrite = false -- automatically write a file when leaving it

-- Better diff
opt.diffopt:append("vertical") -- open diffs in vertical splits
opt.diffopt:append("iwhite") -- ignore whitespace changes
opt.diffopt:append("algorithm:patience") -- better diff algorithm
opt.diffopt:append("linematch:60") -- better diff algorithm

opt.hidden = true -- allow buffer switching without saving
opt.errorbells = false -- disable error bells
opt.visualbell = false -- disable visual bells


-- File backups
-- disable backup files
opt.backup = false
opt.writebackup = false
-- disable swap files
opt.swapfile = false

-- undo
opt.undofile = true -- enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.encoding = "UTF-8" -- Use UTF-8 encoding

-- cursor
opt.guicursor = {
  "n:block",          -- normal mode: block (Windows-like)
  "i:ver25",          -- insert mode: vert beam
  "ci:ver25",         -- command-insert, visual: vert beam
  "ve:ver25",         -- visual: vert beam
  "r-cr:hor20",       -- replace, command-replace: horizontal bar
  "o:hor50",          -- operator-pending: thicker bar
}

-- disable showmode because lualine already displays mode
opt.showmode = false

-- allow backspacing over everything in insert mode
opt.backspace = "indent,eol,start"

-- split window behavior
opt.splitright = true -- vertical splits will automatically be to the right
opt.splitbelow = true -- horizontal splits will automatically be below

-- don't change the working directory when opening a file
opt.autochdir = false
opt.path:append("**") -- Search into subfolders with `gf`

-- Set completeopt to have a better completion experience
--opt.completeopt = 'menuone,noselect'
opt.completeopt = 'menuone,noinsert,noselect'

opt.pumheight = 10 -- Popup menu height
opt.pumblend = 10 -- Popup menu transparency
opt.winblend = 0 -- Floating window transparency

-- folds
opt.foldmethod = "expr" -- fold based on expression
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
opt.foldlevel = 99 -- start with all folds open
opt.foldlevelstart = 99 -- start with all folds open




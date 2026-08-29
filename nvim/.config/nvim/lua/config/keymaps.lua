local opts = { noremap = true, silent = true }

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- clear highlights from searches
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- Netrw keymaps (replaced by neo-tree)
-- vim.keymap.set('n', '<leader>E', ':E<CR>', { desc = '[E]xplore' })
-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "[E]xplore"} )

-- pageup/pagedown
-- Auto centre after page up and down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set({ 'n', 'v'}, '<PageUp>', '<C-u>')
vim.keymap.set({ 'n', 'v'}, '<PageDown>', '<C-d>')

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Move Lines
vim.keymap.set({ 'n', 'x' }, '<M-S-Up>', ':move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set({ 'n', 'x' }, '<M-S-Down>', ':move +1<cr>', { desc = 'Move Line Down' })
vim.keymap.set('i', '<M-S-Up>', '<C-o>:move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set('i', '<M-S-Down>', '<C-o>:move +1<cr>', { desc = 'Move Line Down' })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- fix home/end keys in all modes
--nmap OH <home>
--cmap OH <home>
--imap OH <home>
--" move cursor one more char to right in normal mode
--nmap OF <end>l
--cmap OF <end>
--imap OF <end>

-- Insert mode: emacs-like navigation (Ctrl-A, Ctrl-E)
--imap('<c-a>', '<c-o>^', { silent = true })  -- beginning-of-line
--imap('<c-e>', '<c-o>$', { silent = true })  -- end-of-line
--imap('<c-b>', '<c-o>B', { silent = true })  -- words backward
--imap('<c-f>', '<c-o>W', { silent = true })  -- words forward

-- Ctrl-A moves cursor to beginning of line
vim.keymap.set("i", "<C-a>", "<C-o>^", { silent = true })

-- Ctrl-E closes Blink's completion menu when visible; otherwise it moves to the line end.
vim.keymap.set("i", "<C-e>", function()
	local blink = require("blink.cmp")

	if blink.is_visible() then
		blink.hide()
		return ""
	end

	return "<C-o>$"
end, { expr = true, silent = true })

-- Ctrl-A moves cursor by words forwards
vim.keymap.set("i", "<C-f>", "<C-o>W", { silent = true })

-- Ctrl-B moves cursor by words backwards
vim.keymap.set("i", "<C-b>", "<C-o>B", { silent = true })
-- end of Insert mode: emacs-line navigation

-- Prevent x and the delete key from overriding what's in the clipboard.
vim.keymap.set({ "n", "x", "s", "o" }, "x", '"_x')
vim.keymap.set({ "n", "x", "s", "o" }, "X", '"_x')
vim.keymap.set({ "n", "x", "s", "o" }, "<Del>", '"_x')

-- Prevent selecting and pasting from overwriting what you originally copied.
vim.keymap.set("x", "p", "pgvy")

-- Keep navigation centered while searching
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- vim.keymap.set('n', 'G', 'Gzz')

-- Navigating Buffer keymaps
vim.keymap.set('n', '<leader>bb', '<C-^>',   { desc = 'Switch to alternate buffer' })
vim.keymap.set('n', '<leader>bn', ':bn<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', ':bp<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = '[B]uffer [D]elete' })

-- Navigate vim panes better
-- already set in tmux-navigator
--vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
--vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
--vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
--vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')


-- Easier interaction with the system clipboard
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard after the cursor position' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard before the cursor position' })

-- window management
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) -- split window vertically
vim.keymap.set("n", "<leader>sh", ":split<CR>", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts)      -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", ":close<CR>", opts) -- close current split window
vim.keymap.set("n", "<leader>so", ":only<CR>", opts)    -- close all but current window
-- maximize window: <leader>sm
-- configured in maximize plugin
-- in traditional neovim setup, would be:
--vim.keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", opts) -- toggle maximize window

-- Indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = 'Indent left and reselect' })
vim.keymap.set("v", ">", ">gv", { desc = 'Indent right and reselect' })

-- commenting
-- uses a comments plugin
vim.keymap.set({"n", "v"}, "<C-_>", "gcc", { noremap = false })

-- Use Shift H and Shift L to move to beginning and end of line
vim.keymap.set("n", "<s-h>", "0", { noremap = true })
vim.keymap.set("n", "<s-l>", "$l", { noremap = true })

-- increment/decrement
vim.keymap.set("n", "+", "<C-a>", { noremap = true })
vim.keymap.set("n", "-", "<C-x>", { noremap = true })

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- move cursor to empty space at end of line
vim.opt.virtualedit:append("onemore")
vim.keymap.set("n", "$", "$l", { noremap = true })

-- Allow gf to edit files that do not exist yet.
vim.keymap.set("n", "gf", function()
	local file = vim.fn.expand("<cfile>")
	vim.cmd.edit(vim.fn.fnameescape(file))
end, { desc = "Edit file under cursor" })

-- python/perl/bash comments
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"python", "perl", "sh", "bash", "zsh", "fish", "ruby", "yaml", "toml",
		"dosini", "gitconfig", "make", "dockerfile", "terraform", "nix", "julia",
		"r", "crystal", "nim", "elixir",
	},
	callback = function(args)
		vim.keymap.set({ "n", "v", "o" }, "#", [=[!!perl -pe'm{^\# ?}?s{^\#}{}:m{\S}?s{^}{\#}:1'<CR><LF>]=], { buffer = args.buf })
	end,
})

-- -----------------------------------------------------------------------------
-- Abbreviations
-- -----------------------------------------------------------------------------

-- Create a safe command-line abbreviation that expands only for an exact Ex command.
local function command_abbreviation(from, to)
	vim.keymap.set("c", from, function()
		if vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == from then
			return to
		end

		return from
	end, { expr = true })
end

-- common misspells
command_abbreviation("WQ", "wq")
command_abbreviation("Wq", "wq")
command_abbreviation("W", "w")
command_abbreviation("Q", "q")
command_abbreviation("Qa", "qa")
command_abbreviation("QA", "qa")
command_abbreviation("Wqa", "wqa")
command_abbreviation("WQa", "wqa")
command_abbreviation("WQA", "wqa")
command_abbreviation("Vimrc", "e $MYVIMRC<CR>")
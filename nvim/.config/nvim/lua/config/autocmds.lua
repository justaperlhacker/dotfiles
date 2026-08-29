
-- highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Ensure tabs don't get converted to spaces in Makefiles.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function(args)
    vim.bo[args.buf].expandtab = false
  end,
})

-- allow '-' to open the parent directory in netrw
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function(args)
		vim.keymap.set("n", "-", "<cmd>edit %:h<CR>", { buffer = args.buf, silent = true })
	end,
})

-- -- auto-format on save
-- local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = lsp_fmt_group,
-- 	callback = function()
-- 		local efm = vim.lsp.get_active_clients({ name = "efm" })

-- 		if vim.tbl_isempty(efm) then
-- 			return
-- 		end

-- 		vim.lsp.buf.format({ name = "efm", async = true })
-- 	end,
-- })

-- disable cursorline for telescope plugin
--au FileType Telescope setlocal nocursorline

-- Only show the cursor line in the active buffer.
  -- augroup CursorLine
  --    au!
  --    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  --    au WinLeave * setlocal nocursorline
  -- augroup END

-- show cursor line only in active window
-- note: this has been replaced with reticle.nvim plugin.
-- vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
--   callback = function()
--     local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
--     if ok and cl then
--       vim.wo.cursorline = true
--       vim.api.nvim_win_del_var(0, "auto-cursorline")
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
--   callback = function()
--     local cl = vim.wo.cursorline
--     if cl then
--       vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
--       vim.wo.cursorline = false
--     end
--   end,
-- })

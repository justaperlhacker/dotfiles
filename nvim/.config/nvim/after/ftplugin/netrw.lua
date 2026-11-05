-- '-' opens the parent directory
vim.keymap.set("n", "-", "<cmd>edit %:h<CR>", { buffer = true, silent = true })

-- Neovim doesn't detect c3 by extension; declaring both here (plus zig for
-- consistency) keeps detection guaranteed across Neovim versions.
vim.filetype.add({
	extension = {
		zig = "zig",
		zir = "zir",
		c3 = "c3",
		c3t = "c3", -- c3 translation unit dump
	},
})

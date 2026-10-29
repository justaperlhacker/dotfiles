
-- must set mapleader before loading plugins
-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 1
vim.g.netrw_winsize = 25

-- disable netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Use the recommended YAML style (2-space shiftwidth/softtabstop, spaces).
-- Read by $VIMRUNTIME/ftplugin/yaml.vim; set explicitly so it survives
-- any future default change. YAML forbids tabs for indentation.
vim.g.yaml_recommended_style = 1

--JetBrainsMono Nerd Font:h12
-- font for neovide
vim.o.guifont = "JetBrainsMono NF Medium:h12"

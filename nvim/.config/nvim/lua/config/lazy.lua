local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local colors = require("config.colors")

require("lazy").setup("plugins", {})

local ok, err = pcall(vim.cmd.colorscheme, colors.name)
if not ok then
  vim.notify("[lazy.lua] colorscheme '" .. tostring(colors.name) .. "' failed: " .. tostring(err))
  vim.cmd.colorscheme(colors.fallback)
end

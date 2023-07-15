local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

local configpath = vim.fn.stdpath("config")

require("lazy").setup(dofile(configpath .. "/plugins.lua"))

vim.cmd("source " .. configpath .. "/config.vim")
dofile(configpath .. "/config.lua")

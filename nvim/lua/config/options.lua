-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
opt.wrap = true
opt.conceallevel = 0

-- disable LSP log to avoid infinitely growing log file
vim.lsp.set_log_level("off")

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell_neogit"),
  pattern = { "NeogitCommitMessage" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- set tabs in Makefiles
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("tab_makefile"),
  pattern = { "make" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 8
    vim.opt_local.softtabstop = 0
  end,
})

-- wrap and check for spell in Markdown filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  group = augroup("wrap_spell_markdown"),
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

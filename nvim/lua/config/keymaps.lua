-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local api = vim.api

local function map(mode, shortcut, command, options)
  options = vim.tbl_extend("keep", options or {}, { noremap = true, silent = true, expr = false })
  api.nvim_set_keymap(mode, shortcut, command, options)
end

local function nmap(shortcut, command, options)
  map("n", shortcut, command, options)
end

local function imap(shortcut, command, options)
  map("i", shortcut, command, options)
end

local function vmap(shortcut, command, options)
  map("v", shortcut, command, options)
end

local function cmap(shortcut, command, options)
  map("c", shortcut, command, options)
end

local function tmap(shortcut, command, options)
  map("t", shortcut, command, options)
end

local function omap(shortcut, command, options)
  map("o", shortcut, command, options)
end

-- mapping

--- swap colon with semicolon
nmap(";", ":", { noremap = true, silent = false, expr = false })
nmap(":", ";", { noremap = true, silent = false, expr = false })
vmap(";", ":", { noremap = true, silent = false, expr = false })
vmap(":", ";", { noremap = true, silent = false, expr = false })

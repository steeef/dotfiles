-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--- swap colon with semicolon
map({"n", "v"}, ";", ":", { noremap = true, silent = false, expr = false })
map({"n", "v"}, ":", ";", { noremap = true, silent = false, expr = false })

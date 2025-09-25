-- Compatibility shim for LazyVim's outdated Catppuccin bufferline integration
-- This provides the old path that LazyVim expects, redirecting to the new location
--
-- Related: https://github.com/LazyVim/LazyVim/issues/6522
-- Remove this file when LazyVim fixes their colorscheme.lua

return require("catppuccin.special.bufferline")

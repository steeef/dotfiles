local api, cmd, g = vim.api, vim.cmd, vim.g

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- plugins with paq
require 'paq-nvim' {
  'savq/paq-nvim';
  'norcalli/nvim-base16.lua';
  {'nvim-treesitter/nvim-treesitter', run=function() vim.cmd 'TSUpdate' end};
}

-- options

--- colorscheme
local base16 = require 'base16'
base16(base16.themes['tomorrow-night'], true)

-- mapping

--- set leader to space
map('', '<Space>', '<Nop>', {silent = true})
g.mapleader = " "
g.maplocalleader = " "

---- swap colon with semicolon
map('n', ';', ':')
map('n', ':', ';')
map('v', ';', ':')
map('v', ':', ';')

--- new vertical window
map('n', '<leader>w', '<Cmd>botright vnew<CR>', {silent = true})

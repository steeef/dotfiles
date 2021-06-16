local api, cmd, g = vim.api, vim.cmd, vim.g

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- plugins with paq
require 'paq-nvim' {
  'savq/paq-nvim';
  {'nvim-treesitter/nvim-treesitter', run=function() vim.cmd 'TSUpdate' end};
}


-- mapping

---- set leader to space
map('', '<Space>', '<Nop>', {silent = true})
g.mapleader = " "
g.maplocalleader = " "

---- swap colon with semicolon
map('n', ';', ':')
map('n', ':', ';')
map('v', ';', ':')
map('v', ':', ';')

---- create new vertical window and switch to it
function vsplit()
  cmd('vsplit')
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  api.nvim_win_set_buf(win, buf)
end
map('n', '<leader>w', ':lua vsplit()<CR>', {silent = true})

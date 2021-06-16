local api, cmd, g = vim.api, vim.cmd, vim.g

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- plugins with packer
require('packer').startup(function()
  use {'wbthomason/packer.nvim'}

  use {'chriskempson/base16-vim'}

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
end)

-- options

--- colorscheme
api.nvim_command('let base16colorspace=256')
api.nvim_command('colorscheme base16-tomorrow-night')

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

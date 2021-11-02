local api, cmd, g, opt = vim.api, vim.cmd, vim.g, vim.opt

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- plugins with packer
require('packer').startup(function()
  use {'wbthomason/packer.nvim'}

  use {'chriskempson/base16-vim'}

  use {'christoomey/vim-tmux-navigator'}

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  --- use lens.vim to resize windows automatically when switched
  use {'camspiers/lens.vim'}

  --- dim inactive windows
  use {'blueyed/vim-diminactive'}
end)

-- options

--- colorscheme
opt.background = "dark"
opt.termguicolors = true
api.nvim_command('let base16colorspace=256')
cmd('silent! colorscheme base16-tomorrow-night')

-- mapping

--- set leader to space
map('', '<Space>', '<Nop>', {silent = true})
g.mapleader = " "
g.maplocalleader = " "

--- swap colon with semicolon
map('n', ';', ':')
map('n', ':', ';')
map('v', ';', ':')
map('v', ':', ';')

--- new vertical window
map('n', '<leader>w', '<Cmd>botright vnew<CR>', {silent = true})

--- window navigation with tmux-navigator
map('n', '<C-l>', ':TmuxNavigateRight <CR>', {silent = true})
map('n', '<C-j>', ':TmuxNavigateDown <CR>', {silent = true})
map('n', '<C-k>', ':TmuxNavigateUp <CR>', {silent = true})
map('n', '<C-h>', ':TmuxNavigateLeft <CR>', {silent = true})

-- plugin settings
--- tree-sitter
if pcall(require, 'nvim-treesitter') then
  require('nvim-treesitter.configs').setup {
    ensure_installed = 'maintained',
    highlight = {enable = true},
  }
end

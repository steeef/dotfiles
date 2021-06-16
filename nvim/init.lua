local api = vim.api

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

---- swap colon with semicolon
map('n', ';', ':')
map('n', ':', ';')
map('v', ';', ':')
map('v', ':', ';')

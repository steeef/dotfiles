local api = vim.api

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

require 'paq-nvim' {
  'savq/paq-nvim';
  {'nvim-treesitter/nvim-treesitter', run=function() vim.cmd 'TSUpdate' end};
}


local colors = require('dracula').colors()

vim.api.nvim_set_hl(0, 'DraculaPink',    {fg = colors.pink})
vim.api.nvim_set_hl(0, 'DraculaOrange', {fg = colors.orange})
vim.api.nvim_set_hl(0, 'DraculaYellow',   {fg = colors.yellow})
vim.api.nvim_set_hl(0, 'DraculaGreen', {fg = colors.green})
vim.api.nvim_set_hl(0, 'DraculaCyan',  {fg = colors.cyan})
vim.api.nvim_set_hl(0, 'DraculaPurple',  {fg = colors.purple})
vim.api.nvim_set_hl(0, 'DraculaRed',  {fg = colors.red})

return {
  'nvim-treesitter/nvim-treesitter',
  cmd = {"TSInstall","TSInstallInfo", "TSUpdate"},
  dependencies = {
    'HiPhish/nvim-ts-rainbow2',
    'RRethy/nvim-treesitter-endwise',
  },
  event = {'BufReadPost', 'BufNewFile'},
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = 'all',
      auto_install = true,
      endwise = {enable = true},
      highlight = {enable = true},
      indent = {
        enable = true,
        disable = {
          "nix",
          "yaml",
        },
      },
      rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than n lines, int
        query = 'rainbow-parens', -- Which query to use for finding delimiters
        strategy = require 'ts-rainbow.strategy.global', -- Highlight the entire buffer all at once
        hlgroups = {
          'DraculaPink',
          'DraculaOrange',
          'DraculaYellow',
          'DraculaGreen',
          'DraculaCyan',
          'DraculaPurple',
          'DraculaRed',
        },
      }
    }
  end
}

local api, cmd, g, opt = vim.api, vim.cmd, vim.g, vim.opt

require('plugins')
require('mappings')

-- options

--- colorscheme
opt.background = "dark"
opt.termguicolors = true
api.nvim_command('let base16colorspace=256')
cmd('silent! colorscheme base16-tomorrow-night')

local api, cmd, opt = vim.api, vim.cmd, vim.opt

-- colorscheme
opt.background = "dark"
opt.termguicolors = true
api.nvim_command('let base16colorspace=256')
cmd('silent! colorscheme base16-tomorrow-night')

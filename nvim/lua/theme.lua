local cmd, opt = vim.cmd, vim.opt

-- colorscheme
opt.background = "dark"
opt.termguicolors = true
cmd("silent! colorscheme onedark")

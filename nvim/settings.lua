local opt = vim.opt

opt.encoding = "utf-8"

opt.backspace = "indent,eol,start" -- work for every character in insert mode
opt.completeopt = "menuone,noselect"
opt.dictionary = "/usr/share/dict/words"

-- Mapping waiting time
opt.timeout = false
opt.ttimeout = true
opt.ttimeoutlen = 50

-- search options
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- case insensitive unless specified
opt.incsearch = true -- start searching immediately
opt.nohlsearch = true -- don't highlight search

-- display options
opt.showmatch = true -- show matching brackets
opt.scrolloff = 3 -- always show 3 rows from edge
opt.synmaxcol = 300 -- stop syntax highlight after x lines for performance
opt.laststatus = 2 -- always show status line
opt.list = true -- show whitespace chars

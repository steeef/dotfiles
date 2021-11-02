local opt = vim.opt

HOME = os.getenv("HOME")

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
opt.hlsearch = false -- don't highlight search

-- display options
opt.scrolloff = 3 -- always show 3 rows from edge
opt.synmaxcol = 300 -- stop syntax highlight after x lines for performance
opt.laststatus = 2 -- always show status line
-- matching brackets
opt.showmatch = true -- show matching bracket pairs
opt.matchtime = 2 -- delay before showing matching pairs
opt.mps = opt.mps .. ",<:>" -- add more matching pair symbols

opt.list = true -- show whitespace chars
opt.foldenable = false
opt.foldlevel = 4 -- limit folding to 4 levels
opt.foldmethod = 'syntax' -- use language syntax to generate folds
opt.wrap = true
opt.eol = true
opt.showbreak = '↪'

-- number line column
opt.relativenumber = true
opt.number = true
opt.numberwidth = 3 -- always reserve 3 spaces for line number
opt.signcolumn = 'yes' -- keep 1 column for coc.vim  check
opt.modelines = 0
opt.showcmd = true -- display command in bottom bar

-- White characters
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 2 -- 1 tab = 2 spaces
opt.shiftwidth = 2 -- indentation rule
opt.softtabstop = 2
opt.shiftround = true
opt.expandtab = true -- tab to spaces
opt.formatoptions = 'cjnq1' -- see :help fo-table

-- backup
opt.backup = true
opt.writebackup = false -- don't backup file before writing
opt.swapfile = false
opt.undodir = HOME .. ".vimundo//"
opt.backupdir = HOME .. ".vimbackup//"

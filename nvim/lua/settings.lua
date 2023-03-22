local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd

HOME = os.getenv("HOME")

opt.encoding = "utf-8"
opt.fileformats="unix,dos"

vim.g.loaded_perl_provider = 0 -- disable perl provider

opt.backspace = "indent,eol,start" -- work for every character in insert mode
opt.completeopt = "menuone,noselect"
opt.dictionary = "/usr/share/dict/words"

opt.clipboard = "unnamedplus" -- always use system clipboard

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
opt.title = true
opt.visualbell = true
opt.cursorline = true
opt.lazyredraw = true
opt.scrolloff = 3 -- always show 3 rows from edge
opt.synmaxcol = 300 -- stop syntax highlight after x lines for performance
opt.laststatus = 3 -- always show global status line
opt.colorcolumn = "120" -- vertical bar at 120 chars
-- matching brackets
opt.showmatch = true -- show matching bracket pairs
opt.matchtime = 2 -- delay before showing matching pairs
opt.mps = "(:),{:},[:],<:>"  -- add more matching pair symbols

opt.list = true -- show whitespace chars
opt.listchars = 'tab:» ,trail:·,extends:❯,precedes:❮'
opt.foldenable = false
opt.foldlevel = 4 -- limit folding to 4 levels
opt.foldmethod = 'syntax' -- use language syntax to generate folds
opt.wrap = true
opt.eol = true
opt.showbreak = '↪'
opt.textwidth = 119
opt.shortmess='atIc'

-- lines
opt.relativenumber = true
opt.number = true
opt.numberwidth = 3 -- always reserve 3 spaces for line number
opt.signcolumn = 'yes' -- keep 1 column for coc.vim  check
opt.modelines = 0
opt.showcmd = true -- display command in bottom bar
opt.fillchars = "vert:┃"

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
opt.undodir = HOME .. "/.vimundo//"
opt.backupdir = HOME .. "/.vimbackup//"

-- wildcard menu in command section
opt.cmdheight = 2
opt.showmode = true
opt.showcmd = true
opt.wildmenu = true -- tab completion for commands
opt.wildmode = "list:longest"
opt.wildignore = "deps,.hg,.svn,CVS,*.aux,*.out.*.toc,*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.o,*.so,*.class,*.obj,*.exe,*.dll,*.manifest,*spl,tags,*.sw?,*.DS_Store,*.luac,migrations,*.pyc"

-- windows
opt.splitbelow = true
opt.splitright = true
opt.switchbuf = "useopen"

-- saving files
opt.autoread = true

-- spelling
opt.spelllang = 'en,cjk'
opt.spellsuggest='best,9'
autocmd("Filetype", {
  pattern = {
    "NeogitCommitMessage",
    "gitcommit",
    "markdown",
  },
  command = "setlocal spell",
})

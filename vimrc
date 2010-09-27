if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=100 columns=200
  set guifont=Consolas:h9
else
  " This is console Vim.
  set t_Co=256
  if exists("+lines")
    set lines=60
  endif
  if exists("+columns")
    set columns=200
  endif
endif

colorscheme molokai
syntax enable


filetype off
"call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

set nocompatible
set modelines=0

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set title

set nobackup
set noswapfile
set history=1000
set undolevels=1000

set incsearch
set hlsearch
set showmatch

set ignorecase
set smartcase

set relativenumber

set wrap
"see :help for-table
set formatoptions=qrn1
"set textwidth=189
"set colorcolumn=195

"disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
"up and down work with wrapped lines
nnoremap j gj
nnoremap k gk

" match bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l


" F1 = remove search highlighting
inoremap <F1> :nohlsearch<Enter>
nnoremap <F1> :nohlsearch<Enter>
vnoremap <F1> :nohlsearch<Enter>

" F5 = toggle paste mode
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

nnoremap ; :

"sudo save if not root
cmap w!! w !sudo tee % >/dev/null

let mapleader=","
" ev = edit vimrc
" sv = reload vimrc
" if winvimrc is set, use that instead of $MYVIMRC
if exists("winvimrc")
    exec "nmap <silent> <leader>ev <C-w><C-v><C-l>:e ".winvimrc."<CR>"
    exec "nmap <silent> <leader>sv :so ".winvimrc."<CR>"
else
    nmap <silent> <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<CR>
    nmap <silent> <leader>sv :so $MYVIMRC<CR>
endif

nmap <leader>a :Ack

"open new vertical window and switch to it
nmap <leader>w <C-w>v<C-w>l

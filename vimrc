scriptencoding utf-8

"git urls for pathogen bundles
" BUNDLE: git://github.com/scrooloose/nerdcommenter.git
" BUNDLE: git://github.com/vim-ruby/vim-ruby.git
" BUNDLE: git://github.com/vim-scripts/IndexedSearch.git
" BUNDLE: git://github.com/tpope/vim-unimpaired.git
" BUNDLE: git://github.com/tpope/vim-surround.git
" BUNDLE: git://github.com/vim-scripts/L9.git
" BUNDLE: git://github.com/vim-scripts/YankRing.vim.git
" BUNDLE: git://github.com/rodjek/vim-puppet.git
" BUNDLE: git://github.com/msanders/snipmate.vim.git
" BUNDLE: git://github.com/kogent/vim-nagios.git
" BUNDLE: git://github.com/gabemc/powershell-vim.git
" BUNDLE: git://github.com/ervandew/supertab.git
" BUNDLE: git://github.com/kien/ctrlp.vim.git
" BUNDLE: git://github.com/kien/rainbow_parentheses.vim.git

if has("gui_running")
    " GUI is running or is about to start.

    " Set font and window size based on operating system
    if has("unix")
        set guifont=Liberation\ Mono\ 10
    else
        set guifont=Liberation\ Mono:h10
        set lines=100 columns=200
    endif

    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
else
    " This is console Vim.
    set t_Co=256
endif
" set molokai, or desert if it doesn't exist
try
    colorscheme molokai
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert
endtry


runtime! autoload/pathogen.vim
if exists('g:loaded_pathogen')
    call pathogen#infect()
endif
filetype plugin indent on
syntax on

" statusline settings
set laststatus=2
set statusline=%M%R%l/%L\,%c:%Y:\%f

set nocompatible
set modelines=0
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set completeopt=longest,menuone,preview

"Set ruby-specific formatting
if has("autocmd")
    autocmd FileType ruby,puppet setlocal ts=2 sts=2 sw=2 expandtab
endif

set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set title

" Wildmenu settings
set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn,CVS                " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" create backup directory and set backupdir
let vimbackupdir = $HOME . '/.vimbackup'
if exists("*mkdir")
    if !isdirectory(vimbackupdir)
        call mkdir(vimbackupdir)
    endif
endif
set backup
let &backupdir=vimbackupdir

set noswapfile
set history=1000
set undolevels=1000

set incsearch
set hlsearch
set showmatch

set ignorecase
set smartcase

" 7.3-specific setting
if v:version >= 703
    set relativenumber
    set colorcolumn=85
else
    set number
end

set wrap
"see :help for-table
set formatoptions=qrn1
set textwidth=79

"show formatting characters
set list
set listchars=tab:»\ ,trail:·

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


" F5 = toggle paste mode
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

" try jj as escape in interactive mode
inoremap jj <Esc>

" Use Enter to exit normal,visual,command mode
" Use CTRL-O to create new line in insert mode
"inoremap <CR> <Esc>
nnoremap <CR> <Esc>
vnoremap <CR> <Esc>gV
onoremap <CR> <Esc>
inoremap <C-o> <CR>

" Swap colon, semicolon
nnoremap ; :
nnoremap : ;

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

" Remove whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" remove search highlighting
nnoremap <leader><space> :nohlsearch<Enter>

" Change case
nnoremap <C-u> gUiw
inoremap <C-u> <esc>gUiwea

" Substitute
nnoremap <leader>s :%s//<left>

"open new vertical window and switch to it
nmap <leader>w <C-w>v<C-w>l

"YankRing: Show yanked text
let g:yankring_clipboard_monitor = 1
nnoremap <silent> <F3> :YRShow<CR>
inoremap <silent> <F3> <ESC>:YRShow<CR>
nnoremap <leader>p "*p

" make indentation easier
nmap <C-]> >>
" if running vim in a terminal, <C-[> is the escape character
" Mapping it will insert extra characters
if has("gui_running")
    nmap <C-[> <<
endif
" indentation in vmode
vmap <C-]> >gv
vmap <C-[> <gv

" open current file's directory
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>

" Commenting
"requires NERDCommenter plugin
vmap <leader>m ,c<space>gv
map <leader>m ,c<space>

" insert blank line below or above current line
nnoremap <leader>j :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <leader>k :set paste<CR>m`O<Esc>``:set nopaste<CR>

" insert blank line below
nnoremap <CR> o<ESC>

"Movement commands (requires unimpaired plugin)
"Move current line down/up
map <C-Down> ]e
map <C-Up> [e
"Move visually selected lines down/up
vmap <C-Down> ]egv
vmap <C-Up> [egv

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabLongestHighlight = 1

" CTRL-P
let g:ctrlp_map = '<leader>t'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_split_window = 0
let g:ctrlp_prompt_mappings = {
\ 'PrtSelectMove("j")':   ['<c-j>', '<down>', '<s-tab>'],
\ 'PrtSelectMove("k")':   ['<c-k>', '<up>', '<tab>'],
\ 'PrtHistory(-1)':       ['<c-n>'],
\ 'PrtHistory(1)':        ['<c-p>'],
\ 'ToggleFocus()':        ['<c-tab>'],
\ 'PrtClearCache()':      ['<leader>y'],
\ }

" Rainbow Parentheses
nnoremap <leader>r :RainbowParenthesesToggle<cr>
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16

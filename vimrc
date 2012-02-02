" initial settings
scriptencoding utf-8
set nocompatible

" vundle setup
" ---------------------------------------------------------
" Use custom path in Windows
if has("win32")
    set rtp+=~/My\ Documents/My\ Dropbox/dotfiles/vim/bundle/vundle/
else
    set rtp+=~/.vim/bundle/vundle/
endif
runtime autoload/vundle.vim " apparently without this the exists() check fails
if exists("*vundle#rc")
    filetype off
    call vundle#rc()

    " let Vundle manage Vundle
    " required!
    Bundle 'gmarik/vundle'
    " Bundles to manage with vundle
    " ---------------------------------------------------------
    Bundle 'scrooloose/nerdcommenter'
    Bundle 'scrooloose/nerdtree'
    Bundle 'vim-scripts/IndexedSearch'
    Bundle 'tpope/vim-surround'
    Bundle 'tpope/vim-repeat'
    Bundle 'vim-scripts/L9'
    Bundle 'vim-scripts/YankRing.vim'
    Bundle 'kien/ctrlp.vim'
    Bundle 'vim-scripts/IndentConsistencyCop'
    Bundle 'ciaranm/detectindent'
    Bundle 'msanders/snipmate.vim'
    Bundle 'Lokaltog/vim-easymotion'
    Bundle 'vcscommand.vim'
    Bundle 'mileszs/ack.vim'
    Bundle 'altercation/vim-colors-solarized'
    " language-specific bundles
    Bundle 'vim-ruby/vim-ruby'
    Bundle 'rodjek/vim-puppet'
    Bundle 'gabemc/powershell-vim'
    " ---------------------------------------------------------
    " post-vundle settings
    filetype plugin indent on
endif

syntax enable

" appearance/font config
" ---------------------------------------------------------
if has("gui_running")
    " GUI is running or is about to start.

    " Set font and window size based on operating system
    if has("unix")
        set guifont=DejaVu\ Sans\ Mono\ 10
    else
        set guifont=DejaVu\ Sans\ Mono:h10
        set lines=100 columns=200
    endif

    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
else
    " This is console Vim.
endif
" ---------------------------------------------------------

" colorscheme settings
" ---------------------------------------------------------
set background=dark

" try/catch to set colorscheme
" little tricky to follow here:
" If solarized exists, don't force terminal to 256 colors.
" Otherwise, set to 256 if in console (not gui) and try the
" next two colorschemes.
try
    colorscheme solarized
catch /^Vim\%((\a\+)\)\=:E185/
    try
        if !has("gui_running")
            set t_Co=256
        endif
        colorscheme molokai
    catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme desert
    endtry
endtry
" ---------------------------------------------------------

" standard vim options
" ---------------------------------------------------------
" statusline settings
set laststatus=2
set statusline=%M%R%l/%L\,%c:%Y:\%f

set modelines=0
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
set ignorecase
set smartcase
set wrap
set number
set formatoptions=qrn1
set textwidth=79
set lazyredraw
set confirm

"indent options
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround

"search options
set incsearch
set hlsearch
set showmatch

" 7.3-specific setting
if v:version >= 703
    set colorcolumn=85
end

"show formatting characters
set list
set listchars=tab:»\ ,trail:·

"window options
set splitbelow
set splitright

" per-project vimrc files
" useful for specifying things like tabstops
" Disable on Windows
if !has("win32")
    set exrc    " enable per-directory .vimrc files
    set secure  " disable unsafe commands in local .vimrc files
fi
" ---------------------------------------------------------

" create backup directory and set backupdir
" ---------------------------------------------------------
let vimbackupdir = $HOME . '/.vimbackup'
if exists("*mkdir")
    if !isdirectory(vimbackupdir)
        call mkdir(vimbackupdir)
    endif
endif
set backup
let &backupdir=vimbackupdir
" set history options
set noswapfile
set history=1000
set undolevels=1000
" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"
" ---------------------------------------------------------

"Set ruby-specific formatting
if has("autocmd")
    autocmd FileType ruby,puppet setlocal ts=2 sts=2 sw=2 expandtab
endif


" Wildmenu settings
" ---------------------------------------------------------
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
" ---------------------------------------------------------

" key mapping
" ---------------------------------------------------------
let mapleader=","

" disable arrow keys
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

" F5 = toggle paste mode
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

" try jj as escape in interactive mode
inoremap jj <Esc>

" Use Enter to exit normal,visual,command mode
" Use CTRL-O to create new line in insert mode
nnoremap <CR> <Esc>
vnoremap <CR> <Esc>gV
onoremap <CR> <Esc>
inoremap <C-o> <CR>

" Swap colon, semicolon
nnoremap ; :
nnoremap : ;

"sudo save if not root
cmap w!! w !sudo tee % >/dev/null

" Remove trailing whitespace from buffer
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" insert blank line below
nnoremap <CR> o<ESC>

" remove search highlighting
nnoremap <leader><space> :nohlsearch<Enter>

" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc><right>

" Change case
nnoremap <C-u> gUiw
inoremap <C-u> <esc>gUiwea

"open new vertical window and switch to it
nmap <leader>w <C-w>v<C-w>l
" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="
" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

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

" completion
inoremap <leader>q <C-x><C-o>

" Quick editing
" ---------------------------------------------------------
" vimrc: open in new window
nnoremap <leader>ev <C-w>v<C-w>j:e $MYVIMRC<cr>
" vimrc: reload
nnoremap <leader>sv :so $MYVIMRC<cr>

" open current file's directory
nnoremap <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>

" Substitute
nnoremap <leader>s :%s//<left>

" paste from clipboard
nnoremap <leader>p "*p

" ---------------------------------------------------------

" ExecuteInShell
" Create :Shell command to execute in shell and display
" results in a split window
" ---------------------------------------------------------
function! s:ExecuteInShell(command)
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>:AnsiEsc<CR>'
    silent! execute 'nnoremap <silent> <buffer> q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>! :Shell 
" ---------------------------------------------------------

" YankRing
" ---------------------------------------------------------
let g:yankring_clipboard_monitor = 1
nnoremap <silent> <F3> :YRShow<CR>
inoremap <silent> <F3> <ESC>:YRShow<CR>
" ---------------------------------------------------------

" NERDCommenter
" ---------------------------------------------------------
vmap <leader>m ,c<space>gv
map <leader>m ,c<space>
" ---------------------------------------------------------

" vcscommand
" ---------------------------------------------------------
nnoremap <leader>d :VCSVimDiff<cr>
nnoremap <leader>D :diffoff<cr>
" ---------------------------------------------------------

" CTRL-P
" ---------------------------------------------------------
let g:ctrlp_map = '<leader>,'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_jump_to_buffer = 2
let g:ctrlp_max_height = 15
let g:ctrlp_split_window = 0
" ---------------------------------------------------------

" Ack
" ---------------------------------------------------------
noremap <leader>a :Ack! 
" ---------------------------------------------------------

" NERDTree
" ---------------------------------------------------------
noremap  <F2> :NERDTreeToggle<cr>
inoremap <F2> <esc>:NERDTreeToggle<cr>

au Filetype nerdtree setlocal nolist

let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index', 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json', '.*\.o$', 'db.db', 'tags.bak']

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 0
" ---------------------------------------------------------

" EasyMotion
" ---------------------------------------------------------
" map specific functions to specific keys rather than let
" EasyMotion do the mapping
let g:EasyMotion_do_mapping = 0

nnoremap <silent> <Leader>f      :call EasyMotion#F(0, 0)<CR>
onoremap <silent> <Leader>f      :call EasyMotion#F(0, 0)<CR>
vnoremap <silent> <Leader>f :<C-U>call EasyMotion#F(1, 0)<CR>

nnoremap <silent> <Leader>F      :call EasyMotion#F(0, 1)<CR>
onoremap <silent> <Leader>F      :call EasyMotion#F(0, 1)<CR>
vnoremap <silent> <Leader>F :<C-U>call EasyMotion#F(1, 1)<CR>

onoremap <silent> <Leader>t      :call EasyMotion#T(0, 0)<CR>
onoremap <silent> <Leader>T      :call EasyMotion#T(0, 1)<CR>

onoremap <silent> <Leader>j      :call EasyMotion#JK(0, 0)<CR>
onoremap <silent> <Leader>k      :call EasyMotion#JK(0, 1)<CR>
" ---------------------------------------------------------

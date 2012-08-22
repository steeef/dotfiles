" initial settings
scriptencoding utf-8
set nocompatible
filetype plugin indent on

" vundle ----------------------------------------------------------------- "{{{
" Use custom path in Windows
if has("win32")
    let vundlepath = "~/Dropbox/dotfiles/vim/bundle"
else
    " Use sudo user's vundle path
    if !empty($SUDO_USER)
        let vundlepath = "/home/$SUDO_USER/.vim/bundle"
    else
        let vundlepath = "~/.vim/bundle"
    endif
endif
execute "set rtp+=".vundlepath."/vundle/"
runtime autoload/vundle.vim " apparently without this the exists() check fails
if exists("*vundle#rc")
    filetype off
    call vundle#rc(vundlepath)

    " let Vundle manage Vundle
    " required!
    Bundle 'gmarik/vundle'
    " Bundles to manage with vundle
    " ---------------------------------------------------------"{{{
    Bundle 'scrooloose/nerdcommenter'
    Bundle 'scrooloose/nerdtree'
    Bundle 'scrooloose/syntastic'
    Bundle 'vim-scripts/IndexedSearch'
    Bundle 'ervandew/supertab'
    Bundle 'tpope/vim-surround'
    Bundle 'tpope/vim-repeat'
    Bundle 'tpope/vim-fugitive'
    if v:version >= 702
        " L9 Requires at least version 7.2
        Bundle 'vim-scripts/L9'
    endif
    Bundle 'vim-scripts/YankRing.vim'
    Bundle 'kien/ctrlp.vim'
    Bundle 'vim-scripts/IndentConsistencyCop'
    Bundle 'ciaranm/detectindent'
    Bundle 'Lokaltog/vim-easymotion'
    Bundle 'Lokaltog/vim-powerline'
    Bundle 'sjl/gundo.vim'
    Bundle 'AndrewRadev/linediff.vim'
    Bundle 'Align'
    " colorschemes
    Bundle 'sickill/vim-monokai'
    Bundle 'nanotech/jellybeans.vim'
    Bundle 'sjl/badwolf'
    Bundle 'xoria256.vim'
    " language-specific bundles
    Bundle 'vim-ruby/vim-ruby'
    Bundle 'rodjek/vim-puppet'
    Bundle 'gabemc/powershell-vim'
    Bundle 'davidoc/todo.txt-vim'
    "}}}

    " post-vundle settings
    filetype plugin indent on
endif

syntax enable
"}}}

" appearance/font -------------------------------------------------------- "{{{
if has("gui_running")
    " Set font and window size based on operating system
    if has("unix")
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 8
    else
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h10
        set lines=100 columns=200
    endif

    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions+=c  "use text-based dialogs instead of popups
else
    " This is console Vim.
endif
"}}}

" colorscheme ------------------------------------------------------------ "{{{
set background=dark

if !has("gui_running")
    set t_Co=256
endif
" try/catch to set colorscheme
try
    colorscheme molokai
catch /^Vim\%((\a\+)\)\=:E185/
    try
        colorscheme wombat256mod
    catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme desert
    endtry
endtry
"}}}

" standard options ------------------------------------------------------- "{{{
" statusline settings
" everything else defined in plugin/statusline.vim
set laststatus=2

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
runtime macros/matchit.vim
map <tab> %

if exists("+colorcolumn")
    set colorcolumn=85
endif

"show formatting characters
set list
set listchars=tab:»\ ,trail:·
"set underscore as a word boundary
set iskeyword-=_
" use vertical line (CTRL-K+VV) for vertical splits
" see :help digraphs
if !has("gui_running")
    set fillchars=vert:┃
endif

"window options
set splitbelow
set splitright

" per-project vimrc files
" useful for specifying things like tabstops
" Disable on Windows since it will complain if you're
" running in a path where it's not allowed.
if !has("win32")
    set exrc    " enable per-directory .vimrc files
    set secure  " disable unsafe commands in local .vimrc files
endif

" Abbreviations
iabbrev myName Stephen Price <sprice@monsooncommerce.com>

" jump to last known position upon opening
if has ("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif

" Toggle whitespace in diffs {{{

set diffopt+=iwhite
let g:diffwhitespaceon = 1
function! ToggleDiffWhitespace() "{{{
    if g:diffwhitespaceon
        set diffopt-=iwhite
        let g:diffwhitespaceon = 0
    else
        set diffopt+=iwhite
        let g:diffwhitespaceon = 1
    endif
    diffupdate
endfunc "}}}

nnoremap <leader>dw :call ToggleDiffWhitespace()<CR>

" }}}
"}}}

" autocommands ----------------------------------------------------------- "{{{
if has("autocmd")
    " turn off PASTE mode when leaving insert mode
    au InsertLeave * set nopaste

    " todo.txt filetype
    augroup ft_todotxt
        au BufNewFile,BufRead */todo/*.txt set filetype=todotxt
    augroup END

    " Set ruby-specific formatting
    autocmd FileType ruby,puppet setlocal ts=2 sts=2 sw=2 expandtab

    " vim helpiles
    augroup ft_vim
        au!

        au FileType vim setlocal foldmethod=marker
        au FileType help setlocal textwidth=78
        au BufWinEnter *.txt if &ft == 'help' | wincmd J | endif
    augroup END
endif
" }}}

" backup ----------------------------------------------------------------- "{{{
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
"}}}

" wildmenu --------------------------------------------------------------- "{{{
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
"}}}

" mapping ---------------------------------------------------------------- "{{{
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

"Unmap help in favor of Escape
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" F5 = toggle paste mode
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

" use jj as escape in interactive mode
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

" remove search highlighting
nnoremap <leader><space> :nohlsearch<Enter>

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

" Open a Quickfix window for the last search.
nnoremap <silent> ,/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
"}}}

" quick edit ------------------------------------------------------------- "{{{
" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc><right>

" Change case
nnoremap <C-u> gUiw
inoremap <C-u> <esc>gUiwea
"
" Remove trailing whitespace from entire buffer
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" insert blank line below
nnoremap <CR> o<ESC>

" vimrc
if has("win32")
    nnoremap <leader>ev <C-w>v<C-w>j:e ~/Dropbox/dotfiles/vimrc<CR>
    nnoremap <leader>sv :so ~/Dropbox/dotfiles/vimrc<CR>
else
    nnoremap <leader>ev <C-w>v<C-w>j:e $MYVIMRC<CR>
    nnoremap <leader>sv :so $MYVIMRC<CR>
endif

" open current file's directory
nnoremap <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>

" Substitute
nnoremap <leader>s :%s//<left>

" paste from clipboard
nnoremap <leader>p "*p

" insert date
:nnoremap <F6> "=strftime("%Y-%m-%d")<CR>P
:inoremap <F6> <C-R>=strftime("%Y-%m-%d")<CR>
"}}}

" Folding ---------------------------------------------------------------- {{{
set foldlevelstart=0

" Make the current location sane.
nnoremap <c-cr> zvzt

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" Use ,z to "focus" the current fold.
nnoremap <leader>z zMzvzz

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}

" ExecuteInShell() -------------------------------------------------------"{{{
" Create :Shell command to execute in shell and display
" results in a split window

function! s:ExecuteInShell(command)"{{{
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
endfunction"}}}

command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>! :Shell
"}}}

" NumberToggle() --------------------------------------------------------- "{{{
" Switch between relative and absolute line numbers
" Only works in Vim >= 7.3
" ---------------------------------------------------------
function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunction

if exists("&relativenumber")
    set relativenumber
    nnoremap <leader>n :call NumberToggle()<CR>
else
    set number
endif
"}}}

" Plugins ----------------------------------------------------------------"{{{

" YankRing -----------------------------------------------------------------"{{{
let g:yankring_clipboard_monitor = 1
nnoremap <silent> <F3> :YRShow<CR>
inoremap <silent> <F3> <ESC>:YRShow<CR>
"}}}

" NERDCommenter ------------------------------------------------------------"{{{
vmap <leader>m ,c<space>gv
map <leader>m ,c<space>
"}}}

" CTRL-P -------------------------------------------------------------------"{{{
let g:ctrlp_map = '<leader>,'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_jump_to_buffer = 2
let g:ctrlp_max_height = 15
let g:ctrlp_split_window = 0
"}}}

" NERDTree -----------------------------------------------------------------"{{{
noremap  <F2> :NERDTreeToggle<cr>
inoremap <F2> <esc>:NERDTreeToggle<cr>

au Filetype nerdtree setlocal nolist

let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index', 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json', '.*\.o$', 'db.db', 'tags.bak']

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 0
"}}}

" EasyMotion ---------------------------------------------------------------"{{{
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
"}}}

" Gundo -------------------------------------------------------------------"{{{
nnoremap <F4> :GundoToggle<CR>
"}}}

" Align -------------------------------------------------------------------"{{{
" Puppet: align resource parameters
vnoremap <leader>= :Align =><CR>
"}}}

" syntastic ---------------------------------------------------------------"{{{
" autoclose window if no errors
let g:syntastic_auto_loc_list=2
let g:puppet_module_detect=1
" maintain list of active (check on save) and passive (check on command) filetypes
" avoids annoying delay when saving files
let g:syntastic_mode_map = { 'mode': 'active',
                            \ 'active_filetypes': ['ruby', 'perl', 'php', 'bash',
                            \                      'vim'],
                            \ 'passive_filetypes': ['puppet'] }

nnoremap <leader>E :Errors<CR>
nnoremap <leader>S :SyntasticCheck<CR>
"}}}

" taglist -----------------------------------------------------------------"{{{
let tlist_puppet_settings='puppet;c:class;d:define;s:site;n:node'
nnoremap <silent><leader>l :TlistToggle<CR>
"}}}

" supertab ----------------------------------------------------------------"{{{
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabLogestHighlight = 1
"}}}

" linediff ----------------------------------------------------------------"{{{
vnoremap <leader>l :Linediff<cr>
nnoremap <leader>L :LinediffReset<cr>
"}}}

" Powerline ---------------------------------------------------------------"{{{
let Powerline_symbols = 'fancy'
"}}}


" initial settings  ------------------------------------------------------ "{{{

scriptencoding utf-8
set nocompatible
filetype plugin indent on

"}}}

" vundle ----------------------------------------------------------------- "{{{
if !empty($SUDO_USER)
    " Use sudo user's vundle path
    let vundlepath = "/home/$SUDO_USER/.vim/bundle"
else
    let vundlepath = "~/.vim/bundle"
endif

execute "set rtp+=".vundlepath."/vundle/"
runtime autoload/vundle.vim " apparently without this the exists() check fails
" if vundle is loaded
if exists("*vundle#rc")
    filetype off
    call vundle#rc(vundlepath)

    " let Vundle manage Vundle
    " required!
    Bundle 'gmarik/vundle'
    " Bundles to manage with vundle
    " ---------------------------------------------------------"{{{
    Bundle 'scrooloose/syntastic'
    Bundle 'bling/vim-airline'
    Bundle 'vim-scripts/IndexedSearch'
    Bundle 'maxbrunsfeld/vim-yankstack'
    Bundle 'tpope/vim-surround'
    Bundle 'tpope/vim-repeat'
    Bundle 'tpope/vim-endwise'
    Bundle 'tpope/vim-commentary'
    Bundle 'kien/ctrlp.vim'
    Bundle 'ciaranm/detectindent'
    Bundle 'Lokaltog/vim-easymotion'
    Bundle 'sjl/gundo.vim'
    Bundle 'sjl/clam.vim'
    Bundle 'mileszs/ack.vim'
    "Bundle 'godlygeek/tabular'
    Bundle 'junegunn/vim-easy-align'
    Bundle 'myusuf3/numbers.vim'
    " YCM requires 7.3.584
    if v:version > 703 || (v:version == 703 && has('patch584'))
        Bundle 'Valloric/YouCompleteMe'
    endif

    " colorschemes
    Bundle 'nanotech/jellybeans.vim'
    Bundle 'sjl/badwolf'
    Bundle 'w0ng/vim-hybrid'
    Bundle 'junegunn/seoul256.vim'
    Bundle 'altercation/vim-colors-solarized'

    " language-specific bundles
    Bundle 'vim-ruby/vim-ruby'
    Bundle 'rodjek/vim-puppet'
    Bundle 'steeef/todo.txt-vim'
    Bundle 'avakhov/vim-yaml'
    Bundle 'LaTeX-Box-Team/LaTeX-Box'
    "}}}

    " post-vundle settings
    filetype plugin indent on
endif

syntax enable
"}}}

" appearance/font -------------------------------------------------------- "{{{
if has("gui_running")
    " Set font and window size based on operating system
    if has ("unix")
        if has ("gui_macvim")
            " Must be MacVim
            set guifont=Monaco:h10
            set noantialias

            " Full screen means FULL screen
            set fuoptions=maxvert,maxhorz
        else
            " Must be Linux
            set guifont=DejaVu\ Sans\ Mono\ 8
        endif
    else
        " Must be Windows
        set guifont=DejaVu\ Sans\ Mono:h9
    endif

    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=R  "remove right-hand scroll bar for vert split
    set guioptions-=l  "remove left-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar for vert split
    set guioptions+=c  "use text-based dialogs instead of popups

    " Different cursors for different modes.
    set guicursor=n-c:block-Cursor-blinkon0
    set guicursor+=v:block-vCursor-blinkon0
    " commented out INSERT mode cursor for compatibilty with other colorschemes
    "set guicursor+=i-ci:ver20-iCursor
else
    " This is console Vim.
    " mouse support
    set mouse=a
endif

set shortmess=atI " Don't show the Vim intro message

"}}}

" colorscheme ------------------------------------------------------------ "{{{
set background=dark

" force terminal Vim to use 256 colors
if !has("gui_running")
    set t_Co=256
endif

" try/catch to set colorscheme
" Vim will throw an error if the colorscheme doesn't exist, so we try another
" in the catch block
try
    colorscheme hybrid
catch /^Vim\%((\a\+)\)\=:E185/
    try
        let g:seoul256_background = 234
        colorscheme seoul256
    catch /^Vim\%((\a\+)\)\=:E185/
        try
            colorscheme molokai
        catch /^Vim\%((\a\+)\)\=:E185/
            colorscheme desert
        endtry
    endtry
endtry
"}}}

" standard options ------------------------------------------------------- "{{{
" statusline settings
" everything else defined in plugin/statusline.vim
set laststatus=2

set modelines=0
set encoding=utf-8
set scrolloff=5
set showmode
set showcmd
set title
set visualbell
set cursorline
set ttyfast
set lazyredraw
set ruler
set confirm
if exists("+colorcolumn")
    set colorcolumn=85
endif

" Buffers ---------------------------------------------------------------- "{{{

" Allow unsaved background buffers and remember marks/undo for them
set hidden

" Jump to the first open window that contains the specified buffer
set switchbuf=useopen

" Auto-reload buffers when files are changed on disk
set autoread

" }}}

" Wrapping --------------------------------------------------------------- "{{{

set wrap
set showbreak=↪\  " Character to precede line wraps
set textwidth=79

" }}}

" Numbers now handled by numbers.vim plugin
"set line number settings based on features. Relative number is preferred.
"Vim >= 7.4 has a hybrid mode that will display the current line number as
"well as relative line numbers. You set it by setting both relativenumber
"and number.
" if v:version > 703
"     set relativenumber
"     set number
" else
"     if exists("+relativenumber")
"         set relativenumber
"     else
"         set number
"     endif
" endif
set number

" Prevent Vim from clearing the scrollback buffer
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

"set underscore as a word boundary
set iskeyword-=_

"allow backspace to work for indents, between lines, and the start of insert mode
set backspace=indent,eol,start

"see :help fo-table
set formatoptions=qrn1
" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

"indent options
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround

"search options
set ignorecase
set smartcase
set incsearch
set hlsearch
set showmatch

"matching
runtime macros/matchit.vim
map <tab> %

"show formatting characters
set list
set listchars=tab:»\ ,trail:·,extends:❯,precedes:❮
"use vertical line (CTRL-K+VV) for vertical splits
"see :help digraphs
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
    " Resize splits when the window is resized
    au VimResized * exe "normal! \<c-w>="
    " turn off PASTE mode when leaving insert mode
    au InsertLeave * set nopaste

    " todo.txt filetype
    augroup ft_todotxt
        au BufNewFile,BufRead */todo/*.txt set filetype=todotxt
    augroup END

    " Set ruby-specific formatting
    autocmd FileType ruby,puppet setlocal ts=2 sts=2 sw=2 expandtab

    " vim, vim helpfiles
    augroup ft_vim
        au!

        au FileType vim setlocal foldmethod=marker
        au FileType help setlocal textwidth=78
        " use Enter to follow links
        au FileType help nmap <buffer> <CR> <C-]>
        au BufWinEnter *.txt if &ft == 'help' | wincmd J | endif
    augroup END

    " Return to last position when file is reopened
    autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
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
set noswapfile
let &backupdir=vimbackupdir
set history=1000

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" undo feature requires > 7.3
if has("undofile")
    let vimundodir = $HOME . '/.vimundo'
    if exists("*mkdir")
        if !isdirectory(vimundodir)
            call mkdir(vimundodir)
        endif
    endif
    set undofile
    let &undodir=vimundodir
    set undolevels=1000
    set undoreload=10000
endif
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

" setup yankstack before mappings
silent! call yankstack#setup()

"disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
"Unmap help
inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>

"up and down work with wrapped lines
nnoremap j gj
nnoremap k gk

" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc><right>

" F5 = toggle paste mode
nnoremap <F5> :set invpaste paste?<Enter>
inoremap <F5> <C-O><F5>
set pastetoggle=<F5>

" map easier-to-use keys
noremap H ^
noremap L $
vnoremap L g_

" Make Y behave like D, C
" nmap Y y$

" gi already moves to "last place you exited insert mode", so we'll map gI to
" something similar: move to last change
nnoremap gI `.

" Use Enter to exit normal,visual,command mode
nnoremap <CR> <Esc>
vnoremap <CR> <Esc>gV
onoremap <CR> <Esc>
" Use CTRL-O to create new line in insert mode
inoremap <C-o> <CR>

" Swap colon, semicolon
nnoremap ; :
nnoremap : ;

" sudo save if not root
cnoremap w!! w !sudo tee % >/dev/null

" remove search highlighting
nnoremap <leader><space> :nohlsearch<Enter>

" open new vertical window and switch to it
nnoremap <leader>w <C-w>v<C-w>l
" Easy window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" simplify indentation
nnoremap > >>
nnoremap < <<
" indentation in vmode
" re-select visual selection after indent/outdent
vnoremap > >gv
vnoremap < <gv

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Change case
nnoremap <C-u> gUiw
inoremap <C-u> <esc>gUiwea
"
" Remove trailing whitespace from entire buffer
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" insert blank line below
nnoremap <CR> o<ESC>

" edit vimrc in new window, reload vimrc
nnoremap <leader>ev <C-w>v<C-w>j:e $MYVIMRC<CR>
nnoremap <leader>sv :so $MYVIMRC<CR>

" open current file's directory
nnoremap <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>

" Substitute
nnoremap <leader>s :%s//<left>

" insert date
nnoremap <F6> "=strftime("%Y-%m-%d")<CR>P
inoremap <F6> <C-R>=strftime("%Y-%m-%d")<CR>

" Registers -------------------------------------------------------------- "{{{

" Use the OS clipboard by default
set clipboard^=unnamed

" Copy to X11 primary clipboard
map <leader>y "*y

" Paste from unnamed register and fix indentation
nmap <leader>p pV`]=

"}}}

"}}}

" Abbreviations ---------------------------------------------------------- "{{{

iabbrev myName Stephen Price <sprice@monsooncommerce.com>
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>

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

" Stab() ---------------------------------------------------------------- "{{{
" Switch between tabs and spaces
" Prompts for values or shows current values
" ---------------------------------------------------------

command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set shiftwidth=')

  if l:tabstop > 0
    " do we want expandtab as well?
    let l:expandtab = confirm('set expandtab?', "&Yes\n&No\n&Cancel")
    if l:expandtab == 3
      " abort?
      return
    endif

    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop

    if l:expandtab == 1
      setlocal expandtab
    else
      setlocal noexpandtab
    endif
  endif

  " show the selected options
  try
    echohl ModeMsg
    echon 'set tabstop='
    echohl Question
    echon &l:ts
    echohl ModeMsg
    echon ' shiftwidth='
    echohl Question
    echon &l:sw
    echohl ModeMsg
    echon ' sts='
    echohl Question
    echon &l:sts . ' ' . (&l:et ? '  ' : 'no')
    echohl ModeMsg
    echon 'expandtab'
  finally
    echohl None
  endtry
endfunction
"}}}

" Plugins ----------------------------------------------------------------"{{{

    " CTRL-P ------------------------------------------------------------------"{{{

    let g:ctrlp_map = '<leader>,'
    let g:ctrlp_working_path_mode = 0
    let g:ctrlp_match_window_reversed = 1
    let g:ctrlp_jump_to_buffer = 2
    let g:ctrlp_max_height = 15
    let g:ctrlp_split_window = 0

    nnoremap <leader>b :CtrlPBuffer<CR>

    "}}}

    " EasyMotion --------------------------------------------------------------"{{{
    " map specific functions to specific keys rather than let
    " EasyMotion do the mapping
    let g:EasyMotion_do_mapping = 0

    nnoremap <silent> <leader>f      :call EasyMotion#F(0, 0)<CR>
    onoremap <silent> <leader>f      :call EasyMotion#F(0, 0)<CR>
    vnoremap <silent> <leader>f :<C-U>call EasyMotion#F(1, 0)<CR>

    nnoremap <silent> <leader>F      :call EasyMotion#F(0, 1)<CR>
    onoremap <silent> <leader>F      :call EasyMotion#F(0, 1)<CR>
    vnoremap <silent> <leader>F :<C-U>call EasyMotion#F(1, 1)<CR>

    onoremap <silent> <leader>t      :call EasyMotion#T(0, 0)<CR>
    onoremap <silent> <leader>T      :call EasyMotion#T(0, 1)<CR>

    onoremap <silent> <Leader>j      :call EasyMotion#JK(0, 0)<CR>
    onoremap <silent> <Leader>k      :call EasyMotion#JK(0, 1)<CR>

    "}}}

    " Gundo -------------------------------------------------------------------"{{{

    nnoremap <F4> :GundoToggle<CR>

    "}}}

    " Clam --------------------------------------------------------------------"{{{

    nnoremap <leader>l :Clam<space>

    "}}}

    " easy-align --------------------------------------------------------------"{{{
    vnoremap <silent> <Enter> :EasyAlign<Enter>
    " hash rocket auto-aign (for Puppet)
    inoremap <silent> => =><Esc>mzvip:EasyAlign/=>/<CR>`z$a<Space>
    " custom delimiters
    let g:easy_align_delimiters = {
    \  '-': { 'pattern': '-',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 }
    \ }
    " }}}

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

    " Ack ---------------------------------------------------------------------"{{{
    " Use ag if it's in PATH
    " https://github.com/ggreer/the_silver_searcher
    if executable("ag")
        let g:ackprg = 'ag --nogroup --nocolor --column'
    endif

    nnoremap <leader>a :Ack!<space>

    " Ack motions {{{
    " Steve Losh https://github.com/sjl/dotfiles

    " Motions to Ack for things.  Works with pretty much everything, including:
    "
    "   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
    "
    " Awesome.
    "
    " Note: If the text covered by a motion contains a newline it won't work.  Ack
    " searches line-by-line.

    " \aiw will search for the word under the cursor
    " \aib will search inside braces
    nnoremap <silent> \a :set opfunc=<SID>AckMotion<CR>g@
    xnoremap <silent> \a :<C-U>call <SID>AckMotion(visualmode())<CR>

    function! s:CopyMotionForType(type)
        if a:type ==# 'v'
            silent execute "normal! `<" . a:type . "`>y"
        elseif a:type ==# 'char'
            silent execute "normal! `[v`]y"
        endif
    endfunction

    function! s:AckMotion(type) abort
        let reg_save = @@

        call s:CopyMotionForType(a:type)

        execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"

        let @@ = reg_save
    endfunction

    " }}}
    " }}}

    " Yankstack ---------------------------------------------------------------"{{{
    let g:yankstack_map_keys = 0
    nmap <leader>p <Plug>yankstack_substitute_older_paste
    nmap <leader>P <Plug>yankstack_substitute_newer_paste
    "}}}

    " airline -----------------------------------------------------------------"{{{
    let g:airline#extensions#tabline#enabled = 0
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline_theme = 'zenburn'
    let g:airline_left_sep=''
    let g:airline_right_sep=''
    "}}}

    " numbers -----------------------------------------------------------------"{{{
        nnoremap <leader>n :NumbersToggle<CR>
        nnoremap <leader>N :NumbersOnOff<CR>
    "}}}
"}}}

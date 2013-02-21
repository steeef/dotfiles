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
" if vundle is loaded
if exists("*vundle#rc")
    filetype off
    call vundle#rc(vundlepath)

    " let Vundle manage Vundle
    " required!
    Bundle 'gmarik/vundle'
    " Bundles to manage with vundle
    " ---------------------------------------------------------"{{{
    Bundle 'scrooloose/nerdcommenter'
    Bundle 'scrooloose/syntastic'
    Bundle 'vim-scripts/IndexedSearch'
    Bundle 'vim-scripts/YankRing.vim'
    Bundle 'tpope/vim-surround'
    Bundle 'tpope/vim-repeat'
    Bundle 'tpope/vim-endwise'
    Bundle 'kien/ctrlp.vim'
    Bundle 'ciaranm/detectindent'
    Bundle 'Lokaltog/vim-easymotion'
    Bundle 'Lokaltog/vim-powerline'
    Bundle 'sjl/gundo.vim'
    Bundle 'sjl/clam.vim'
    Bundle 'mileszs/ack.vim'
    Bundle 'godlygeek/tabular'

    " snipmate fork and dependencies
    Bundle "MarcWeber/vim-addon-mw-utils"
    Bundle "tomtom/tlib_vim"
    Bundle "honza/snipmate-snippets"
    Bundle "garbas/vim-snipmate"

    " colorschemes
    Bundle 'nanotech/jellybeans.vim'
    Bundle 'sjl/badwolf'

    " language-specific bundles
    Bundle 'vim-ruby/vim-ruby'
    Bundle 'rodjek/vim-puppet'
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
    if has ("unix")
        if has ("gui_macvim")
            " Must be MacVim
            set guifont=Monaco:h10
            set noantialias

            " Full screen means FULL screen
            set fuoptions=maxvert,maxhorz
        else
            " Must be Linux
            set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 8
        endif
    else
        " Must be Windows
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h9
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
    set guicursor+=i-ci:ver20-iCursor
else
    " This is console Vim.

    " mouse support
    set mouse=a
endif
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
" Not used if powerline is loaded
set laststatus=2

set modelines=0
set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set title
set visualbell
set cursorline
set ttyfast
set lazyredraw
set ruler
set confirm
set wrap
if exists("+colorcolumn")
    set colorcolumn=85
endif

"set underscore as a word boundary
set iskeyword-=_

"allow backspace to work for indents, between lines, and the start of insert mode
set backspace=indent,eol,start

"see :help fo-table
set formatoptions=qrn1
set textwidth=79

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
set listchars=tab:»\ ,trail:·
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

" toggle number
nnoremap <leader>N :setlocal number!<cr>

" :help yankring-custom-maps
function! YRRunAfterMaps()
    " Split line (sister to [J]oin lines)
    " The normal use of S is covered by cc, so don't worry about shadowing it.
    nnoremap S i<cr><esc><right>
endfunction

" F5 = toggle paste mode
nnoremap <F5> :set invpaste paste?<Enter>
inoremap <F5> <C-O><F5>
set pastetoggle=<F5>

" map easier-to-use keys
noremap H ^
noremap L $
vnoremap L g_

" gi already moves to "last place you exited insert mode", so we'll map gI to
" something similar: move to last change
nnoremap gI `.

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
cnoremap w!! w !sudo tee % >/dev/null

" remove search highlighting
nnoremap <leader><space> :nohlsearch<Enter>

"open new vertical window and switch to it
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

" insert date
:nnoremap <F6> "=strftime("%Y-%m-%d")<CR>P
:inoremap <F6> <C-R>=strftime("%Y-%m-%d")<CR>

"}}}

" Abbreviations ---------------------------------------------------------- "{{{

iabbrev myName Stephen Price <sprice@monsooncommerce.com>

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

" nerdcommenter ------------------------------------------------------------"{{{
vnoremap <leader>m ,c<space>gv
nnoremap <leader>m ,c<space>
"}}}

" CTRL-P -------------------------------------------------------------------"{{{
let g:ctrlp_map = '<leader>,'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_jump_to_buffer = 2
let g:ctrlp_max_height = 15
let g:ctrlp_split_window = 0
"}}}

" EasyMotion ---------------------------------------------------------------"{{{
" map specific functions to specific keys rather than let
" EasyMotion do the mapping
let g:EasyMotion_do_mapping = 0

" See .vim/after/plugin/EasyMotion.vim for mappings

"}}}

" Gundo -------------------------------------------------------------------"{{{
nnoremap <F4> :GundoToggle<CR>
"}}}

" Clam --------------------------------------------------------------------"{{{
nnoremap <leader>l :Clam<space>
"}}}

" Tabular -----------------------------------------------------------------"{{{
" Puppet: align resource parameters
vnoremap <leader>Ap :Tabularize /=><CR>
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

" Powerline ---------------------------------------------------------------"{{{
let Powerline_symbols = 'fancy'
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
"}}}

" Yankring ----------------------------------------------------------------"{{{
" cycle through yankring
let g:yankring_replace_n_pkey = '<leader>p'
let g:yankring_replace_n_nkey = '<leader>P'

" Some settings to try to get yank ring to not mess with default vim
" functionality so much.
let g:yankring_manage_numbered_reg = 0
let g:yankring_clipboard_monitor = 0
let g:yankring_paste_check_default_buffer = 0
let g:yankring_map_dot = 0

" Don't let yankring use f, t, /. It doesn't record them properly in macros
" and that's my most common use. Yankring also blocks macros of macros (it
" prompts for the macro register), but removing @ doesn't fix that :(
let g:yankring_zap_keys = ''

" Disable yankring for regular p/P. This preserves vim's normal behavior, but
" I can still use C-p/C-n to cycle through yankring.
let g:yankring_paste_n_bkey = ''
let g:yankring_paste_n_akey = ''
let g:yankring_paste_v_key = ''
let g:yankring_paste_v_bkey = ''
let g:yankring_paste_v_akey = ''
"}}}

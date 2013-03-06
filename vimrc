" initial settings  ------------------------------------------------------ "{{{
"
scriptencoding utf-8
set nocompatible
filetype plugin indent on

"}}}

" vundle ----------------------------------------------------------------- "{{{
" use custom path in windows
if has("win32")
    let vundlepath = "~/dropbox/dotfiles/vim/bundle"
else
    " use sudo user's vundle path
    if !empty($sudo_user)
        let vundlepath = "/home/$sudo_user/.vim/bundle"
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

    " let vundle manage vundle
    " required!
    bundle 'gmarik/vundle'
    " bundles to manage with vundle
    " ---------------------------------------------------------"{{{
    bundle 'scrooloose/syntastic'
    bundle 'vim-scripts/indexedsearch'
    bundle 'maxbrunsfeld/vim-yankstack'
    bundle 'tpope/vim-surround'
    bundle 'tpope/vim-repeat'
    bundle 'tpope/vim-endwise'
    bundle 'tpope/vim-commentary'
    bundle 'kien/ctrlp.vim'
    bundle 'ciaranm/detectindent'
    bundle 'lokaltog/vim-easymotion'
    bundle 'lokaltog/vim-powerline'
    bundle 'sjl/gundo.vim'
    bundle 'sjl/clam.vim'
    bundle 'mileszs/ack.vim'
    bundle 'godlygeek/tabular'

    " colorschemes
    bundle 'nanotech/jellybeans.vim'
    bundle 'sjl/badwolf'

    " language-specific bundles
    bundle 'vim-ruby/vim-ruby'
    bundle 'rodjek/vim-puppet'
    bundle 'davidoc/todo.txt-vim'
    "}}}

    " post-vundle settings
    filetype plugin indent on
endif

syntax enable
"}}}

" appearance/font -------------------------------------------------------- "{{{
if has("gui_running")
    " set font and window size based on operating system
    if has ("unix")
        if has ("gui_macvim")
            " must be macvim
            set guifont=monaco:h10
            set noantialias

            " full screen means full screen
            set fuoptions=maxvert,maxhorz
        else
            " must be linux
            set guifont=dejavu\ sans\ mono\ for\ powerline\ 8
        endif
    else
        " must be windows
        set guifont=dejavu\ sans\ mono\ for\ powerline:h9
    endif

    set guioptions-=m  "remove menu bar
    set guioptions-=t  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=r  "remove right-hand scroll bar for vert split
    set guioptions-=l  "remove left-hand scroll bar
    set guioptions-=l  "remove left-hand scroll bar for vert split
    set guioptions+=c  "use text-based dialogs instead of popups

    " different cursors for different modes.
    set guicursor=n-c:block-cursor-blinkon0
    set guicursor+=v:block-vcursor-blinkon0
    set guicursor+=i-ci:ver20-icursor
else
    " this is console vim.

    " mouse support
    set mouse=a
endif
"}}}

" colorscheme ------------------------------------------------------------ "{{{
set background=dark

" force terminal vim to use 256 colors
if !has("gui_running")
    set t_co=256
endif

" try/catch to set colorscheme
" vim will throw an error if the colorscheme doesn't exist, so we try another
" in the catch block
try
    colorscheme molokai
catch /^vim\%((\a\+)\)\=:e185/
    try
        colorscheme wombat256mod
    catch /^vim\%((\a\+)\)\=:e185/
        colorscheme desert
    endtry
endtry
"}}}

" standard options ------------------------------------------------------- "{{{
" statusline settings
" everything else defined in plugin/statusline.vim
" not used if powerline is loaded
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
"use vertical line (ctrl-k+vv) for vertical splits
"see :help digraphs
if !has("gui_running")
    set fillchars=vert:┃
endif

"window options
set splitbelow
set splitright

" per-project vimrc files
" useful for specifying things like tabstops
" disable on windows since it will complain if you're
" running in a path where it's not allowed.
if !has("win32")
    set exrc    " enable per-directory .vimrc files
    set secure  " disable unsafe commands in local .vimrc files
endif


" toggle whitespace in diffs {{{

set diffopt+=iwhite
let g:diffwhitespaceon = 1
function! togglediffwhitespace() "{{{
    if g:diffwhitespaceon
        set diffopt-=iwhite
        let g:diffwhitespaceon = 0
    else
        set diffopt+=iwhite
        let g:diffwhitespaceon = 1
    endif
    diffupdate
endfunc "}}}

nnoremap <leader>dw :call togglediffwhitespace()<cr>

" }}}
"}}}

" autocommands ----------------------------------------------------------- "{{{
if has("autocmd")
    " resize splits when the window is resized
    au vimresized * exe "normal! \<c-w>="
    " turn off paste mode when leaving insert mode
    au insertleave * set nopaste

    " todo.txt filetype
    augroup ft_todotxt
        au bufnewfile,bufread */todo/*.txt set filetype=todotxt
    augroup end

    " set ruby-specific formatting
    autocmd filetype ruby,puppet setlocal ts=2 sts=2 sw=2 expandtab

    " vim, vim helpfiles
    augroup ft_vim
        au!

        au filetype vim setlocal foldmethod=marker
        au filetype help setlocal textwidth=78
        " use enter to follow links
        au filetype help nmap <buffer> <cr> <c-]>
        au bufwinenter *.txt if &ft == 'help' | wincmd j | endif
    augroup end

    " return to last position when file is reopened
    autocmd bufreadpost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif
" }}}

" backup ----------------------------------------------------------------- "{{{
let vimbackupdir = $home . '/.vimbackup'
if exists("*mkdir")
    if !isdirectory(vimbackupdir)
        call mkdir(vimbackupdir)
    endif
endif
set backup
set noswapfile
let &backupdir=vimbackupdir
set history=1000

" make vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" undo feature requires > 7.3
if has("undofile")
    let vimundodir = $home . '/.vimundo'
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

set wildignore+=.hg,.git,.svn,cvs                " version control
set wildignore+=*.aux,*.out,*.toc                " latex intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " vim swap files
set wildignore+=*.ds_store                       " osx bullshit

set wildignore+=*.luac                           " lua byte code

set wildignore+=migrations                       " django migrations
set wildignore+=*.pyc                            " python byte code
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
"unmap help
inoremap <f1> <nop>
nnoremap <f1> <nop>
vnoremap <f1> <nop>

"up and down work with wrapped lines
nnoremap j gj
nnoremap k gk

" toggle number
nnoremap <leader>n :setlocal number!<cr>

" split line (sister to [j]oin lines)
" the normal use of s is covered by cc, so don't worry about shadowing it.
nnoremap s i<cr><esc><right>

" f5 = toggle paste mode
nnoremap <f5> :set invpaste paste?<enter>
inoremap <f5> <c-o><f5>
set pastetoggle=<f5>

" map easier-to-use keys
noremap h ^
noremap l $
vnoremap l g_

" gi already moves to "last place you exited insert mode", so we'll map gi to
" something similar: move to last change
nnoremap gi `.

" use enter to exit normal,visual,command mode
" use ctrl-o to create new line in insert mode
nnoremap <cr> <esc>
vnoremap <cr> <esc>gv
onoremap <cr> <esc>
inoremap <c-o> <cr>

" swap colon, semicolon
nnoremap ; :
nnoremap : ;

"sudo save if not root
cnoremap w!! w !sudo tee % >/dev/null

" remove search highlighting
nnoremap <leader><space> :nohlsearch<enter>

"open new vertical window and switch to it
nnoremap <leader>w <c-w>v<c-w>l
" easy window navigation
noremap <c-h> <c-w>h
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-l> <c-w>l

" simplify indentation
nnoremap > >>
nnoremap < <<
" indentation in vmode
" re-select visual selection after indent/outdent
vnoremap > >gv
vnoremap < <gv

" open a quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>


" change case
nnoremap <c-u> guiw
inoremap <c-u> <esc>guiwea
"
" remove trailing whitespace from entire buffer
nnoremap <leader>w :%s/\s\+$//<cr>:let @/=''<cr>

" insert blank line below
nnoremap <cr> o<esc>

" edit vimrc in new window, reload vimrc
if has("win32")
    nnoremap <leader>ev <c-w>v<c-w>j:e ~/dropbox/dotfiles/vimrc<cr>
    nnoremap <leader>sv :so ~/dropbox/dotfiles/vimrc<cr>
else
    nnoremap <leader>ev <c-w>v<c-w>j:e $myvimrc<cr>
    nnoremap <leader>sv :so $myvimrc<cr>
endif

" open current file's directory
nnoremap <leader>ew :e <c-r>=expand("%:p:h") . "/" <cr>

" substitute
nnoremap <leader>s :%s//<left>

" insert date
:nnoremap <f6> "=strftime("%y-%m-%d")<cr>p
:inoremap <f6> <c-r>=strftime("%y-%m-%d")<cr>

"}}}

" abbreviations ---------------------------------------------------------- "{{{

iabbrev myname stephen price <sprice@monsooncommerce.com>

"}}}

" folding ---------------------------------------------------------------- {{{
set foldlevelstart=0

" make the current location sane.
nnoremap <c-cr> zvzt

" space to toggle folds.
nnoremap <space> za
vnoremap <space> za

" make zo recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zo zczo

" use ,z to "focus" the current fold.
nnoremap <leader>z zmzvzz

function! myfoldtext() " {{{
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
set foldtext=myfoldtext()

" }}}

" numbertoggle() --------------------------------------------------------- "{{{
" switch between relative and absolute line numbers
" only works in vim >= 7.3
" ---------------------------------------------------------
function! numbertoggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunction

if exists("&relativenumber")
    set relativenumber
    nnoremap <leader>n :call numbertoggle()<cr>
else
    set number
endif
"}}}

" stab() ---------------------------------------------------------------- "{{{
" switch between tabs and spaces
" prompts for values or shows current values
" ---------------------------------------------------------

command! -nargs=* stab call stab()
function! stab()
  let l:tabstop = 1 * input('set shiftwidth=')

  if l:tabstop > 0
    " do we want expandtab as well?
    let l:expandtab = confirm('set expandtab?', "&yes\n&no\n&cancel")
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
    echohl modemsg
    echon 'set tabstop='
    echohl question
    echon &l:ts
    echohl modemsg
    echon ' shiftwidth='
    echohl question
    echon &l:sw
    echohl modemsg
    echon ' sts='
    echohl question
    echon &l:sts . ' ' . (&l:et ? '  ' : 'no')
    echohl modemsg
    echon 'expandtab'
  finally
    echohl none
  endtry
endfunction
"}}}

" plugins ----------------------------------------------------------------"{{{

" ctrl-p -------------------------------------------------------------------"{{{

let g:ctrlp_map = '<leader>,'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_jump_to_buffer = 2
let g:ctrlp_max_height = 15
let g:ctrlp_split_window = 0

nnoremap <leader>b :ctrlpbuffer<cr>

"}}}

" easymotion ---------------------------------------------------------------"{{{
" map specific functions to specific keys rather than let
" easymotion do the mapping
let g:easymotion_do_mapping = 0

<<<<<<< HEAD
nnoremap <silent> <Leader>f      :call EasyMotion#F(0, 0)<CR>
onoremap <silent> <Leader>f      :call EasyMotion#F(0, 0)<CR>
vnoremap <silent> <Leader>f :<C-U>call EasyMotion#F(1, 0)<CR>

nnoremap <silent> <Leader>F      :call EasyMotion#F(0, 1)<CR>
onoremap <silent> <Leader>F      :call EasyMotion#F(0, 1)<CR>
vnoremap <silent> <Leader>F :<C-U>call EasyMotion#F(1, 1)<CR>

onoremap <silent> <Leader>t      :call EasyMotion#T(0, 0)<CR>
onoremap <silent> <Leader>T      :call EasyMotion#T(0, 1)<CR>
=======
nnoremap <silent> <leader>f      :call EasyMotion#F(0, 0)<CR>
onoremap <silent> <leader>f      :call EasyMotion#F(0, 0)<CR>
vnoremap <silent> <leader>f :<C-U>call EasyMotion#F(1, 0)<CR>

nnoremap <silent> <leader>F      :call EasyMotion#F(0, 1)<CR>
onoremap <silent> <leader>F      :call EasyMotion#F(0, 1)<CR>
vnoremap <silent> <leader>F :<C-U>call EasyMotion#F(1, 1)<CR>

onoremap <silent> <leader>t      :call EasyMotion#T(0, 0)<CR>
onoremap <silent> <leader>T      :call EasyMotion#T(0, 1)<CR>
>>>>>>> da02a8380a9ffdabaf2d2c5de14ae7c90d837286

onoremap <silent> <Leader>j      :call EasyMotion#JK(0, 0)<CR>
onoremap <silent> <Leader>k      :call EasyMotion#JK(0, 1)<CR>

"}}}

" gundo -------------------------------------------------------------------"{{{

nnoremap <f4> :gundotoggle<cr>

"}}}

" clam --------------------------------------------------------------------"{{{

nnoremap <leader>l :clam<space>

"}}}

" tabular -----------------------------------------------------------------"{{{

" puppet: align resource parameters
vnoremap <leader>ap :tabularize /=><cr>

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

nnoremap <leader>e :errors<cr>
nnoremap <leader>s :syntasticcheck<cr>

"}}}

" powerline ---------------------------------------------------------------"{{{

let powerline_symbols = 'fancy'
"}}}

" ack ---------------------------------------------------------------------"{{{
" use ag if it's in path
" https://github.com/ggreer/the_silver_searcher
if executable("ag")
    let g:ackprg = 'ag --nogroup --nocolor --column'
endif

nnoremap <leader>a :ack!<space>

" ack motions {{{
" steve losh https://github.com/sjl/dotfiles

" motions to ack for things.  works with pretty much everything, including:
"
"   w, w, e, e, b, b, t*, f*, i*, a*, and custom text objects
"
" awesome.
"
" note: if the text covered by a motion contains a newline it won't work.  ack
" searches line-by-line.

" \aiw will search for the word under the cursor
" \aib will search inside braces
nnoremap <silent> \a :set opfunc=<sid>ackmotion<cr>g@
xnoremap <silent> \a :<c-u>call <sid>ackmotion(visualmode())<cr>

function! s:copymotionfortype(type)
    if a:type ==# 'v'
        silent execute "normal! `<" . a:type . "`>y"
    elseif a:type ==# 'char'
        silent execute "normal! `[v`]y"
    endif
endfunction

function! s:ackmotion(type) abort
    let reg_save = @@

    call s:copymotionfortype(a:type)

    execute "normal! :ack! --literal " . shellescape(@@) . "\<cr>"

    let @@ = reg_save
endfunction

" }}}
"}}}

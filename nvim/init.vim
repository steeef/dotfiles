" initial settings  ---------------------------------------------------------- "{{{

scriptencoding utf-8

let my_home = expand("$HOME/")
let viminit = expand(my_home . '.config/nvim/init.vim')

"}}}

" python --------------------------------------------------------------------- "{{{

" include python settings
if filereadable(my_home . '.config/nvim/python.vim')
  source ~/.config/nvim/python.vim
endif

"}}}

" vim-plug ------------------------------------------------------------------- "{{{

let bundlepath = "~/.config/nvim/bundle"

silent! call plug#begin(bundlepath)
" plugins ---------------------------------------------------------------------"{{{

if exists(":PlugInstall")
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-dispatch'
  Plug 'ConradIrwin/vim-bracketed-paste'
  Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
  Plug 'mileszs/ack.vim',      { 'on': 'Ack' }
  Plug 'junegunn/fzf',         { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/vim-easy-align'
  Plug 'jreybert/vimagit',     { 'on': 'Magit' }
  Plug 'airblade/vim-gitgutter'
  Plug 'w0rp/ale',             { 'for': [ 'python',
                                        \ 'ruby',
                                        \ 'sh',
                                        \ 'yaml',
                                        \ 'vim',
                                        \ 'puppet',
                                        \ 'ansible',
                                        \ 'json',
                                        \ 'go',
                                        \ 'markdown',
                                        \ 'html',
                                        \ 'docker',
                                        \ 'lua'] }

  " colorschemes
  Plug 'chriskempson/base16-vim'

  " language-specific bundles
  Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'jinja' }
  Plug 'avakhov/vim-yaml',         { 'for': 'yaml' }
  Plug 'chase/vim-ansible-yaml',   { 'for': 'ansible' }
  Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': 'tex' }
  Plug 'tpope/vim-markdown',       { 'for': 'markdown' }
  Plug 'davidhalter/jedi-vim',     { 'for': 'python' }
endif

"}}}

silent! call plug#end()

"}}}

" prefs  --------------------------------------------------------------------- "{{{

set modelines=0
set colorcolumn=85

" use both relative number and display current line
set relativenumber
set number

" mapping timeout
set ttimeout
set ttimeoutlen=50
set timeoutlen=1200

set shortmess=atI " Don't show the Vim intro message

" Allow unsaved background buffers and remember marks/undo for them
set hidden

" Jump to the first open window that contains the specified buffer
set switchbuf=useopen

" Auto-reload buffers when files are changed on disk
set autoread

" Wrapping
set wrap
set showbreak=↪\  " Character to precede line wraps
set textwidth=79

" Prevent Vim from clearing the scrollback buffer
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

"allow backspace to work for indents, between lines, and the start of insert mode
set backspace=indent,eol,start

"see :help fo-table
set formatoptions=qrn1
" Delete comment character when joining commented lines
set formatoptions+=j

"indent options
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set shiftround

"search options
set ignorecase
set smartcase
set nohlsearch
set showmatch

"matching
runtime macros/matchit.vim

"show formatting characters
"set list
set listchars=tab:»\ ,trail:·,extends:❯,precedes:❮

"use vertical line (CTRL-K+VV) for vertical splits
"see :help digraphs
set fillchars=vert:┃

"window options
set splitbelow
set splitright

"use system clipboard for default register
set clipboard+=unnamedplus

" backup --------------------------------------------------------------------- "{{{

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

let vimundodir = $HOME . '/.vimundo'
if !isdirectory(vimundodir)
  call mkdir(vimundodir)
endif
set undofile
let &undodir=vimundodir
set undolevels=1000
set undoreload=10000

"}}}

" wildmenu ------------------------------------------------------------------- "{{{

set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.svn,CVS                     " Version control
" ignoring .git has
" consequences
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=tags                             " ctags
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

"}}}

" folding -------------------------------------------------------------------- "{{{

set foldlevelstart=0

" Make the current location sane.
nnoremap <c-cr> zvzt

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

"}}}

" colorscheme ---------------------------------------------------------------- "{{{

set background=dark

" force terminal Vim to use 256 colors
set t_Co=256
let base16colorspace=256

" try/catch to set colorscheme
" Vim will throw an error if the colorscheme doesn't exist, so we try another
" in the catch block
try
  colorscheme base16-tomorrow-night
catch /^Vim\%((\a\+)\)\=:E185/
  try
    colorscheme molokai
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert
  endtry
endtry

"}}}

" statusline settings -------------------------------------------------------- "{{{

set laststatus=2

" Status: {{{
function! Status(winnum)
  let active = a:winnum == winnr()
  let bufnum = winbufnr(a:winnum)

  let stat = ''

  " this function just outputs the content colored by the
  " supplied colorgroup number, e.g. num = 2 -> User2
  " it only colors the input if the window is the currently
  " focused one

  function! Color(active, num, content)
    if a:active
      return '%' . a:num . '*' . a:content . '%*'
    else
      return a:content
    endif
  endfunction

  " this handles alternative statuslines
  let usealt = 0
  let altstat = Color(active, 4, ' »')

  let type = getbufvar(bufnum, '&buftype')
  let name = bufname(bufnum)

  if type ==# 'help'
    let altstat .= ' ' . fnamemodify(name, ':t:r')
    let usealt = 1
  elseif name ==# '__Gundo__'
    let altstat .= ' Gundo'
    let usealt = 1
  elseif name ==# '__Gundo_Preview__'
    let altstat .= ' Gundo Preview'
    let usealt = 1
  endif

  if usealt
    let altstat .= Color(active, 4, ' «')
    return altstat
  endif

  " column
  "   this might seem a bit complicated but all it amounts to is
  "   a calculation to see how much padding should be used for the
  "   column number, so that it lines up nicely with the line numbers

  "   an expression is needed because expressions are evaluated within
  "   the context of the window for which the statusline is being prepared
  "   this is crucial because the line and virtcol functions otherwise
  "   operate on the currently focused window

  function! Column()
    let vc = virtcol('.')
    let ruler_width = max([strlen(line('$')), (&numberwidth - 1)])
    let column_width = strlen(vc)
    let padding = ruler_width - column_width
    let column = ''

    if padding <= 0
      let column .= vc
    else
      " + 1 becuase for some reason vim eats one of the spaces
      let column .= repeat(' ', padding + 1) . vc
    endif

    return column . ' '
  endfunction

  let stat .= '%1*'
  let stat .= '%{Column()}'
  let stat .= '%*'

  " file name
  let stat .= Color(active, 4, active ? ' »' : ' «')
  let stat .= ' %<'
  let stat .= '%f'
  let stat .= ' ' . Color(active, 4, active ? '«' : '»')

  " file modified
  let modified = getbufvar(bufnum, '&modified')
  let stat .= Color(active, 2, modified ? ' +' : '')

  " read only
  let readonly = getbufvar(bufnum, '&readonly')
  let stat .= Color(active, 2, readonly ? ' ‼' : '')

  " paste
  if active && &paste
    let stat .= ' %2*' . 'P' . '%*'
  endif

  " right side
  let stat .= '%='

  " git branch
  if exists('*fugitive#head')
    let head = fugitive#head()

    if empty(head) && exists('*fugitive#detect') && !exists('b:git_dir')
      call fugitive#detect(getcwd())
      let head = fugitive#head()
    endif

    if !empty(head)
      let stat .= Color(active, 3, ' ← ') . head . ' '
    endif
  endif

  return stat
endfunction
" }}}

" Status AutoCMD: {{{

function! s:RefreshStatus()
  for nr in range(1, winnr('$'))
    call setwinvar(nr, '&statusline', '%!Status(' . nr . ')')
  endfor
endfunction

augroup status
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * call <SID>RefreshStatus()
augroup END

" }}}

" Status Colors: {{{

hi User1 ctermfg=33  guifg=#268bd2  ctermbg=19  guibg=#373b41
hi User2 ctermfg=125 guifg=#d33682  ctermbg=19  guibg=#373b41
hi User3 ctermfg=64  guifg=#719e07  ctermbg=19  guibg=#373b41
hi User4 ctermfg=37  guifg=#2aa198  ctermbg=19  guibg=#373b41

" }}}

"}}}

" autocommands --------------------------------------------------------------- "{{{

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="
" turn off PASTE mode when leaving insert mode
au InsertLeave * set nopaste

augroup ft_git
  autocmd!
  " Place the cursor at the top of the buffer
  autocmd VimEnter .git/COMMIT_EDITMSG exe 'normal! gg'
augroup END

" vim, vim helpfiles
augroup ft_vim
  autocmd!

  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType help setlocal textwidth=78
  " use Enter to follow links
  autocmd FileType help nmap <buffer> <CR> <C-]>
  autocmd BufWinEnter *.txt if &ft == 'help' | wincmd J | endif
augroup END

" Return to last position when file is reopened
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

"}}}

"}}}

" mapping -------------------------------------------------------------------- "{{{

let mapleader="\<Space>"

" Swap colon, semicolon
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

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

" simplify macro playback
nnoremap Q @q

" gi already moves to "last place you exited insert mode", so we'll map gI to
" something similar: move to last change
nnoremap gI `.

" Use Enter to exit normal,visual,command mode
nnoremap <CR> <Esc>
vnoremap <CR> <Esc>gV
onoremap <CR> <Esc>
" Use CTRL-O to create new line in insert mode
inoremap <C-o> <CR>

" sudo save if not root
cnoremap w!! w !sudo tee % >/dev/null <CR> :e! <CR>

" reselect indented text for quick indentation change
vnoremap < <gv
vnoremap > >gv

" Remove trailing whitespace from entire buffer
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" insert blank line below
nnoremap <CR> o<ESC>

" Quickly edit/reload this configuration file
nnoremap <leader>ev :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>sv :so ~/.config/nvim/init.vim<CR>

" windows -------------------------------------------------------------------- "{{{

" open new vertical window and switch to it
nnoremap <leader>w <C-w>v<C-w>l

" open new vertical window for terminal and switch to it
nnoremap <leader>t <C-w>v<C-w>l:terminal<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"}}}

" terminal ------------------------------------------------------------------- "{{{

" enter insert mode when entering terminal
autocmd BufEnter term://* startinsert

" ESC to go back to normal mode
tnoremap <Esc> <C-\><C-n>

" Easier motion between buffers
tmap <C-j> <ESC><C-j>
tmap <C-h> <ESC><C-h>
tmap <C-l> <ESC><C-l>
tmap <C-k> <ESC><C-k>

"}}}

"}}}

" plugin settings ------------------------------------------------------------ "{{{

" easy-align ------------------------------------------------------------------"{{{

vnoremap <silent> <Enter> :EasyAlign<Enter>

"}}}

" Ack -------------------------------------------------------------------------"{{{

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

" vim-gitgutter ---------------------------------------------------------------"{{{
let g:gitgutter_map_keys = 0
"}}}

" fzf -------------------------------------------------------------------------"{{{

nnoremap <leader><Space> :FZF<enter>

" List of buffers
function! BufList()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! BufOpen(e)
  execute 'buffer '. matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>b :call fzf#run({
      \   'source':      reverse(BufList()),
      \   'sink':        function('BufOpen'),
      \   'options':     '+m',
      \   'tmux_height': '40%'
      \ })<CR>

"}}}

" vim-commentary --------------------------------------------------------------"{{{
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
"}}}

" LaTeX-Box -------------------------------------------------------------------"{{{
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_viewer = "open -a Skim"
"}}}

" ale -------------------------------------------------------------------------"{{{
let g:ale_python_pylint_options = '--max-line-length=100'
let g:ale_python_flake8_args = '--max-line-length=100'
"}}}

"}}}

" Python --------------------------------------------------------------------- "{{{

let my_home = expand("$HOME/")

" include python settings
if filereadable(my_home . '.config/nvim/python.vim')
  source ~/.config/nvim/python.vim
endif

"}}}

" Mapping -------------------------------------------------------------------- "{{{

let mapleader="\<Space>"

" Swap colon, semicolon
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

"}}}

" Windows -------------------------------------------------------------------- "{{{

" open new vertical window and switch to it
nnoremap <leader>w <C-w>v<C-w>l

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"}}}

" Terminal ------------------------------------------------------------------- "{{{

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

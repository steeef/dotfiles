set t_Co=256
colorscheme mustang

if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=100 columns=150
  set guifont=Consolas:h9:cANSI
else
  " This is console Vim.
  if exists("+lines")
    set lines=60
  endif
  if exists("+columns")
    set columns=150
  endif
endif


filetype off
filetype plugin indent on

set nocompatible
set modelines=0

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

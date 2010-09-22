if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=100 columns=150
  set guifont=Consolas:h9
else
  " This is console Vim.
  set t_Co=256
  if exists("+lines")
    set lines=60
  endif
  if exists("+columns")
    set columns=150
  endif
endif

colorscheme mustang


filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

set nocompatible
set modelines=0

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

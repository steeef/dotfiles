scriptencoding utf-8
set encoding=utf-8

silent! call plug#begin()
if exists(":PlugInstall")
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

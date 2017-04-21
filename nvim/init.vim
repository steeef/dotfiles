let my_home = expand("$HOME/")

if filereadable(my_home . '.config/nvim/python.vim')
  source ~/.config/nvim/python.vim
endif

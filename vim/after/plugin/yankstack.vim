" after plugin yankstack.vim
"

" yankstack creates its own map, so remap afterwards
" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc><right>

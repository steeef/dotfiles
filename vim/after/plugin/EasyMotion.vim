" EasyMotion.vim after plugin
"
" I want to remap default keys only if EasyMotion has been loaded, so these
" mappings can't go in vimrc.
"
" Use EasyMotion for regular f/t mappings.
if exists('EasyMotion_loaded')
    nnoremap <silent> f      :call EasyMotion#F(0, 0)<CR>
    onoremap <silent> f      :call EasyMotion#F(0, 0)<CR>
    vnoremap <silent> f :<C-U>call EasyMotion#F(1, 0)<CR>

    nnoremap <silent> F      :call EasyMotion#F(0, 1)<CR>
    onoremap <silent> F      :call EasyMotion#F(0, 1)<CR>
    vnoremap <silent> F :<C-U>call EasyMotion#F(1, 1)<CR>

    onoremap <silent> t      :call EasyMotion#T(0, 0)<CR>
    onoremap <silent> T      :call EasyMotion#T(0, 1)<CR>

    onoremap <silent> <Leader>j      :call EasyMotion#JK(0, 0)<CR>
    onoremap <silent> <Leader>k      :call EasyMotion#JK(0, 1)<CR>
endif

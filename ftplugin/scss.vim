setl makeprg=polycompile\ %:p:h
nnoremap <buffer> <leader>c :w<cr>:let $REFRESH=0<cr>:MakeJob<cr>
nnoremap <buffer> <leader>C :w<cr>:let $REFRESH=1<cr>:MakeJob<cr>

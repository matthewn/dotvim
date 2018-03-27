compiler sass
setl makeprg=polycompile\ %:p:h
"setl makeprg=polycompile\ %:p:h\ \\\|\ sed\ 's/^>>\ //'
nnoremap <buffer> <leader>c :w<cr>:let $REFRESH=0<cr>:MakeJob<cr>
nnoremap <buffer> <leader>C :w<cr>:let $REFRESH=1<cr>:MakeJob<cr>

" %A signals start of multiline error message; %m matches the msg itself
"let &efm  = '%AError: %m' . ','
" %C signals continuation of the multiline error
" match any number of spaces (' %#': equivalent to regexp ' *')
" get line # (%l) and filename (%f)
"let &efm .= '%C %#on line %l of %f' . ','
" %Z signals last line of multiline error message
" %p^ means a string of spaces and then a ^ to get the column number
"let &efm .= '%Z %#%p^' . ','
" ignore any other lines (must be last!)
"let &efm .= '%-G%.%#'

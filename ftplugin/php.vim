setl tabstop=2
setl softtabstop=2
setl shiftwidth=2

" avoids errant beeps
setl matchpairs=(:),[:],{:}

" idea taken from http://vim.wikia.com/wiki/VimTip598
setl keywordprg=~/bin/php_doc

" include drupal 7 dictionary
setl dict +=~/.vim/dictionaries/drupal7.dict

" php case statement indenting
let g:PHP_vintage_case_default_indent = 1

" php SQL inside strings
let php_sql_query = 1

" php HTML inside strings
let php_htmlInStrings = 1

" open/close folds on php functions
let php_folding = 1

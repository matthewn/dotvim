" better navigation for vim help
" taken from _Hacking Vim_ by Kim Shultz (Packt Publishing), p. 56

nmap <buffer> <CR> <C-]>
nmap <buffer> <BS> <C-T>
nmap <buffer> o /''[a-z]\{2,\}''<CR>
nmap <buffer> O ?''[a-z]\{2,\}''<CR>
nmap <buffer> s /\|\S\+\|<CR>
nmap <buffer> S ?\|\S\+\|<CR>

augroup filetypedetect
  au BufNewFile,BufRead *.html    set indentexpr= | set smartindent | set autoindent
  au BufNewFile,BufRead *.shtml   set indentexpr= | set smartindent | set autoindent
  au BufNewFile,BufRead *.blog    setf html | set lbr | set spell
  au BufNewFile,BufRead *.module  setf php | set tabstop=2 | set softtabstop=2 | set shiftwidth=2
  au BufNewFile,BufRead *.install setf php | set tabstop=2 | set softtabstop=2 | set shiftwidth=2
  au BufNewFile,BufRead *.inc     setf php | set tabstop=2 | set softtabstop=2 | set shiftwidth=2
  au BufNewFile,BufRead *.css     set tabstop=2 | set softtabstop=2 | set shiftwidth=2
augroup END

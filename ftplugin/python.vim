setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

" If we're editing a file that belongs to a project that contains
" a pipenv-controlled virtualenv, then ensure vim's python knows
" about that env.
"
" inspired by: https://duseev.com/articles/vim-python-pipenv/
" and also by: https://stackoverflow.com/a/4017158/546468
"
" IMPORTANT: this code assumes that 'autochdir' is set!
let pipenv_venv_path = system('pipenv --venv')
if shell_error == 0
  let venv_path = substitute(pipenv_venv_path, '\n', '', '')
  let activate_this = venv_path . '/bin/activate_this.py'
  if getftype(venv_path) == "dir" && filereadable(activate_this)
      python3 << EOF

import sys, vim
venv_path = vim.eval('venv_path')
do_it = True
for path in sys.path:
  if venv_path in path:
    do_it = False
    continue
if do_it:
  activate_this = vim.eval('activate_this')
  exec(open(activate_this).read(), {'__file__': activate_this})
  print('python virtualenv detected and added to path')
EOF

  endif
endif

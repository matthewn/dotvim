" /\/\/\/ vimrc BEGIN
" reminder: zR opens all folds; zM closes

" VIM SETTINGS
  set confirm     " confirm dialog instead of fail
  set background=dark
  set backspace=indent,eol,start " allow b/s over everything in insert mode
  set dict +=~/.vim/dictionaries/wordlist.dict
  set directory=~/.vim/tmp//
  set encoding=utf-8
  set expandtab
  set foldmethod=indent
  set hidden       " abandoned buffers get hidden, not unloaded
  set history=100
  set iskeyword-=_ " make _ act as a word boundary
  set mousemodel=popup_setpos
  set noequalalways
  set nofoldenable
  set printfont=:h09
  set scrolloff=10
  set shiftround
  set shiftwidth=2
  set showcmd     " display incomplete commands in status bar
  set showmatch
  set softtabstop=2
  set tabstop=2
  set ttyfast
  set wildmenu    " waaaaay better tab completion
  set wildmode=list:longest,full
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip

  set incsearch   " do incremental searching
  set ignorecase  "   make / searches ignore case
  set smartcase   "   unless there's a capital in the expression

  if has('mouse')
    set mouse=a
  endif
  if has('persistent_undo')
    set undofile
    set undodir=$HOME/.vim/undo,/tmp
  endif

" PACKAGES BY MINPAC
  packadd minpac
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('airblade/vim-rooter') " auto change cwd to project root (.git)
  call minpac#add('alvan/vim-php-manual') " PHP docs for Shift-K, etc.
  call minpac#add('AndrewRadev/ember_tools.vim') " ember.js niceties
  call minpac#add('joukevandermaas/vim-ember-hbs') " ember.js hbs syntax highlighting
  call minpac#add('bling/vim-bufferline') " essential
  call minpac#add('ctrlpvim/ctrlp.vim') " essential
  call minpac#add('dyng/ctrlsf.vim') " search/replace across files visually
  call minpac#add('junegunn/vim-easy-align') " <enter> in visual mode
  call minpac#add('gioele/vim-autoswap') " auto-swap to the correct window
  call minpac#add('gregsexton/gitv') " fugitive extension: git browser at :Gitv
  call minpac#add('int3/vim-extradite') " :Extradite to view git log of current file
  call minpac#add('keith/investigate.vim') " gK for information on word at cursor
  call minpac#add('mbbill/undotree') " gundo replacement; essential
  call minpac#add('mhinz/vim-grepper') " replacement for ack; uses rg
  call minpac#add('mikewest/vimroom') " <leader>V to toggle; do i use this?
  call minpac#add('milkypostman/vim-togglelist') " <leader>q toggles quickfix; <leader>l toggles location
  call minpac#add('nathanaelkane/vim-indent-guides') " pretty
  call minpac#add('nelstrom/vim-qargs') " :Qargs moves quicklist items to arglist
  call minpac#add('rhysd/clever-f.vim') " improve f and F searches; no need for ; or ,
  call minpac#add('scrooloose/nerdtree') " essential
  call minpac#add('severin-lemaignan/vim-minimap') " sublime minimap clone
  call minpac#add('tomtom/checksyntax_vim') " essential; check syntax on save
  call minpac#add('tomtom/tcomment_vim') " essential; gc to comment/uncomment
  call minpac#add('tpope/vim-fugitive') " essential
  call minpac#add('tpope/vim-ragtag') " useful html-related mappings
  call minpac#add('tpope/vim-surround') " essential
  call minpac#add('tpope/vim-unimpaired') " handy mappings
  call minpac#add('vim-airline/vim-airline') " essential
  call minpac#add('vim-airline/vim-airline-themes')
  call minpac#add('vim-scripts/BufOnly.vim') " :BufOnly <leader>o closes all but current buffer; do I use this?
  call minpac#add('vim-scripts/ColorSchemeEditor') " nifty
  call minpac#add('vim-scripts/LargeFile') " make vim handle large files more gracefully
  call minpac#add('vim-scripts/matchit.zip') " make % much smarter
  call minpac#add('vim-scripts/taglist.vim') " <leader>t
  call minpac#add('whatyouhide/vim-gotham') " dark colorscheme
  call minpac#add('xolox/vim-easytags') " auto generation of tagfiles in ~/.vimtags
  call minpac#add('xolox/vim-misc') " dependency for xolox scripts
  call minpac#add('xolox/vim-session') " better vim sessions! :SaveSession & :OpenSession
  "following plugin breaks checksyntax_vim :(
  "call minpac#add('psynaptic/vim-drupal')

" COLOR DEPENDENT SETTINGS
  if &t_Co > 2 || has("gui_running")
    if has ("vim_starting") | colorscheme gotham256 | endif
    if !exists("g:syntax_on") | syntax enable | endif
    set hlsearch
    " make tabs stand out in color terminal
    highlight TabLine term=underline cterm=bold ctermfg=7 ctermbg=0
    highlight TabLineSel term=bold cterm=bold ctermfg=lightyellow
    " highlight trailing whitespace
    highlight ExtraWhitespace ctermbg=red guibg=purple
    match ExtraWhitespace /\s\+$/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
    " highlight 81st column on long lines only
    highlight ColorColumn ctermbg=magenta guibg=DarkRed
    call matchadd('ColorColumn', '\%81v', 100)
    " completion colors
    highlight Pmenu guifg=#aaeeee guibg=#111111
    " indent_guides on by default (vim-indent-guides bundle)
    let g:indent_guides_enable_on_vim_startup = 1
  endif

" GVIM SETTINGS
  if v:progname =~? "gvim"
    set guioptions-=T " remove toolbar
    "set guioptions-=m " remove menubar
    " use gtklp for printing if we're on a linux box
    if has("unix")
      set printexpr=system('gtklp'\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error
    endif
    " linux laptop size & font
    if has("unix") && match(system('hostname'), 'vardaman') == 0 || match(system('hostname'), 'cash') == 0
        set lines=43
        set columns=90
        set guifont=Ubuntu\ Mono\ 12
    else
        set lines=110
        set columns=100
    endif
    " windows gui font
    if has("win32") || has("win64")
      set guifont=Lucida_Sans_Typewriter:h10:cANSI
    endif
  endif

" AUTOCOMMANDS
  if has("autocmd")
    " put these in an autocmd group (so we can delete them easily)
    augroup vimrcEx
      " clear out the augroup
      " http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
      autocmd!
      " when editing a file, always jump to the last known cursor position.
      " (don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim))
      au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
      " reload vimrc on save
      au BufWritePost .vimrc,vimrc source %
      " compile sassy css on save
      au BufWritePost,FileWritePost *.scss :!~/bin/polycompile <afile>:p:h
      au BufNewFile,BufRead *.blog setf html | set lbr | set spell
      au BufNewFile,BufRead *.module,*.install,*.inc setf php
    augroup END
  else
    set autoindent
  endif

" COMMANDS
  " minpac
  command! PackUpdate call minpac#update()
  command! PackClean call minpac#clean()
  " font twiddling
  command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
  command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

" KEY REMAPPINGS *************************************** [nore = don't recurse]
  let mapleader = ","

  " make up and down arrows NOT linewise in insert mode
    inoremap <Up> <C-\><C-o>gk
    inoremap <Down> <C-\><C-o>gj

  " mswin-style cut/copy/paste (from $VIMRUNTIME/mswin.vim)
    vnoremap <C-X> "+x
    vnoremap <C-C> "+y
    map <C-V> "+gP
    cmap <C-V> <C-R>+
    exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
    " <C-Q> for what <C-V> used to do (blockwise visual mode)
    noremap <C-Q> <C-V>

  " make standard mappings behave a bit differently
    " avoid useless Ex mode, reassign Q to reflow/rewrap
    map Q gq
    " make Y effect to end of line instead of whole line
    map Y y$
    " reselect visual block after indent/outdent
    vnoremap < <gv
    vnoremap > >gv

  " custom mappings
    " easy escape
    inoremap jj <esc>
    " warp speed omnicomplete: map ';;' to trigger in insert mode
    imap ;; <C-x><C-o>
    " switch between buffers with ctrl-tabs
    nmap <C-tab> :bnext<CR>
    nmap <C-S-tab> :bprev<CR>
    imap <C-tab> <esc>:bnext<CR>
    imap <C-S-tab> <esc>:bprev<CR>
    " shortcut to .vimrc
    nmap <leader>v :e $MYVIMRC<cr>
    " clear the search highlights
    nnoremap <silent> g<space> :nohlsearch<cr>
    " toggle line wrap
    nmap <silent> <leader>W :silent set wrap!<cr>:set wrap?<cr>
    " toggle line numbering
    nmap <silent> <leader># :silent set number!<cr>:set number?<cr>
    " quick substitution setup
    nmap <leader>% :%s//g<left><left>
    " remove trailing spaces on entire buffer without altering the cursor position
    nmap <silent> <leader>SS :silent %s/\s\+$<cr>:normal ``<cr>
    " :SaveSession
    nmap <leader>ss :SaveSession<space>
    " :OpenSession
    nmap <leader>oo :OpenSession<cr>
    " fold tag
    nnoremap <leader>zT Vatzf
    " write with sudo, dammit
    cmap w!! w !sudo tee % >/dev/null
    " write and refresh in browser
    cmap ww<cr> w<cr> :silent! !~/bin/refresh<cr>
    " make moving between windows easier
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
    " edit file, starting in same directory as current file
    map <leader>e :e <C-R>=expand("%:p:h") . "/" <cr>
    " maximize window
    nnoremap <leader><space> :silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz<cr>
    " tab stop changes
    nnoremap <leader>2 :set tabstop=2<cr><Esc>:set softtabstop=2<cr><Esc>:set shiftwidth=2<cr>
    nnoremap <leader>4 :set tabstop=4<cr><Esc>:set softtabstop=4<cr><Esc>:set shiftwidth=4<cr>
    nnoremap <leader>8 :set tabstop=8<cr><Esc>:set softtabstop=8<cr><Esc>:set shiftwidth=4<cr>
    " this used to point at bufkill.vim's :BD
    nnoremap <silent> gx :bd<cr>
    " edit macro
    nnoremap <leader>q  :<c-u><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
    " autoclose quickfix on selection
    autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

  " plugin access remappings
    " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
    vmap <Enter> <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
    nmap <Leader>a <Plug>(EasyAlign)
    " ctrlp.vim
    nnoremap <silent> <leader>m :CtrlPMRUFiles<cr>
    nnoremap <silent> <leader>f :CtrlP<cr>
    nnoremap <silent> <leader>b :CtrlPBuffer<cr>
    " vim-grepper
    nnoremap <leader>g :GrepperRg<space>
    " undotree
    nnoremap <leader>u :UndotreeToggle<cr>
    " nerdtree
    nnoremap <leader>n :NERDTreeToggle<cr>
    nnoremap <leader>N :NERDTreeFind<cr>
    " taglist
    nnoremap <leader>t :TlistToggle<cr>
    " ctrlsf
    nnoremap <leader>a :CtrlSF<space>
    " bufonly
    nnoremap <leader>o :BufOnly<cr>
    " font twiddling
    nmap g= :Bigger<cr>
    nmap g- :Smaller<cr>

  " blog input mappings
    map <leader>a gewi<a href=""><Esc>ea</a><Esc>F>hi
    vmap <leader>a di<a href=""<Esc>mza><Esc>pa</a><Esc>`zi
    vmap <leader>i di<i>pa</i>
    vmap <leader>b di<b>pa</b>
    map <leader>I i<img src="" class="" width="" height="" alt="" /><Esc>
    map <leader>d <Esc>:%s#\n\n#\r<br /><br />\r#g<cr>
    map <leader>M i<!-- more --><Esc>

" PLUGIN SETTINGS
  " airline
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline_section_warning = ''
  let g:airline#extensions#tagbar#enabled = 0
  let g:airline_section_x = ''
  let g:airline_section_y = ''
  let g:airline_left_sep=''
  let g:airline_right_sep=''
  let g:airline_mode_map = {'__': '-', 'n': 'N', 'i': 'I', 'R': 'R', 'c': 'C', 'v': 'V', 'V': 'V', 's': 'S', 'S': 'S',}
  " bufferline
  set laststatus=2
  let g:bufferline_show_bufnr = 0
  let g:bufferline_rotate = 2
  let g:bufferline_modified = '+'
  let g:bufferline_fname_mod = ':t'
  let g:bufferline_pathshorten = 1
  let g:bufferline_echo = 0
  " checksyntax: force on save for php, js
  let g:checksyntax#auto_enable_rx = 'php\|javascript'
  " ctrlsf
  let g:ctrlsf_position = 'bottom'
  " ctrlp
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
  let g:ctrlp_match_window_reversed = 1
  let g:ctrlp_mruf_max = 250
  " minimap
  let g:minimap_show='<leader>MS'
  let g:minimap_update='<leader>MU'
  let g:minimap_close='<leader>MC'
  let g:minimap_toggle='<leader>MM'
  " nerdtree
  let NERDTreeMinimalUI=1
  let NERDTreeDirArrows=1
  let NERDTreeMapQuit='<Esc>'
  let NERDTreeQuitOnOpen = 1
  " taglist
  let Tlist_Use_Right_Window = 1
  let Tlist_Compact_Format = 1
  let Tlist_File_Fold_Auto_Close = 1
  let Tlist_Exit_OnlyWindow = 1
  let Tlist_Show_One_File = 1
  let Tlist_WinWidth = 35
  let tlist_php_settings = 'php;f:function'
  " undotree
  let g:undotree_SetFocusWhenToggle = 1
  " vim-grepper
  let g:rooter_silent_chdir = 1
  " vim-session
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'

" /\/\/\/ vimrc END

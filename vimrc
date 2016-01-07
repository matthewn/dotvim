" /\/\/\/ vimrc BEGIN

" CORE SETTINGS
  set backspace=indent,eol,start " allow b/s over everything in insert mode
  set history=100
  set ruler
  set showcmd     " display incomplete commands in status bar
  set incsearch   " do incremental searching
  set ignorecase      " / searches ignore case
  set smartcase       "   unless there's a capital in the expression
  set hidden      " abandoned buffers get hidden, not unloaded
  set wildmenu    " waaaaay better tab completion
  set wildmode=list:longest,full
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip
  set confirm
  set showmatch
  set expandtab
  set shiftwidth=2
  set softtabstop=2
  set shiftround
  set tabstop=2
  set scrolloff=10
  set printfont=:h09
  set mousemodel=popup_setpos
  set noequalalways
  set encoding=utf-8
  set ttyfast
  set background=dark
  set dict +=~/.vim/dictionaries/wordlist.dict
  set autochdir
  set foldmethod=indent
  set nofoldenable
  set directory=~/.vim/tmp//
  set iskeyword-=_ " make _ act as a word boundary
  if has('mouse')
    set mouse=a
  endif

" VERSION DEPENDENT SETTINGS
  " persistent undo is only in vim ≥ 7.3
  if v:version >= 703 " or if has('persistent_undo')
    set undofile
    set undodir=$HOME/.vim/undo,/tmp
  endif

" VIM-PLUG
  call plug#begin('~/.vim/bundle')
  "Plug 'airblade/vim-gitgutter'
  Plug 'alvan/vim-php-manual' " PHP docs for Shift-K, etc.
  Plug 'bling/vim-airline' " essential
  Plug 'bling/vim-bufferline' " essential
  Plug 'ctrlpvim/ctrlp.vim' " essential
  Plug 'dyng/ctrlsf.vim' " search/replace across files visually
  Plug 'junegunn/vim-easy-align' " <enter> in visual mode
  Plug 'gregsexton/gitv' " fugitive extension: git browser at :Gitv
  Plug 'int3/vim-extradite' " :Extradite to view git log of curent file
  Plug 'justinmk/vim-sneak' " s{char}{char} to move to it
  Plug 'KabbAmine/zeavim.vim' " integration with zeal doc reader
  Plug 'keith/investigate.vim' " gK for information on word at cursor
  Plug 'mikewest/vimroom' " <leader>V to toggle; do i use this?
  Plug 'mileszs/ack.vim' " essential
  Plug 'milkypostman/vim-togglelist' " <leader>q toggles quickfix; <leader>l toggles location
  Plug 'nathanaelkane/vim-indent-guides' " pretty
  Plug 'nelstrom/vim-qargs' " :Qargs moves quicklist items to arglist
  Plug 'scrooloose/nerdtree' " essential
  "Plug 'scrooloose/syntastic' " essential
  Plug 'severin-lemaignan/vim-minimap' " sublime minimap clone
  Plug 'Shougo/unite.vim'
  Plug 'sjl/gundo.vim' " essential
  Plug 'tomtom/checksyntax_vim' " essential; check syntax on save
  Plug 'tomtom/tcomment_vim' " essential; gc to comment/uncomment
  Plug 'tpope/vim-fugitive' " essential
  Plug 'tpope/vim-ragtag' " useful html-related mappings
  Plug 'tpope/vim-surround' " essential
  Plug 'tpope/vim-unimpaired' " handy mappings
  Plug 'vim-scripts/BufOnly.vim' " :BufOnly <leader>o closes all but current buffer; do I use this?
  Plug 'vim-scripts/ColorSchemeEditor' " no longer works?
  Plug 'vim-scripts/LargeFile' " make vim handle large files more gracefully
  Plug 'vim-scripts/Smart-Home-Key' " does what it says on the tin; do I use this?
  Plug 'vim-scripts/matchit.zip' " make % much smarter
  Plug 'vim-scripts/taglist.vim' " <leader>t
  Plug 'whatyouhide/vim-gotham' " dark colorscheme
  Plug 'xolox/vim-easytags' " auto generation of tagfiles in ~/.vimtags
  Plug 'xolox/vim-misc' " dependency for xolox scripts
  Plug 'xolox/vim-session' " makes vim sessions work the way they should; :SaveSession and :OpenSession
  "Plug 'Xuyuanp/nerdtree-git-plugin' " git statuses in nerdtree
  "following plugin breaks checksyntax_vim :(
  "Plug 'psynaptic/vim-drupal'
  call plug#end()

" COLOR SETTINGS
  if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
    " make tabs stand out in color terminal
    highlight TabLine term=underline cterm=bold ctermfg=7 ctermbg=0
    highlight TabLineSel term=bold cterm=bold ctermfg=lightyellow
    " indent_guides on by default (vim-indent-guides bundle)
    let g:indent_guides_enable_on_vim_startup = 1
  endif

" GVIM SETTINGS
  if v:progname =~? "gvim"
    set guioptions-=T
    "set guioptions-=m
    colorscheme nocturne
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
    highlight Pmenu guifg=#aee guibg=#111
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
      "au BufWritePost,FileWritePost *.scss :!compass compile --boring <afile>:p:h:h
      au BufWritePost,FileWritePost *.scss :!~/bin/compile_compass <afile>:p:h
      au BufNewFile,BufRead *.blog setf html | set lbr | set spell
      au BufNewFile,BufRead *.module,*.install,*.inc setf php
    augroup END
  else
    set autoindent
  endif

" KEY REMAPPINGS *************************************** [nore = don't recurse]

    "let mapleader = "\<space>"
    let mapleader = ","

  " make up and down arrows not linewise in insert mode
    imap <Up> <C-o>gk
    imap <Down> <C-o>gj

  " mswin-style cut/copy/paste (from $VIMRUNTIME/mswin.vim)
    vnoremap <C-X> "+x
    vnoremap <C-C> "+y
    map <C-V> "+gP
    cmap <C-V> <C-R>+
    exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
    " <C-Q> for what <C-V> used to do (blockwise visual mode)
    noremap <C-Q> <C-V>

  " don't use Ex mode, use Q for formatting
    map Q gq

  " make Y effect to end of line instead of whole line
    map Y y$

  " reselect visual block after indent/outdent
    vnoremap < <gv
    vnoremap > >gv

  " blog input mappings
    map <leader>a gewi<a href=""><Esc>ea</a><Esc>F>hi
    vmap <leader>a di<a href=""<Esc>mza><Esc>pa</a><Esc>`zi
    vmap <leader>i di<i>pa</i>
    vmap <leader>b di<b>pa</b>
    map <leader>I i<img src="" class="" width="" height="" alt="" /><Esc>
    map <leader>d <Esc>:%s#\n\n#\r<br /><br />\r#g<cr>
    map <leader>M i<!-- more --><Esc>

  " remappings
    " easy escape
    inoremap jj <esc>
    " warp speed auto-complete: map ';;' to trigger in insert mode
    imap ;; <C-x><C-o>
    " switch between buffers with ctrl-tabs
    nmap <C-tab> :bnext<CR>
    nmap <C-S-tab> :bprev<CR>
    imap <C-tab> <esc>:bnext<CR>
    imap <C-S-tab> <esc>:bprev<CR>
    " shortcut to get here [.vimrc]
    nmap <leader>v :e $MYVIMRC<cr>
    " clear the search highlights
    nnoremap <silent> g<space> :nohlsearch<cr>
    " toggle line wrap
    nmap <silent> <leader>W :silent set wrap!<cr>:set wrap?<cr>
    " toggle line numbering
    nmap <silent> <leader># :silent set number!<cr>:set number?<cr>
    " remove trailing spaces on the current line
    nmap <silent> <leader>s :silent s/\s\+$<cr>
    " remove trailing spaces on entire buffer without altering the cursor position
    nmap <silent> <leader>SS :silent %s/\s\+$<cr>:normal ``<cr>
    " :SaveSession
    nmap <leader>ss :SaveSession 
    " :OpenSession
    nmap <leader>oo :OpenSession<cr>
    " sort css properties
    nnoremap <leader>S ?{<cr>jV/^\s*\}?$<cr>k:sort<cr>:noh<cr>
    " fold tag
    nnoremap <leader>zT Vatzf
    " write with sudo, dammit
    cmap w!! w !sudo tee % >/dev/null
    " write and refresh in browser
    cmap ww<cr> w<cr> :silent! !~/bin/refresh<cr>
    " open new vertical split, move to it
    nnoremap <leader>VS <C-w>v<C-w>l
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

  " plugin access remappings
    " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
    vmap <Enter> <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
    nmap <Leader>a <Plug>(EasyAlign)
    " ctrlp.vim
    nnoremap <silent> <leader>m :CtrlPMRUFiles<cr>
    nnoremap <silent> <leader>f :CtrlP<cr>
    nnoremap <silent> <leader>b :CtrlPBuffer<cr>
    " gundo
    nnoremap <leader>g :GundoToggle<cr>
    " nerdtree
    nnoremap <leader>n :NERDTreeToggle<cr>
    nnoremap <leader>N :NERDTreeFind<cr>
    " taglist
    nnoremap <leader>t :TlistToggle<cr>
    " superceded by easytags: set tags+=./tags;/
    " ack
    "nnoremap <leader>a :Ack 
    nnoremap <leader>a :CtrlSF 
    " smarthomekey
    map <silent> <Home> :SmartHomeKey<CR>
		imap <silent> <Home> <C-O>:SmartHomeKey<CR>
    " bufonly
    nnoremap <leader>o :BufOnly<cr>
    " font twiddling
    command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
    command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
    nmap g= :Bigger<cr>
    nmap g- :Smaller<cr>
    " unite
    nnoremap <Leader>, :Unite -start-insert file<CR>
    nnoremap <silent> <Leader>' :Unite -buffer-name=recent -winheight=10 file_mru<cr>

" PLUGIN SETTINGS
  " unite
  "call unite#filters#matcher_default#use(['matcher_fuzzy'])
  "let g:unite_split_rule = "botright"
  " format mru
  "let g:unite_source_file_mru_filename_format = ':~:.'
  "let g:unite_source_file_mru_time_format = ''

  "let g:unite_source_grep_command = 'ack-grep'
  "let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
  "let g:unite_source_grep_recursive_opt = ''

  " php case statement indenting
  let g:PHP_vintage_case_default_indent = 1
  " force checksyntax on save for php, js
  let g:checksyntax#auto_enable_rx = 'php\|javascript'
  " ctrlp
  let g:ctrlp_mruf_max = 250
  " taglist
  let Tlist_Use_Right_Window = 1
  let Tlist_Compact_Format = 1
  let Tlist_File_Fold_Auto_Close = 1
  let Tlist_Exit_OnlyWindow = 1
  let Tlist_Show_One_File = 1
  let Tlist_WinWidth = 35
  let tlist_php_settings = 'php;f:function'
  " nerdtree
  let NERDTreeMinimalUI=1
  let NERDTreeDirArrows=1
  let NERDTreeMapQuit='<Esc>'
  let NERDTreeQuitOnOpen = 1
  " syntastic
  " always open location list
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_enable_signs = 1
  let g:syntastic_echo_current_error = 0

  " airline
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline_section_warning = ''
  " let g:airline#extensions#tagbar#enabled = 0
  let g:airline_section_x = ''
  let g:airline_section_y = ''
  let g:airline_left_sep=''
  let g:airline_right_sep=''
  " bufferline
  set laststatus=2
  let g:bufferline_echo = 0
  let g:bufferline_show_bufnr = 0
  let g:bufferline_rotate = 2
  autocmd VimEnter *
    \ let &statusline='%{bufferline#refresh_status()}'
    \ .bufferline#get_status_string()
  " ack
  let g:ack_autoclose = 1
  " ctrlsf
  let g:ctrlsf_position = 'bottom'
  " vim-session
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'

" /\/\/\/ vimrc END

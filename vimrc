" /\/\/\/ vimrc BEGIN
" reminder: zi toggles folds

" OPTIONS
  set background=dark
  set backspace=indent,eol,start " allow b/s over everything in insert mode
  set breakindent " smart/indented line wrapping
  set confirm     " confirm dialog instead of fail
  set dict +=~/.vim/dictionaries/wordlist.dict
  set directory=~/.vim/tmp//
  set encoding=utf-8
  set noequalalways
  set expandtab
  set nofoldenable
  set foldmethod=indent
  set hidden       " abandoned buffers get hidden, not unloaded
  set history=1000
  set iskeyword-=_ " make _ act as a word boundary
  set mousemodel=popup_setpos
  set printfont=:h09
  set runtimepath+=~/.composer/vendor/bin
  set scrolloff=10
  set shiftround
  set shiftwidth=2
  set showcmd     " display incomplete commands in status bar
  set showmatch   " highlight matching parens, etc.
  set softtabstop=2
  set tabstop=2
  set ttyfast
  set wildmenu    " waaaaay better tab completion
  set wildmode=list:longest,full
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip
  set wildignorecase

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

" COLOR DEPENDENT OPTIONS
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
  endif

" GVIM OPTIONS
  if v:progname =~? "gvim" && has("vim_starting")
    set guioptions-=T " remove toolbar
    "set guioptions-=m " remove menubar
    " on linux
    if has("unix")
      " use gtklp for printing
      set printexpr=system('gtklp'\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error
      set guifont=Ubuntu\ Mono\ 12
    endif
    " on windows
    if has("win32") || has("win64")
      set guifont=Lucida_Sans_Typewriter:h10:cANSI
    endif
    " on laptop
    if match(system('hostname'), 'vardaman') == 0 || match(system('hostname'), 'cash') == 0
      set lines=43
      set columns=90
      set helpheight=32
    endif
  endif

" AUTOCOMMANDS
  if has("autocmd")
    filetype plugin indent on
    " put these in an autocmd group (so we can delete them easily)
    augroup vimrcEx
      " important: clear out the augroup first!
      " http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
      autocmd!
      " when editing anything not a commit message, jump to last location in file
      " (don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim))
      au BufReadPost *
        \ if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
      " re-source vimrc on save, then refresh Airline if necessary
      au BufWritePost .vimrc,vimrc source % | call RefreshUI()
      " compile sassy css on save
      au BufWritePost,FileWritePost *.scss :!~/bin/polycompile <afile>:p:h
      au BufNewFile,BufRead *.blog setf html | set lbr | set spell
      au BufNewFile,BufRead *.module,*.install,*.inc,*.theme setf php
      " autoclose quickfix on selection
      au FileType qf nmap <buffer> <cr> <cr>:cclose<cr>
    augroup END
  endif

" COMMANDS
  " minpac convenience commands
  command! PackUpdate call minpac#update()
  command! PackClean call minpac#clean()
  " font twiddling
  command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
  command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

" FUNCTIONS
  function! RefreshUI()
    if exists(':AirlineRefresh')
      AirlineRefresh
    endif
  endfunction

" KEY REMAPPINGS
  let mapleader = ","

  " make up and down arrows NOT linewise in insert mode
    inoremap <Up> <c-\><c-o>gk
    inoremap <Down> <c-\><c-o>gj

  " mswin-style cut/copy/paste (from $VIMRUNTIME/mswin.vim)
    vnoremap <c-X> "+x
    vnoremap <c-C> "+y
    map <c-V> "+gP
    cmap <c-V> <c-R>+
    exe 'inoremap <script> <c-V>' paste#paste_cmd['i']
    exe 'vnoremap <script> <c-V>' paste#paste_cmd['v']
    " <c-Q> for what <c-V> used to do (blockwise visual mode)
    noremap <c-Q> <c-V>

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
    nmap <C-tab> :bnext<cr>
    nmap <C-S-tab> :bprev<cr>
    imap <C-tab> <esc>:bnext<cr>
    imap <C-S-tab> <esc>:bprev<cr>
    " shortcut to .vimrc
    nmap <leader>v :e $MYVIMRC<cr>
    " clear the search highlights
    nmap <silent> g<space> :nohlsearch<cr>
    " toggle line wrap
    nmap <silent> <leader>W :silent set wrap!<cr>:set wrap?<cr>
    " toggle line numbering
    nmap <silent> <leader># :silent set number!<cr>:set number?<cr>
    " quick substitution setup
    nmap <leader>% :%s//g<left><left>
    " remove trailing spaces on entire buffer without altering the cursor position
    nmap <silent> <leader>SS :silent %s/\s\+$<cr>:normal ``<cr>
    " fold tag
    nnoremap <leader>zT Vatzf
    " shortcut to write current buffer
    nmap <leader>w :w!<cr>
    " write with sudo, dammit
    cmap w!! w !sudo tee % >/dev/null
    " write and refresh in browser
    cmap ww<cr> w<cr> :silent! !~/bin/refresh<cr>
    " make moving between windows easier
    nnoremap <c-h> <c-w>h
    nnoremap <c-j> <c-w>j
    nnoremap <c-k> <c-w>k
    nnoremap <c-l> <c-w>l
    " edit file, starting in same directory as current file [brilliant!]
    map <leader>e :e <c-r>=expand("%:p:h") . "/" <cr>
    " maximize window
    nmap <leader><space> :silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz<cr>
    " tab stop changes
    nmap <leader>2 :set tabstop=2<cr><esc>:set softtabstop=2<cr><esc>:set shiftwidth=2<cr>
    nmap <leader>4 :set tabstop=4<cr><esc>:set softtabstop=4<cr><esc>:set shiftwidth=4<cr>
    nmap <leader>8 :set tabstop=8<cr><esc>:set softtabstop=8<cr><esc>:set shiftwidth=4<cr>
    " this used to point at bufkill.vim's :BD
    nmap <silent> gx :bd<cr>
    " font twiddling
    nmap g= :Bigger<cr>
    nmap g- :Smaller<cr>

  " blog input mappings
    map <leader>a gewi<a href=""><esc>ea</a><esc>F>hi
    vmap <leader>a di<a href=""<esc>mza><esc>pa</a><esc>`zi
    vmap <leader>i di<i>pa</i>
    vmap <leader>b di<b>pa</b>
    map <leader>I i<img src="" class="" width="" height="" alt="" /><esc>
    map <leader>d <esc>:%s#\n\n#\r<br /><br />\r#g<cr>
    map <leader>M i<!-- more --><esc>

" PLUGINS - PACKAGES BY MINPAC
  packadd minpac
  call minpac#init()

  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('AndrewRadev/ember_tools.vim') " ember.js niceties
  call minpac#add('dhruvasagar/vim-open-url') " gB=open URL; gG=Google; gW=wikipedia
  call minpac#add('gioele/vim-autoswap') " essential: don't bug me about swap files
  call minpac#add('gregsexton/gitv') " fugitive extension: git browser at :Gitv
  call minpac#add('int3/vim-extradite') " :Extradite to view git log of current file
  call minpac#add('joonty/vdebug') " modern vim debugger
  call minpac#add('justinmk/vim-gtfo') " got/T for a term; gof/F for a fileman
  call minpac#add('keith/investigate.vim') " gK for information on word at cursor
  call minpac#add('metakirby5/codi.vim') " a vimmy REPL for various langs
  call minpac#add('mhinz/vim-hugefile') " make vim handle large files more gracefully
  call minpac#add('mikewest/vimroom') " <leader>V to toggle; do i use this?
  call minpac#add('milkypostman/vim-togglelist') " <leader>q toggles quickfix; <leader>l toggles location
  call minpac#add('rhysd/clever-f.vim') " improve f and F searches; no need for ; or ,
  call minpac#add('sheerun/vim-polyglot') " languages (including twig)
  call minpac#add('tomtom/tcomment_vim') " essential; gc to comment/uncomment
  call minpac#add('tpope/vim-fugitive') " essential: git gateway
  call minpac#add('tpope/vim-ragtag') " useful html-related mappings
  call minpac#add('tpope/vim-surround') " essential
  call minpac#add('tpope/vim-unimpaired') " handy mappings
  call minpac#add('vim-scripts/ColorSchemeEditor') " nifty
  call minpac#add('vim-scripts/matchit.zip') " make % much smarter
  call minpac#add('whatyouhide/vim-gotham') " dark colorscheme

  " airline - essential status line replacement
  call minpac#add('vim-airline/vim-airline')
  call minpac#add('vim-airline/vim-airline-themes')
  let g:airline#extensions#tagbar#enabled = 0
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline_left_sep=''
  let g:airline_mode_map = {'__': '-', 'n': 'N', 'i': 'I', 'R': 'R', 'c': 'C', 'v': 'V', 'V': 'V', 's': 'S', 'S': 'S',}
  let g:airline_right_sep=''
  let g:airline_section_warning = ''
  let g:airline_section_x = ''
  let g:airline_section_y = ''

  " ale - essential asynchronous lint engine
  call minpac#add('w0rp/ale')
  let g:ale_lint_delay = 200
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  let g:ale_list_window_size = 5
  let g:ale_open_list = 'on_save'

  " bufferline - show buffers in airline
  call minpac#add('bling/vim-bufferline')
  set laststatus=2
  let g:bufferline_echo = 0
  let g:bufferline_fname_mod = ':t'
  let g:bufferline_pathshorten = 1
  let g:bufferline_rotate = 2
  let g:bufferline_show_bufnr = 0

  " bufonly - closes all but current buffer; do I use this?
  call minpac#add('vim-scripts/BufOnly.vim')
  nmap <leader>o :BufOnly<cr>

  " ctrlsf - search/replace across files visually
  call minpac#add('dyng/ctrlsf.vim')
  let g:ctrlsf_ackprg = '/usr/bin/rg'
  let g:ctrlsf_position = 'bottom'
  nmap <leader>a :CtrlSF<space>

  " ctrlp - essential fuzzy finder for files/buffers/mru
  call minpac#add('ctrlpvim/ctrlp.vim')
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0 " not necessary when using ripgrep
  let g:ctrlp_match_window_reversed = 1
  let g:ctrlp_mruf_max = 250
  nmap <silent> <leader>m :CtrlPMRUFiles<cr>
  nmap <silent> <leader>f :CtrlP<cr>
  nmap <silent> <leader>b :CtrlPBuffer<cr>

  " Dokumentary - shift-K anything
  call minpac#add('gastonsimone/vim-dokumentary')
  let g:dokumentary_docprgs = {'php': 'pman {0}'}
  let g:dokumentary_open = 'topleft new'

  " MatchTagAlways - html tag highlighting
  call minpac#add('Valloric/MatchTagAlways')
  let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'twig' : 1,
    \}
  let g:mta_use_matchparen_group = 0

  " nerdtree - essential tree file explorer [left drawer]
  call minpac#add('scrooloose/nerdtree')
  let NERDTreeMapQuit='<esc>'
  let NERDTreeMinimalUI=1
  let NERDTreeQuitOnOpen = 1
  nmap <leader>n :NERDTreeToggle<cr>
  nmap <leader>N :NERDTreeFind<cr>
  " nerdtree-git-plugin - adds git markers
  call minpac#add('Xuyuanp/nerdtree-git-plugin')
  let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "Δ",
    \ "Staged"    : "+",
    \ "Untracked" : "∘",
    \ "Renamed"   : "»",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "X",
    \ "Dirty"     : "Δ",
    \ "Clean"     : "*",
    \ 'Ignored'   : '-',
    \ "Unknown"   : "?"
    \ }

  " tagbar - essential tag browser [right drawer]
  call minpac#add('majutsushi/tagbar') " <leader>t for tag browser
  let g:tagbar_autoclose = 1 " autofocus tagbar & autoclose
  let g:tagbar_compact = 1 " don't show help banner
  let g:tagbar_expand = 1 " expand gvim window
  let g:tagbar_iconchars = ['▸', '▾']
  let g:tagbar_sort = 0 " show tags in the order they appear, not sorted
  nnoremap <leader>t :TagbarToggle<cr>

  " undotree - essential undo history visualizer (gundo replacement)
  call minpac#add('mbbill/undotree')
  let g:undotree_SetFocusWhenToggle = 1
  nnoremap <leader>u :UndotreeToggle<cr>

  " vim-easy-align - hit <enter> in visual mode to begin
  call minpac#add('junegunn/vim-easy-align')
  " EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <Enter> <Plug>(EasyAlign)
  " EasyAlign for a motion/text object (e.g. <Leader>aip)
  nmap <Leader>a <Plug>(EasyAlign)

  " vim-grepper - essential asynchronous searcher (ack replacement; uses rg)
  call minpac#add('mhinz/vim-grepper')
  let g:grepper = {}
  let g:grepper.quickfix = 0
  nnoremap <leader>g :GrepperRg<space>

  " vim-gutentags - essential automated ctags mgr (vim-easytags replacement)
  call minpac#add('ludovicchabant/vim-gutentags')
  let g:gutentags_cache_dir = $HOME . '/.vim/tags'

  " vim-indent-guides - pretty!
  call minpac#add('nathanaelkane/vim-indent-guides')
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar']

  " vim-peekaoo - see what's in registers when you hit @ or "
  call minpac#add('junegunn/vim-peekaboo')
  let g:peekaboo_compact = 1
  let g:peekaboo_delay = 250

  " vim-rooter - auto cwd to project root
  call minpac#add('airblade/vim-rooter')
  let g:rooter_silent_chdir = 1

  " vim-sessionist - session manager
  call minpac#add('manasthakur/vim-sessionist')
  let g:sessionist_directory = $HOME . '/.vim/sessions'
  let g:sessionist_current = '<leader>sc'
  let g:sessionist_delete = '<leader>sd'
  let g:sessionist_list = '<leader>sl'
  let g:sessionist_new = '<leader>sn'
  let g:sessionist_open = '<leader>so'
  let g:sessionist_previous = '<leader>sp'
  let g:sessionist_save = '<leader>ss'

" /\/\/\/ vimrc END

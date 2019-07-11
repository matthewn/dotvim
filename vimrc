" /\/\/\/ vimrc BEGIN
" reminder: zi toggles folds, zR opens all, zM closes all

" OPTIONS
  set autochdir
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
  set formatoptions+=j " make J command grok multiline code comments
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
  set wildignore+=*/.git/*,*/tmp/*,*.so,*.swp,*.zip
  set wildignorecase

  set incsearch   " do incremental searching
  set ignorecase  "   make / searches ignore case
  set smartcase   "   unless there's a capital in the expression

  if has("mouse")
    set mouse=a
  endif
  if has("persistent_undo")
    set undofile
    set undodir=$HOME/.vim/undo,/tmp
  endif

" COLOR OPTIONS
  if &t_Co > 2 || has("gui_running")
    if !exists("g:syntax_on") | syntax enable | endif
    set hlsearch

    " useful for highlight debugging
    function! SynGroup()
      let l:s = synID(line('.'), col('.'), 1)
      echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
    endfunction

    " re-enable custom highlights after loading a colorscheme
    if has("autocmd")
      " see https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
      " for more on why this is where custom color changes should go
      function! MyHighlights() abort
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
        " tweaks to gotham
        if g:colors_name == 'gotham256'
          highlight MatchParen guifg=#ffffff guibg=#0a3749 gui=NONE
          highlight Search guifg=#ffffff guibg=#245361 gui=NONE
          highlight Pmenu guifg=#ffffff guibg=#000066 gui=NONE
          highlight pythonStatement guifg=#999999 gui=NONE
        endif
      endfunction
      augroup MyColors
        autocmd!
        autocmd ColorScheme * call MyHighlights()
        autocmd BufWinEnter * call MyHighlights()
      augroup END
    endif
    if has("vim_starting") | colorscheme gotham256 | endif
  endif

" GVIM OPTIONS
  if v:progname =~? "gvim"
    set guioptions-=T " remove toolbar
    set guioptions-=m " remove menubar
    set guioptions+=c " console > dialogs
    set helpheight=32
    if has("vim_starting")
      set lines=46
      set columns=90
    endif
    " on linux
    if has("unix")
      " use gtklp for printing
      set printexpr=system('gtklp'\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error
      if has("vim_starting") | set guifont=Ubuntu\ Mono\ 12 | endif
    endif
    " on windows
    if has("win32") || has("win64")
      set guifont=Lucida_Sans_Typewriter:h10:cANSI
    endif
    " on big pc
    if match(system('hostname'), 'hillsboro') == 0
      if has("vim_starting") | set lines=64 | endif
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
      function! RefreshAirline()
        if exists(':AirlineRefresh')
          AirlineRefresh
        endif
      endfunction
      au BufWritePost .vimrc,vimrc nested source % | call RefreshAirline()
      " autoclose quickfix on selection
      au FileType qf nmap <buffer> <cr> <cr>:cclose<cr>
      " ensure proper highlighting of css files
      au FileType css setlocal iskeyword+=-
      " blog
      au BufNewFile,BufRead *.blog setf html | set lbr | set spell
      " drupal
      au BufNewFile,BufRead *.module,*.install,*.inc,*.theme setf php
      " webdev auto-marks for jumping between files
      autocmd BufLeave *.css,*.scss normal! mC
      autocmd BufLeave *.html       normal! mH
      autocmd BufLeave *.js         normal! mJ
      " auto-delete fugitive buffers
      autocmd BufReadPost fugitive://* set bufhidden=delete
    augroup END
  endif

" COMMANDS
  " font twiddling
  command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
  command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
  " packager convenience commands
  command! PackagerInstall call PackagerInit() | call packager#install()
  command! -bang PackagerUpdate call PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })
  command! PackagerClean call PackagerInit() | call packager#clean()
  command! PackagerStatus call PackagerInit() | call packager#status()

" KEY REMAPPINGS
  let mapleader = ","

  " make up and down arrows NOT linewise in insert mode
    inoremap <Up> <c-\><c-o>gk
    inoremap <Down> <c-\><c-o>gj

  " mswin-style cut/copy/paste (from $VIMRUNTIME/mswin.vim)
    vnoremap <c-x> "+x
    vnoremap <c-c> "+y
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
    " do not move cursor after yanking in visual mode
    vmap y ygv<esc>

  " custom mappings
    " back to Startify
    nnoremap <leader><esc> :Startify<cr>
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
    " tab stop changes
    nmap <leader>2 :set tabstop=2<cr><esc>:set softtabstop=2<cr><esc>:set shiftwidth=2<cr>
    nmap <leader>4 :set tabstop=4<cr><esc>:set softtabstop=4<cr><esc>:set shiftwidth=4<cr>
    nmap <leader>8 :set tabstop=8<cr><esc>:set softtabstop=8<cr><esc>:set shiftwidth=4<cr>
    " this used to point at bufkill.vim's :BD
    nmap <silent> gx :bd<cr>
    " font twiddling
    nmap g= :Bigger<cr>
    nmap g- :Smaller<cr>
    " maximize gvim
    nmap <leader><space> :silent !wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz<cr>
    nmap <leader>M :silent !wmctrl -r :ACTIVE: -b toggle,maximized_vert<cr>

  " blog input mappings
    map <leader>a gewi<a href=""><esc>ea</a><esc>F>hi
    vmap <leader>a di<a href=""<esc>mza><esc>pa</a><esc>`zi
    vmap <leader>i di<i>pa</i>
    vmap <leader>b di<b>pa</b>
    map <leader>I i<img src="" class="" width="" height="" alt="" /><esc>

" PLUGINS - PACKAGES BY VIM-PACKAGER
  function! PackagerInit() abort
    packadd vim-packager
    call packager#init({ 'window_cmd': 'below split new'})

    " plugins which need no config or tweaking
    call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
    call packager#add('AndrewRadev/ember_tools.vim') " ember.js niceties
    call packager#add('cakebaker/scss-syntax.vim') " essential: syntax for scss
    call packager#add('fcpg/vim-orbital') " colorscheme
    call packager#add('https://git.danielmoch.com/vim-makejob.git') " essential: async make
    call packager#add('gioele/vim-autoswap') " essential: don't bug me about swap files
    call packager#add('hail2u/vim-css3-syntax') " essential: syntax for css3
    call packager#add('haishanh/night-owl.vim') " colorscheme
    call packager#add('justinmk/vim-gtfo') " got/T for a term; gof/F for a fileman
    call packager#add('keith/investigate.vim') " gK for vimhelp on word at cursor
    call packager#add('mhinz/vim-hugefile') " make vim handle large files more gracefully
    call packager#add('mikewest/vimroom') " <leader>V to toggle; do i use this?
    call packager#add('milkypostman/vim-togglelist') " <leader>q toggles quickfix; <leader>l toggles location
    call packager#add('cohama/agit.vim') " git browser at :Agit (replaces rbong/vim-flog)
    call packager#add('rhysd/clever-f.vim') " improve f and F searches; no need for ; or ,
    call packager#add('tmhedberg/SimpylFold') " improved folding for python
    call packager#add('tomtom/tcomment_vim') " essential; gc to comment/uncomment
    call packager#add('tpope/vim-fugitive') " essential: git gateway
    call packager#add('tpope/vim-ragtag') " useful html-related mappings
    call packager#add('tpope/vim-surround') " essential
    call packager#add('tpope/vim-unimpaired') " handy mappings
    call packager#add('tweekmonster/django-plus.vim') " django niceties
    call packager#add('vim-scripts/ColorSchemeEditor') " nifty
    call packager#add('whatyouhide/vim-gotham') " dark colorscheme
    call packager#add('xuhdev/vim-latex-live-preview') " what it says on the tin

    " plugins that are further tweaked below
    call packager#add('Valloric/MatchTagAlways')
    call packager#add('Xuyuanp/nerdtree-git-plugin')
    call packager#add('andymass/vim-matchup')
    call packager#add('ctrlpvim/ctrlp.vim')
    call packager#add('dyng/ctrlsf.vim')
    call packager#add('gastonsimone/vim-dokumentary')
    call packager#add('junegunn/vim-easy-align')
    call packager#add('ludovicchabant/vim-gutentags')
    call packager#add('majutsushi/tagbar')
    call packager#add('maralla/completor.vim')
    call packager#add('mbbill/undotree')
    call packager#add('mhinz/vim-grepper')
    call packager#add('mhinz/vim-startify')
    call packager#add('nathanaelkane/vim-indent-guides')
    call packager#add('scrooloose/nerdtree')
    call packager#add('vim-airline/vim-airline')
    call packager#add('vim-airline/vim-airline-themes')
    call packager#add('vim-scripts/BufOnly.vim')
    call packager#add('vim-vdebug/vdebug')
    call packager#add('w0rp/ale')
  endfunction

  " airline - essential status line replacement
  let g:airline#extensions#tabline#enabled = 1 " (replaces vim-buftabline)
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  let g:airline#extensions#tagbar#enabled = 0
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline_left_sep=''
  let g:airline_mode_map = {'__': '-', 'n': 'N', 'i': 'I', 'R': 'R', 'c': 'C', 'v': 'V', 'V': 'V', 's': 'S', 'S': 'S',}
  let g:airline_right_sep=''
  let g:airline_section_warning = ''
  let g:airline_section_x = ''
  let g:airline_section_y = ''
  let g:airline_theme = 'seagull'

  " ale - essential asynchronous lint engine
  let g:ale_lint_delay = 200
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  "let g:ale_list_window_size = 5
  let g:ale_open_list = 'on_save'
  let g:ale_linters = {
    \ 'php': ['php'],
    \ 'python': ['flake8'],
    \ 'javascript': ['eslint'],
    \ 'html': [],
    \ 'scss': ['sasslint'],
    \}
  nmap <silent> <leader>A :ALEToggleBuffer<cr>

  " bufonly - closes all but current buffer; do I use this?
  nmap <leader>o :BufOnly<cr>

  " completor - aync omnicompletion
  let g:completor_python_binary = '/usr/bin/python3'
  "let g:completor_completion_delay = 500
  " use tab to select completion
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

  " ctrlsf - search/replace across files visually
  if executable('rg')
    let g:ctrlsf_ackprg = '/usr/bin/rg'
  endif
  let g:ctrlsf_auto_focus = { "at" : "done" }
  let g:ctrlsf_default_root = 'project+ff' " ctrlsf in project by default
  let g:ctrlsf_position = 'bottom'
  nmap <leader>a :CtrlSF<space>

  " ctrlp - essential fuzzy finder for files/buffers/mru
  if executable('rg')
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  endif
  let g:ctrlp_use_caching = 0 " not necessary when using ripgrep
  let g:ctrlp_match_window_reversed = 1
  let g:ctrlp_mruf_max = 250
  nmap <silent> <leader>m :CtrlPMRUFiles<cr>
  nmap <silent> <leader>f :CtrlP<cr>
  nmap <silent> <leader>b :CtrlPBuffer<cr>

  " Dokumentary - shift-K anything
  let g:dokumentary_docprgs = {'php': 'pman {0}'}
  let g:dokumentary_open = 'topleft new'

  " MatchTagAlways - html tag highlighting
  let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'twig' : 1,
    \ 'php' : 1,
    \}
  let g:mta_use_matchparen_group = 0

  " nerdtree - essential tree file explorer [left drawer]
  let NERDTreeMapQuit='<esc>'
  let NERDTreeMinimalUI=1
  let NERDTreeQuitOnOpen = 1
  nmap <leader>n :NERDTreeToggle<cr>
  nmap <leader>N :NERDTreeFind<cr>
  " nerdtree-git-plugin - adds git markers
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
    \}
    function! NERDTreeRefresh()
      if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
      endif
    endfunction
    autocmd BufEnter * call NERDTreeRefresh()

  " tagbar - essential tag browser [right drawer]
  let g:tagbar_autofocus = 1 " autofocus tagbar
  let g:tagbar_compact = 1 " don't show help banner
  let g:tagbar_expand = 1 " expand gvim window
  let g:tagbar_iconchars = ['▸', '▾']
  let g:tagbar_sort = 0 " show tags in the order they appear, not sorted
  nnoremap <leader>t :TagbarToggle<cr>

  " undotree - essential undo history visualizer (gundo replacement)
  let g:undotree_SetFocusWhenToggle = 1
  nnoremap <leader>u :UndotreeToggle<cr>

  " vdebug - modern vim debugger
  let g:vdebug_options = {'break_on_open': 0}
  " let g:vdebug_keymap = {
  "   \ "run"            : "<leader>5",
  "   \ "run_to_cursor"  : "<Down>",
  "   \ "step_over"      : "<Up>",
  "   \ "step_into"      : "<Left>",
  "   \ "step_out"       : "<Right>",
  "   \ "close"          : "q",
  "   \ "detach"         : "x",
  "   \ "set_breakpoint" : "<leader>p",
  "   \ "eval_visual"    : "<leader>E"
  "   \ }

  " vim-easy-align - hit <enter> in visual mode to begin
  " EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <Enter> <Plug>(EasyAlign)
  " EasyAlign for a motion/text object (e.g. <Leader>aip)
  nmap <Leader>a <Plug>(EasyAlign)

  " vim-grepper - essential asynchronous searcher (replaces ack.vim; uses rg)
  let g:grepper = {}
  let g:grepper.quickfix = 0
  let g:grepper.dir = 'repo,cwd' " grep in project by default
  if executable('rg')
    nnoremap <leader>g :GrepperRg<space>
  else
    nnoremap <leader>g :Grepper<space>
  endif

  " vim-gutentags - essential automated ctags mgr (replaces vim-easytags)
  let g:gutentags_cache_dir = $HOME . '/.vim/tags'

  " vim-indent-guides - pretty!
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar']

  " vim-matchup - replaces vim's matchit plugin
  let g:matchup_transmute_enabled = 1 " enable paired tag renaming (replaces tagalong)

  " vim-startify - start screen + sane sessions (replaces vim-sessionist)
  let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'files',     'header': ['   MRU']            },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'commands',  'header': ['   Commands']       },
  \ ]
  let g:startify_session_dir = $HOME . '/.vim/sessions'
  let g:startify_session_persistence = 1
  nnoremap <leader>sc :SClose<space>
  nnoremap <leader>sd :SDelete<space>
  nnoremap <leader>so :SLoad<space>
  nnoremap <leader>ss :SSave!<cr>

" /\/\/\/ vimrc END

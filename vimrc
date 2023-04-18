" /\/\/\/ vimrc BEGIN
" reminder: zi toggles folds, zR opens all, zM closes all

" OPTIONS
  set nocompatible " necessary since vim9 pkg on ubuntu
  set backspace=indent,eol,start " allow b/s over everything in insert mode
  set breakindent " smart/indented line wrapping
  set confirm     " confirm dialog instead of fail
  set dict +=~/.vim/dictionaries/wordlist.dict
  set directory=~/.vim/tmp// " where the swapfiles live
  set encoding=utf-8
  set nofoldenable
  set foldmethod=indent
  set formatoptions+=j " make J command grok multiline code comments
  set hidden       " abandoned buffers get hidden, not unloaded
  set history=1000
  set iskeyword-=_ " make _ act as a word boundary
  set nrformats=  " force decimal-based arithmetic on ctrl-a/x
  set printfont=:h09
  set scrolloff=10
  set showcmd     " display incomplete commands in status bar
  set showmatch   " highlight matching parens, etc.
  set splitbelow  " so that the preview window opens at bottom
  set ttyfast
  set wildmenu    " waaaaay better tab completion
  set wildmode=list:longest,full
  set wildignore+=*/.git/*,*/tmp/*,*.so,*.swp,*.zip
  set wildignorecase

  set incsearch   " do incremental searching
  set ignorecase  "   make / searches ignore case
  set smartcase   "   unless there's a capital in the expression

  set expandtab
  set shiftround
  set shiftwidth=4
  set softtabstop=4

  if exists("&smoothscroll")  " vim 9.0.0640 & up
    set smoothscroll  " scroll linewise with mouse, ctrl-e/ctrl-y
  endif

  if exists("&viminfofile")  " vim 8.0.0716 & up
    set viminfofile=~/.vim/.viminfo  " keep .viminfo out of ~
  endif

  if has("mouse")
    set mouse=a
    set mousemodel=popup_setpos
  endif

  if has("persistent_undo")
    set undofile
    set undodir=$HOME/.vim/undo,/tmp
  endif

  filetype plugin indent on

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
      if has("vim_starting") | set guifont=Ubuntu\ Mono\ 13 | endif
    endif
  endif

" COLOR OPTIONS
  if &t_Co > 2 || has("gui_running")
    if !exists("g:syntax_on") | syntax enable | endif
    set hlsearch

    " re-enable custom highlights after loading a colorscheme
    "   (see https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
    "    for more on why this is where custom color changes should go)
    function! MyHighlights() abort
      " set colors for airline's tabline
      highlight airline_tab cterm=NONE ctermfg=lightgray gui=NONE guifg=lightgray
      highlight airline_tabhid cterm=NONE ctermfg=lightgray gui=NONE guifg=lightgray
      highlight airline_tabsel cterm=NONE ctermbg=blue ctermfg=white gui=NONE guibg=#445544 guifg=white
      highlight airline_tabmod cterm=NONE ctermbg=blue ctermfg=lightred gui=NONE guibg=#445544 guifg=lightred
      highlight airline_tabmod_unsel cterm=NONE ctermfg=lightred gui=NONE guifg=lightred
      " set color for colorcolumn
      highlight ColorColumn ctermbg=red guibg=darkred
      " highlight trailing whitespace
      highlight ExtraWhitespace ctermbg=red guibg=darkred
      match ExtraWhitespace /\s\+$/
      " tweaks for gotham
      if g:colors_name == 'gotham256'
        highlight Comment guifg=#22738c
        highlight MatchParen guifg=#ffffff guibg=#0a3749
        highlight Search guifg=#ffffff guibg=#245361
        highlight Pmenu guifg=#ffffff guibg=#000066
        highlight pythonStatement guifg=#999999
      endif
      " tweaks for iceberg
      if g:colors_name == 'iceberg'
        if &background ==# 'light'
          highlight TabLineSel cterm=NONE ctermbg=234 ctermfg=252 gui=NONE guibg=#cad0de guifg=#3f83a6
        else
          highlight TabLineSel cterm=NONE ctermbg=234 ctermfg=252 gui=NONE guibg=#161821 guifg=#84a0c6
        endif
      endif
    endfunction
    augroup MyColors
      autocmd!
      autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
      autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
      autocmd InsertLeave * match ExtraWhitespace /\s\+$/
      autocmd BufWinLeave * call clearmatches()
      autocmd ColorScheme * call MyHighlights()
      autocmd BufWinEnter * call MyHighlights()
    augroup END
  endif

" CUSTOM COMMANDS/FUNCTIONS
  command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
  command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

  " taken from defaults.vim
  if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
  endif

  function! RefreshAirline()
    if exists(':AirlineRefresh')
      AirlineRefresh
    endif
  endfunction

  " useful for highlight debugging
  function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
  endfunction

  " open github pages from vimrc Plug lines
  " taken from https://iamsang.com/en/2022/04/13/vimrc/
  function! s:open_plug_gh()
    let line = getline('.')
    let line = trim(line)
    let plug_regex = '\vPlug [''"](.{-})[''"].*'
    let path = substitute(line, plug_regex, '\1', '')
    let url = 'https://github.com/' .. path
    " echo "!open '"..url.."'"
    exec "!xdg-open '"..url.."' &"
  endfunction
  nnoremap <leader>hh :call <SID>open_plug_gh()<cr><cr>

" AUTOCOMMANDS
  " put these in an autocmd group (so we can delete them easily)
  augroup vimrc
    " important: clear out the augroup first!
    " http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
    autocmd!
    " when editing anything not a commit message, jump to last location in file
    " (don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim))
    autocmd BufReadPost *
      \ if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
    " if another buffer tries to replace NERDTree, put in the other window,
    " and bring back NERDTree
    autocmd BufEnter *
      \ if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
      \   let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf |
      \ endif
    " re-source vimrc on save, then refresh Airline if necessary
    autocmd BufWritePost .vimrc,vimrc nested silent source % | call RefreshAirline()
    " autoclose quickfix on selection
    autocmd FileType qf nmap <buffer> <cr> <cr>:cclose<cr>
    " ensure proper highlighting of css files
    autocmd FileType css setlocal iskeyword+=-
    " drupal
    autocmd BufNewFile,BufRead *.module,*.install,*.inc,*.theme setf php
    " webdev auto-marks for jumping between files
    autocmd BufLeave *.css,*.scss normal! mC
    autocmd BufLeave *.html       normal! mH
    autocmd BufLeave *.js         normal! mJ
    " auto-delete fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete
    " vertically maximize gvim on startup
    autocmd GUIEnter * call system('wmctrl -i -b toggle,maximized_vert -r ' . v:windowid)
  augroup END

" MAPPINGS
  let mapleader = ","

  if v:progname =~? "gvim"
    " switch between buffers with ctrl-tabs
    nmap <C-tab> :bnext<cr>
    nmap <C-S-tab> :bprev<cr>
    imap <C-tab> <esc>:bnext<cr>
    imap <C-S-tab> <esc>:bprev<cr>
    " maximize gvim
    nmap <leader><space> :silent !wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz<cr>
    " maximize gvim vertically
    nmap <leader>M :silent !wmctrl -r :ACTIVE: -b toggle,maximized_vert<cr>
  endif

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
    " switch to last active buffer
    noremap <leader>, :buffer #<cr>
    " <space> and - for pagedown/up
    noremap <Space> <PageDown>
    noremap - <PageUp>
    " back to Startify
    nnoremap <leader><esc> :Startify<cr>
    " easy escape
    inoremap jj <esc>
    " warp speed omnicomplete: map ';;' to trigger in insert mode
    imap ;; <C-x><C-o>
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
    nmap <leader>#2 :set tabstop=2<cr><esc>:set softtabstop=2<cr><esc>:set shiftwidth=2<cr>
    nmap <leader>#4 :set tabstop=4<cr><esc>:set softtabstop=4<cr><esc>:set shiftwidth=4<cr>
    nmap <leader>#8 :set tabstop=8<cr><esc>:set softtabstop=8<cr><esc>:set shiftwidth=4<cr>
    " this used to point at bufkill.vim's :BD
    nmap <silent> gx :bd<cr>
    " font twiddling
    nmap g= :Bigger<cr>
    nmap g- :Smaller<cr>
    " toggle cursorcolumn
    nnoremap <silent> <leader>L :execute "setlocal colorcolumn=" . (&colorcolumn == "" ? "80" : "")<cr>

  " html input mappings
    map <leader>a gewi<a href=""><esc>ea</a><esc>F>hi
    vmap <leader>a di<a href=""<esc>mza><esc>pa</a><esc>`zi

" PLUGINS - MANAGED BY VIM-PLUG
  " install vim-plug if not found
  " https://github.com/junegunn/vim-plug/wiki/tips
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
  " run PlugInstall if there are missing plugins
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
  \| endif
  call plug#begin('~/.vim/plugs')
  "
  " plugins that have no config
  "
  Plug 'Bakudankun/vim-makejob' " essential: async make
  Plug 'Vimjas/vim-python-pep8-indent' " fix python indenting
  Plug 'cakebaker/scss-syntax.vim' " essential: syntax for scss
  Plug 'chrisbra/Colorizer' " show hex colors, etc.
  Plug 'cocopon/iceberg.vim' " colorscheme
  Plug 'dhruvasagar/vim-open-url' " gB to open url
  Plug 'fcpg/vim-orbital' " colorscheme
  Plug 'fisadev/vim-isort'  " :isort for python
  Plug 'gioele/vim-autoswap' " essential: don't bug me about swap files
  Plug 'gorkunov/smartpairs.vim' " 'vv' for quick visual selection
  Plug 'hail2u/vim-css3-syntax' " essential: syntax for css3
  Plug 'haishanh/night-owl.vim' " colorscheme
  Plug 'jlanzarotta/colorSchemeExplorer' " does what it says on the tin
  Plug 'justinmk/vim-gtfo' " got/T for a term; gof/F for a filemanager
  Plug 'junegunn/goyo.vim' " replaces vimroom
  Plug 'junegunn/gv.vim' " git browser at :GV :GV! :GV? (replaces cohama/agit.vim for now)
  Plug 'keith/investigate.vim' " gK for vimhelp on word at cursor
  Plug 'mhinz/vim-hugefile' " handle large files more gracefully
  Plug 'milkypostman/vim-togglelist' " <leader>q toggles quickfix; <leader>l toggles location
  Plug 'rbong/vim-buffest'  " register/macro editing
  Plug 'rhysd/clever-f.vim' " improve f and F searches; no need for ; or ,
  Plug 'thiderman/vim-reinhardt' " for django-aware 'gf'
  Plug 'tmhedberg/SimpylFold' " improved folding for python
  Plug 'tomtom/tcomment_vim' " essential; gc to comment/uncomment
  Plug 'tpope/vim-characterize' " power-up for 'ga'
  Plug 'tpope/vim-fugitive' " essential: git gateway
  Plug 'tpope/vim-ragtag' " useful html-related mappings
  Plug 'tpope/vim-repeat' " makes vim-surround better
  Plug 'tpope/vim-surround' " essential
  Plug 'tpope/vim-unimpaired' " handy mappings
  Plug 'tweekmonster/django-plus.vim' " django niceties
  Plug 'whatyouhide/vim-gotham' " dark colorscheme
  Plug 'xuhdev/vim-latex-live-preview' " what it says on the tin
  "
  " plugins that have config below
  "
  Plug 'AndrewRadev/sideways.vim'
  Plug 'Valloric/MatchTagAlways'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'airblade/vim-gitgutter'
  Plug 'airblade/vim-rooter'
  Plug 'andymass/vim-matchup'
  Plug 'dahu/vim-lotr'
  Plug 'dense-analysis/ale'
  " Plug 'dense-analysis/ale', { 'tag': 'v3.2.0' }
  Plug 'dyng/ctrlsf.vim'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'gastonsimone/vim-dokumentary'
  Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'junegunn/vim-plug'
  Plug 'kovisoft/slimv'
  Plug 'liuchengxu/vista.vim'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'mbbill/undotree'
  Plug 'mhinz/vim-startify'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'pbogut/fzf-mru.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-scripts/BufOnly.vim'
  Plug 'vim-vdebug/vdebug'
  call plug#end()

" PLUGIN SETTINGS
  " airline - essential status line replacement
  let g:airline#extensions#tabline#enabled = 1 " (replaces vim-buftabline)
  let g:airline#extensions#tabline#buffer_idx_mode = 1 " easy buffer switching
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  let g:airline#extensions#whitespace#enabled = 0
  " let g:airline#extensions#ale#enabled = 1
  " let g:airline_left_sep=''
  let g:airline_mode_map = {'__': '-', 'n': 'N', 'i': 'I', 'R': 'R', 'c': 'C', 'v': 'V', 'V': 'V', 's': 'S', 'S': 'S',}
  " let g:airline_right_sep=''
  " let g:airline_section_warning = ''
  let g:airline_section_x = ''
  let g:airline_section_y = ''
  let g:airline_theme = 'lucius'

  " ale - essential: linting, completion, LSP & more
  let g:ale_completion_enabled = 1
  let g:ale_completion_delay = 200
  let g:ale_floating_preview = 1
  let g:ale_floating_window_border = repeat([''], 6)
  let g:ale_lsp_suggestions = 1
  let g:ale_lint_delay = 250
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  let g:ale_open_list = 'on_save'
  let g:ale_python_auto_poetry = 1
  let g:ale_python_pylsp_auto_poetry = 1
  let g:ale_virtualtext_cursor = 0
  let g:ale_linters = {
    \ 'css': ['stylelint'],
    \ 'php': ['php'],
    \ 'python': ['pylsp'],
    \ 'javascript': ['eslint'],
    \ 'html': [],
    \ 'scss': ['stylelint'],
    \ }
  let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'javascript': ['eslint'],
    \ 'python': ['autoimport', 'black', 'isort'],
    \ }

  " python-lsp-server (pylsp) config
  " enable flake8, use config at ~/.config/flake8, disable other pylsp linters
  " https://github.com/palantir/python-language-server/issues/190#issuecomment-721764819
  let g:ale_python_pylsp_config = {
    \   'pylsp': {
    \     'configurationSources': ['flake8'],
    \     'plugins': {
    \       'flake8': {'enabled': v:true},
    \       'jedi_completion': {'eager': v:true},
    \       'mccabe': {'enabled': v:false},
    \       'pyflakes': {'enabled': v:false},
    \       'pycodestyle': {'enabled': v:false},
    \     }
    \   }
    \ }
  nmap <leader>A :ALEToggleBuffer<cr>
  nmap gA :ALEGoToDefinition<cr>
  " use tab to select completion
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
  " let ale's completion handle omnicompletion
  set omnifunc=ale#completion#OmniFunc

  " bufonly - closes all but current buffer; do I use this?
  nmap <leader>o :BufOnly<cr>

  " ctrlsf - search/replace across files visually
  if executable('rg')
    let g:ctrlsf_ackprg = '/usr/bin/rg'
  endif
  let g:ctrlsf_auto_focus = { "at" : "done" }
  let g:ctrlsf_default_root = 'project+ff' " ctrlsf in project by default
  let g:ctrlsf_position = 'bottom'
  nmap <leader>F :CtrlSF<space>

  " Dokumentary - shift-K anything
  let g:dokumentary_docprgs = {'php': 'pman {0}'}
  let g:dokumentary_open = 'topleft new'

  " editorconfig-vim
  " play nice with fugitive
  let g:EditorConfig_exclude_patterns = ['fugitive://.*']

  " fzf and fzf.vim - replaces ctrlp and vim-grepper
  " set layout
  let g:fzf_layout = { 'down': '~30%' }
  " set preview window toggle keystroke
  let g:fzf_preview_window = ['right:50%', 'ctrl-p']
  " inherit colors from current colorscheme
  let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment']
    \ }
  " hide fzf's useless statusline
  autocmd! FileType fzf
  autocmd FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  " mappings
  nnoremap <silent> <leader>m :FZFMru<cr>
  nnoremap <silent> <leader>f :GFiles<cr>
  nnoremap <silent> <leader>b :Buffers<cr>
  nnoremap <silent> <leader>g :Rg<cr>
  nnoremap <silent> <leader>t :Tags<cr>

  " fzf-mru - add a proper mru to fzf
  " always sort by recency
  let g:fzf_mru_no_sort = 1

  " MatchTagAlways - html tag highlighting
  let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'twig' : 1,
    \ 'php' : 1,
    \ }
  let g:mta_use_matchparen_group = 0

  " nerdtree - essential tree file explorer [left drawer]
  let NERDTreeIgnore=['__pycache__[[dir]]']
  let NERDTreeMapQuit='<esc>'
  let NERDTreeMinimalUI = 1
  let NERDTreeQuitOnOpen = 1
  nmap <leader>n :NERDTreeToggle<cr>
  nmap <leader>N :NERDTreeFind<cr>
  " nerdtree-git-plugin - adds git markers
  let g:NERDTreeGitStatusIndicatorMapCustom = {
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
  " autorefresh on focus
  function! NERDTreeRefresh()
    if &filetype == "nerdtree"
      silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
  endfunction
  augroup nerd
    autocmd!
    autocmd BufEnter * call NERDTreeRefresh()
    " close tab if NERDTree is the only window remaining
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    " exit Vim if NERDTree is the only window remaining in the only tab
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
  augroup END

  " sideways - move arguments left/right
  nnoremap <c-s-h> :SidewaysLeft<cr>
  nnoremap <c-s-l> :SidewaysRight<cr>

  " slimv - <leader>c for SBCL REPL (emacs SLIME for vim)
  let g:lisp_rainbow = 1
  let g:slimv_repl_split = 2 " REPL below code
  augroup lisp
    autocmd!
    " enable gvim menubar on lisp files
    autocmd BufEnter *.lisp,REPL set guioptions+=m
    autocmd BufLeave *.lisp,REPL set guioptions-=m
  augroup END

  " undotree - essential undo history visualizer (replaces gundo)
  let g:undotree_SetFocusWhenToggle = 1
  nnoremap <leader>u :UndotreeToggle<cr>

  " vdebug - modern vim debugger
  let g:vdebug_options = {'break_on_open': 0}
  let g:vdebug_keymap = {
    \ "run"            : "<leader>D",
    \ "run_to_cursor"  : "<Down>",
    \ "step_over"      : "<Up>",
    \ "step_into"      : "<Right>",
    \ "step_out"       : "<Left>",
    \ "close"          : "<F4>",
    \ "detach"         : "<F5>",
    \ "set_breakpoint" : "<leader>p",
    \ "eval_visual"    : "<leader>E"
    \ }

  " vim-easy-align - hit <enter> in visual mode to begin
  " EasyAlign in visual mode (e.g. vip<Enter>)
  vmap <Enter> <Plug>(EasyAlign)

  " vim-gitgutter - git info expressed as vim signs
  let g:gitgutter_enabled = 0
  nmap <silent> <leader>\ :GitGutterToggle<cr>

  " vim-gutentags - essential automated ctags mgr (replaces vim-easytags)
  let g:gutentags_cache_dir = $HOME . '/.vim/tags'

  " vim-indent-guides - pretty!
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'vista']

  " vim-lotr - a sidebar for the register list [left drawer]
  let lotr_position = 'left'
  let lotr_winsize = '40'
  let lotr_map_keys = 0
  nmap <leader>r <Plug>LOTRToggle

  " vim-matchup - replaces vim's matchit plugin
  let g:matchup_transmute_enabled = 1 " enable paired tag renaming (replaces tagalong)

  " vim-plug - essential plugin manager
  let g:plug_window = '20new'

  " vim-rooter - auto cwd to project root
  let g:rooter_silent_chdir = 1

  " vim-startify - start screen + sane sessions (replaces vim-sessionist)
  let g:startify_bookmarks = [ {'b': '~/.bashrc'}, {'v': $MYVIMRC} ]
  let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'files',     'header': ['   MRU']            },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]
  let g:startify_fortune_use_unicode = 1
  let g:startify_session_dir = $HOME . '/.vim/sessions'
  let g:startify_session_persistence = 1
  nnoremap <leader>sc :SClose<cr>
  nnoremap <leader>sd :SDelete<space>
  nnoremap <leader>so :SLoad<space>
  nnoremap <leader>ss :SSave!<cr>

  " vista - essential tag/symbol browser [right drawer]
  " (async, replaces tagbar, speaks LSP)
  let g:vista_fold_toggle_icons = ['▾', '▸']
  let g:vista_renderer#enable_icon = 0
  nnoremap <leader>T :Vista!!<cr>

" ONLY ON STARTUP
  if has("vim_starting")
    set background=dark
    colorscheme night-owl
    " colorscheme based on time of day
    " execute 'colorscheme ' . (
    "   \ strftime('%H') > 4 && strftime('%H') < 19 ? 'gotham256' : 'night-owl'
    "   \ )
  endif

" /\/\/\/ vimrc END

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
  set confirm
  set showmatch
  set expandtab
  set shiftwidth=2
  set softtabstop=2
  set shiftround
  set tabstop=2
  set scrolloff=3
  set printfont=:h09
  set mousemodel=popup_setpos
  set noequalalways
  set encoding=utf-8
  set ttyfast
  set background=dark
  set dict +=~/.vim/dictionaries/drupal6.dict " add Drupal 6 dictionary to autocomplete (^X^K)
  set autochdir
  set foldmethod=indent
  set nofoldenable

" VERSION DEPENDENT SETTINGS
" persistent undo is only in vim ≥ 7.3
  if v:version >= 703
    set undofile
    set undodir=$HOME/.vim/undo,/tmp
  endif 

" VUNDLE
  filetype off
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
  Bundle 'bsl/obviousmode'
  Bundle 'gmarik/vundle'
  Bundle 'mileszs/ack.vim'
  Bundle 'vim-scripts/bufkill.vim'
  Bundle 'vim-scripts/buftabs'
  Bundle 'tomtom/checksyntax_vim'
  Bundle 'agileadam/drupal6complete'
  Bundle 'sjl/gundo.vim'
  Bundle 'sjbach/lusty'
  Bundle 'vim-scripts/mru.vim'
  Bundle 'scrooloose/nerdtree'
  Bundle 'vim-scripts/php-doc'
  Bundle 'vim-scripts/Smart-Home-Key'
  Bundle 'vim-scripts/svndiff'
  Bundle 'vim-scripts/taglist.vim'
  Bundle 'vim-scripts/TaskList.vim'
  "Bundle 'tomtom/tcomment_vim'
  Bundle 'vim-scripts/vcscommand.vim'
  Bundle 'vim-scripts/BufOnly.vim'
  Bundle 'nathanaelkane/vim-indent-guides'
  Bundle 'mikewest/vimroom'
  Bundle 'tpope/vim-commentary'
  Bundle 'tpope/vim-fugitive'
  Bundle 'tpope/vim-surround'
  Bundle 'tpope/vim-unimpaired'
  Bundle 'vim-scripts/ZoomWin'
  Bundle 'altercation/vim-colors-solarized'
  filetype plugin indent on

" IF COLOR IS AVAILABLE...
  if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
    highlight TabLine term=underline cterm=bold ctermfg=7 ctermbg=0 gui=underline guibg=DarkGrey
    highlight TabLineSel term=bold cterm=bold ctermfg=lightyellow gui=bold
    " indent_guides on by default (vim-indent-guides bundle)
    let g:indent_guides_enable_on_vim_startup = 1
  endif

" IF AUTOCOMMANDS ARE AVAILABLE...
  if has("autocmd")
    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!
    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
    augroup END
  else
    set autoindent
  endif

" CONDITIONAL SETTINGS (how we're running, where we are)
  if v:progname =~? "gvim"
    set guioptions-=T
    "set guioptions-=m
    colorscheme darkocean
    if has("unix")
      set printexpr=system('gtklp'\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error
    endif
    if has("unix") && match(system('hostname'), 'vardaman') == 0
        set lines=43
        set columns=85
        set guifont=Ubuntu\ Mono\ 12
    else
        set lines=110
        set columns=100
    endif
    if has("win32") || has("win64")
      set guifont=Lucida_Sans_Typewriter:h10:cANSI
    endif
  endif

" KEY REMAPPINGS ******************************************** [nore = don't recurse]

  " MSWIN-STYLE CUT/COPY/PASTE (stolen from $VIMRUNTIME/mswin.vim)
    " CTRL-X is Cut
    vnoremap <C-X> "+x
    " CTRL-C is Copy
    vnoremap <C-C> "+y
    " CTRL-V is Paste
    map <C-V> "+gP
    cmap <C-V> <C-R>+
    " Pasting blockwise and linewise selections is not possible in Insert and
    " Visual mode without the +virtualedit feature.  They are pasted as if they
    " were characterwise instead.
    " Uses the paste.vim autoload script.
    exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
    " Use CTRL-Q to do what CTRL-V used to do (blockwise visual mode)
    noremap <C-Q> <C-V>

  " don't use Ex mode, use Q for formatting
    map Q gq

  " make up and down arrows not linewise in insert mode
    imap <Up> <C-o>gk
    imap <Down> <C-o>gj

  " make Y effect to end of line instead of whole line
    map Y y$

  " reselect visual block after indent/outdent
    vnoremap < <gv
    vnoremap > >gv

  " blog input mappings
    " a href's
    map \a gewi<a href=""><Esc>ea</a><Esc>F>hi
    vmap \a di<a href=""<Esc>mza><Esc>pa</a><Esc>`zi
    " img
    map \i i<img src="" class="" width="" height="" alt="" /><Esc>
    " fill in double <br />s
    map \d <Esc>:%s#\n\n#\r<br /><br />\r#g<cr>
    " make a 'more' jump
    map \M i<!-- more --><Esc>

  " handy shortcuts
    " (<leader> defaults to \)
    let mapleader = ","
    " quick tab stop settings
    map <leader>2 :set tabstop=2<cr><Esc>:set softtabstop=2<cr><Esc>:set shiftwidth=2<cr>
    map <leader>4 :set tabstop=4<cr><Esc>:set softtabstop=4<cr><Esc>:set shiftwidth=4<cr>
    map <leader>8 :set tabstop=8<cr><Esc>:set softtabstop=8<cr><Esc>:set shiftwidth=4<cr>
    " toggle line numbering
    nmap <silent> <leader># :silent set number!<cr>:set number?<cr>
    " warp speed auto-complete: map ';;' to trigger in insert mode
    imap ;; <C-x><C-o>
    " switch between buffers with ctrl-arrows
    nmap <C-tab> :bnext<CR> 
    nmap <C-S-tab> :bprev<CR>
    imap <C-tab> <esc>:bnext<CR> 
    imap <C-S-tab> <esc>:bprev<CR>
    " toggle line wrap
    nmap <silent> <leader>W :silent set wrap!<cr>:set wrap?<cr>
    " shortcuts to get here [.vimrc] and reload automatically after save
    nmap <leader>v :e $MYVIMRC<cr>
    autocmd! BufWritePost .vimrc source %
    " remove trailing spaces on the current line
    nmap <silent> <leader>s :silent s/\s\+$<cr>
    " remove trailing spaces on entire buffer without altering the cursor position
    nmap <silent> <leader>SS :silent %s/\s\+$<cr>:normal ``<cr>
    " sort css properties
    nnoremap <leader>S ?{<cr>jV/^\s*\}?$<cr>k:sort<cr>:noh<cr>
    " fold tag
    nnoremap <leader>zT Vatzf
    " easy escape
    inoremap jj <esc>
    " clear the search highlights
    nnoremap <silent> g<space> :nohlsearch<cr>
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
    " save & check php syntax
    " nnoremap <leader>cs :w !php -l %<cr>
    " cd to zinch trunk
    nnoremap <leader>zd :cd /home/matthewn/zw/trunk<cr>
    " maximize window
    nnoremap <leader><space> :silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz<cr>
  
  " plugin access shortcuts
    " winmanager
    map <leader>w :WMToggle<cr>
    map <c-w><c-f> :FirstExplorerWindow<cr>
    map <c-w><c-b> :BottomExplorerWindow<cr>
    " gundo
    nnoremap <leader>g :GundoToggle<cr>
    " tasklist (have to map twice; tasklist bug?)
    nnoremap <leader>Zd <Plug>TaskList
    nnoremap <leader>d :TaskList<cr>
    " nerdtree
    nnoremap <leader>n :NERDTreeToggle<cr>
    nnoremap <leader>N :NERDTreeFind<cr>
    " taglist
    set tags+=./tags;/
    nnoremap <leader>t :TlistToggle<cr>
    " MRU
    nnoremap <leader>m :MRU<cr>
    " Ack
    nnoremap <leader>a :Ack 
    " lusty
    nnoremap <silent> <leader>f :LustyFilesystemExplorerFromHere<cr>
    nnoremap <silent> <leader>b :LustyBufferExplorer<cr>
    " smarthomekey
    map <silent> <Home> :SmartHomeKey<CR>
		imap <silent> <Home> <C-O>:SmartHomeKey<CR>
    " bufonly
    nnoremap <leader>o :BufOnly<cr>

" SETTINGS *************************************************************************

  " winmanager
  let g:persistentBehaviour = 0
	let g:winManagerWindowLayout = "FileTree,TagList|BufExplorer"
  " taglist
  let Tlist_Use_Right_Window = 1
  let Tlist_Compact_Format = 1
  let Tlist_File_Fold_Auto_Close = 1
  let Tlist_Exit_OnlyWindow = 1
  let Tlist_Show_One_File = 1
  let Tlist_WinWidth = 35
  let tlist_php_settings = 'php;f:function'
  " tasklist: move window to bottom
  let g:tlWindowPosition = 1
  " nerdtree
  let NERDTreeMinimalUI=1
  let NERDTreeDirArrows=1
  " minibufexplorer ctrl-tabs
  " let g:miniBufExplMapCTabSwitchBufs = 1
  " let g:miniBufExplModSelTarget = 1
  " fuzzyfinder color tweak
  " highlight Pmenu guifg=#aee guibg=#111
  " buftabs
  let g:buftabs_in_statusline=1
  let g:buftabs_only_basename=1
  let g:buftabs_separator=":"
  set laststatus=2
  set statusline=%{buftabs#statusline()}\ %q%h%m%r%=%-14.(%l,%c%V%)\ %P
  " showmarks
  let g:showmarks_enable=0




" CRUFT ****************************************************************************

  "Make the completion menus readable
  "highlight Pmenu ctermfg=0 ctermbg=3
  "highlight PmenuSel ctermfg=0 ctermbg=7

  "The following should be done automatically for the default colour scheme
  "at least, but it is not in Vim 7.0.17.
  "if &bg == "dark"
  "  highlight MatchParen ctermbg=darkblue guibg=blue
  "endif
  "
  "if &diff
      "I'm only interested in diff colours
  "    syntax off
  "endif
  "

" /\/\/\/ vimrc END

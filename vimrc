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
  set dict +=~/.vim/dictionaries/wordlist.dict
  set autochdir
  set foldmethod=indent
  set nofoldenable
  set directory=~/.vim/tmp//
  if has('mouse')
    set mouse=a
  endif

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
  Bundle 'bling/vim-airline'
  Bundle 'bling/vim-bufferline'
  Bundle 'bsl/obviousmode'
  Bundle 'ervandew/supertab'
  Bundle 'gmarik/vundle'
  Bundle 'mikewest/vimroom'
  Bundle 'mileszs/ack.vim'
  Bundle 'nathanaelkane/vim-indent-guides'
  Bundle 'nelstrom/vim-qargs'
  Bundle 'nelstrom/vim-visual-star-search'
  Bundle 'psynaptic/vim-drupal'
  Bundle 'scrooloose/nerdtree'
  Bundle 'sjbach/lusty'
  Bundle 'sjl/gundo.vim'
  Bundle 'tomtom/checksyntax_vim'
  Bundle 'tpope/vim-commentary'
  Bundle 'tpope/vim-fugitive'
  Bundle 'tpope/vim-surround'
  Bundle 'tpope/vim-unimpaired'
  Bundle 'tsaleh/vim-matchit'
  Bundle 'vim-scripts/BufOnly.vim'
  Bundle 'vim-scripts/ColorSchemeEditor'
  Bundle 'vim-scripts/Smart-Home-Key'
  Bundle 'vim-scripts/TaskList.vim'
  Bundle 'vim-scripts/ZoomWin'
  Bundle 'vim-scripts/bufkill.vim'
  Bundle 'vim-scripts/mru.vim'
  Bundle 'vim-scripts/php-doc'
  Bundle 'vim-scripts/taglist.vim'
  Bundle 'vim-scripts/vcscommand.vim'
  "Bundle 'vim-scripts/buftabs'
  "Bundle 'tomtom/tcomment_vim'
  "Bundle 'euclio/vim-nocturne'
  filetype plugin indent on

" COLOR SETTINGS
  if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
    highlight TabLine term=underline cterm=bold ctermfg=7 ctermbg=0 gui=underline guibg=DarkGrey
    highlight TabLineSel term=bold cterm=bold ctermfg=lightyellow gui=bold
    " indent_guides on by default (vim-indent-guides bundle)
    let g:indent_guides_enable_on_vim_startup = 1
  endif

" GVIM SETTINGS
  if v:progname =~? "gvim"
    set guioptions-=T
    "set guioptions-=m
    "colorscheme darkocean
    colorscheme nocturne
    " completion
    highlight Pmenu guifg=#aee guibg=#111
    if has("unix")
      set printexpr=system('gtklp'\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error
    endif
    if has("unix") && match(system('hostname'), 'vardaman') == 0 || match(system('hostname'), 'fiatlux') == 0 
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

" AUTOCOMMANDS
  if has("autocmd")
    " put these in an autocmd group (so we can delete them easily)
    augroup vimrcEx
      " clear out the augroup
      " http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
      au! 
      " when editing a file, always jump to the last known cursor position.
      " (don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim))
      autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
      " reload vimrc on save
      au BufWritePost .vimrc,vimrc source % 
      " compile sassy css on save
      au BufWritePost,FileWritePost *.scss :!compass compile --boring <afile>:p:h:h 
      au BufNewFile,BufRead *.blog setf html | set lbr | set spell
      au BufNewFile,BufRead *.module,*.install,*.inc setf php
    augroup END
  else
    set autoindent
  endif

" KEY REMAPPINGS ******************************************** [nore = don't recurse]

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

  " shortcuts
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
    " save & check php syntax
    " nnoremap <leader>cs :w !php -l %<cr>
    " maximize window
    nnoremap <leader><space> :silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz<cr>
    " tab stop changes
    map <leader>2 :set tabstop=2<cr><Esc>:set softtabstop=2<cr><Esc>:set shiftwidth=2<cr>
    map <leader>4 :set tabstop=4<cr><Esc>:set softtabstop=4<cr><Esc>:set shiftwidth=4<cr>
    map <leader>8 :set tabstop=8<cr><Esc>:set softtabstop=8<cr><Esc>:set shiftwidth=4<cr>
  
  " plugin access shortcuts
    " MRU
    nnoremap <leader>m :MRU<cr>
    " bufkill.vim's :BD
    nnoremap <silent> gx :BD<cr>
    " lusty
    nnoremap <silent> <leader>f :LustyFilesystemExplorerFromHere<cr>
    nnoremap <silent> <leader>b :LustyBufferExplorer<cr>
    " gundo
    nnoremap <leader>g :GundoToggle<cr>
    " winmanager
    map <leader>w :WMToggle<cr>
    map <c-w><c-f> :FirstExplorerWindow<cr>
    map <c-w><c-b> :BottomExplorerWindow<cr>
    " tasklist (have to map twice; tasklist bug?)
    nnoremap <leader>Zd <Plug>TaskList
    nnoremap <leader>d :TaskList<cr>
    " nerdtree
    nnoremap <leader>n :NERDTreeToggle<cr>
    nnoremap <leader>N :NERDTreeFind<cr>
    " taglist
    set tags+=./tags;/
    nnoremap <leader>t :TlistToggle<cr>
    " Ack
    nnoremap <leader>a :Ack 
    " smarthomekey
    map <silent> <Home> :SmartHomeKey<CR>
		imap <silent> <Home> <C-O>:SmartHomeKey<CR>
    " bufonly
    nnoremap <leader>o :BufOnly<cr>
    " font twiddling
    runtime fonts.vim
    nmap g= :LargerFont<cr>
    nmap g- :SmallerFont<cr>

" PLUGIN SETTINGS

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
  " airline
  let g:airline_detect_whitespace = 0
  let g:airline_enable_tagbar = 0
  let g:airline_section_x = ''
  let g:airline_section_y = ''
  " bufferline
  set laststatus=2
  let g:bufferline_echo = 0
  let g:bufferline_show_bufnr = 0
  autocmd VimEnter *
    \ let &statusline='%{bufferline#refresh_status()}'
    \ .bufferline#get_status_string()
  " showmarks
  let g:showmarks_enable = 0
  " buftabs
  "let g:buftabs_in_statusline=1
  "let g:buftabs_only_basename=1
  "let g:buftabs_separator=":"
  "set statusline=%{buftabs#statusline()}\ %q%h%m%r%=%-14.(%l,%c%V%)\ %P

" /\/\/\/ vimrc END

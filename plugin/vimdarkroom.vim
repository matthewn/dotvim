" BEGIN VIMDARKROOM STUFF

func WordCount()
    let save_cursor = getpos(".")
    exe "silent normal! g\<C-g>"
    call setpos('.', save_cursor)
    return matchstr(v:statusmsg, 'Word \d\+ of \zs\d\+')
endfunc

function VimDarkRoom()
    try
        if g:in_DarkRoom | call LeaveDarkRoom() | endif
    catch
        call EnterDarkRoom()
    endtry
endfunction

function EnterDarkRoom()
    if has("gui_running")
        let g:dr_columns=&columns
        let g:dr_lines=&lines
        let g:dr_go=&guioptions | set go-=m | set go-=r | set go-=L
        let g:dr_colors=g:colors_name | colorscheme murphy
        if has("unix")
            exe "silent !wmctrl -r :ACTIVE: -b add,maximized_horz,maximized_vert"
        elseif has("gui_running") && has("win32")
            simalt ~x
        endif
    endif
    let g:dr_display=&display | set display+=lastline
    let g:dr_cul=&cursorline | set nocursorline
    let g:dr_number=&number | set nonumber
    let g:dr_ea=&equalalways | set noequalalways
    let g:dr_ai=&autoindent | set autoindent
    let g:dr_lbr=&lbr | set lbr
    let g:dr_spell=&spell | set spell
    let gutter=((&columns - 85) / 2)
    vnew
    setl stl=\ 
    botright vnew
    setlocal stl=\ 
    exe "normal" . "\<C-w>h\<C-w>h"
    exe "vertical-resize" . gutter
    exe "normal" . "\<C-w>l150\<C-w>|\<C-w>h\<C-w>l\<C-w>l\<C-w>h"
    startinsert
    let g:dr_hl=&hl
    hi clear VertSplit
    hi clear NonText
    hi link NonText Ignore
    set hl-=c:VertSplit hl+=c:Ignore
    let g:dr_stl=&stl
    setl stl=\ %-f\ %m%49{WordCount()}\ word(s)%12P\ 
    if has("gui_running") && has("unix")
        exe "silent! !wmctrl -r :ACTIVE: -b add,fullscreen"
    endif
    let g:in_DarkRoom=1
endfunction

function LeaveDarkRoom()
    if has("gui_running")
        exe "set go=" . g:dr_go | unlet g:dr_go
        exe "colorscheme " . g:dr_colors | unlet g:dr_colors
        if has("unix")
            exe "silent! !wmctrl -r :ACTIVE: -b remove,fullscreen"
            exe "silent! !wmctrl -r :ACTIVE: -b remove,maximized_horz,maximized_vert"
            exe "set columns=" . g:dr_columns | unlet g:dr_columns
            exe "set lines=" . g:dr_lines | unlet g:dr_lines
        elseif has("gui_running") && has("win32")
            simalt ~r
        endif
    endif
    exe "set display=" . g:dr_display | unlet g:dr_display
    if g:dr_cul | set cul | else | set nocul | endif | unlet g:dr_cul
    if g:dr_number | set nu | else | set nonu | endif | unlet g:dr_number
    if g:dr_ea | set ea | else | set noea | endif | unlet g:dr_ea
    if g:dr_ai | set ai | else | set noai | endif | unlet g:dr_ai
    if g:dr_lbr | set lbr | else | set nolbr | endif | unlet g:dr_lbr
    if g:dr_spell | set spell | else | set nospell | endif | unlet g:dr_spell
    exe "set highlight=" . g:dr_hl | unlet g:dr_hl
    exe "set statusline=" . g:dr_stl | unlet g:dr_stl
    exe "normal" . "\<C-w>h\<C-w>c\<C-w>l\<C-w>c"
    unlet g:in_DarkRoom
endfunction

map <F11> :call VimDarkRoom()<CR>
imap <F11> <Esc>:call VimDarkRoom()<CR>

" END VIMDARKROOM STUFF

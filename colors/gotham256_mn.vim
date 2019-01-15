" Colorscheme created with ColorSchemeEditor v1.2.3
"Name: gotham256
"Maintainer: 
"Last Change: 2018 Oct 12
set background=dark
if version > 580
	highlight clear
	if exists("syntax_on")
		syntax reset
	endif
endif
let g:colors_name = "gotham256"

if v:version >= 700
	highlight CursorColumn guibg=#11151c gui=NONE
	highlight CursorLine guibg=#11151c gui=NONE
	highlight Pmenu guifg=#99d1ce guibg=#091f2e gui=NONE
	highlight PmenuSel guifg=#d3ebe9 guibg=#195466 gui=NONE
	highlight PmenuSbar guibg=#091f2e gui=NONE
	highlight PmenuThumb guibg=#195466 gui=NONE
	highlight TabLine guifg=#99d1ce guibg=#091f2e gui=NONE
	highlight TabLineFill guifg=#0c1014 guibg=#091F2E gui=NONE
	highlight TabLineSel guifg=#d3ebe9 guibg=#195466 gui=NONE
	if has('spell')
		highlight SpellBad guifg=#d3ebe9 guibg=#c23127 gui=NONE
		highlight SpellCap guifg=#d3ebe9 guibg=#195466 gui=NONE
		highlight SpellLocal guifg=#edb443 gui=NONE
		highlight SpellRare guifg=#d3ebe9 guibg=#4e5166 gui=NONE
	endif
endif
highlight Cursor guifg=#11151c guibg=#99d1ce gui=NONE
highlight link CursorIM cleared
highlight DiffAdd guifg=#d3ebe9 guibg=#2aa889 gui=NONE
highlight DiffChange guifg=#d3ebe9 guibg=#195466 gui=NONE
highlight DiffDelete guifg=#d3ebe9 guibg=#c23127 gui=NONE
highlight DiffText guifg=#d3ebe9 guibg=#33859E gui=NONE
highlight Directory guifg=#33859E gui=NONE
highlight ErrorMsg guifg=#c23127 guibg=#11151c gui=NONE
highlight FoldColumn guifg=#599cab guibg=#0a3749 gui=NONE
highlight Folded guifg=#99d1ce guibg=#195466 gui=NONE
highlight IncSearch gui=reverse
highlight LineNr guifg=#195466 guibg=#11151c gui=NONE
highlight MatchParen guifg=#99d1ce guibg=#195446 gui=NONE
highlight ModeMsg guifg=#195466 gui=NONE
highlight MoreMsg guifg=SeaGreen gui=bold
highlight NonText guifg=#195466 gui=NONE
highlight Normal guifg=#99d1ce guibg=#0c1014 gui=NONE
highlight Question guifg=#2aa889 gui=NONE
highlight Search guifg=#091f2e guibg=#edb443 gui=NONE
highlight SignColumn guifg=Cyan guibg=#11151c gui=NONE
highlight SpecialKey guifg=#0a3749 gui=NONE
highlight StatusLine guifg=#599cab guibg=#091f2e gui=NONE
highlight StatusLineNC guifg=#195466 guibg=#091f2e gui=NONE
highlight Title guifg=#d26937 gui=NONE
highlight VertSplit guifg=#091f2e guibg=#11151c gui=NONE
highlight Visual guibg=#0a3749 gui=NONE
highlight VisualNOS gui=bold,underline
highlight WarningMsg guifg=#c23127 gui=NONE
highlight WildMenu guifg=#d3ebe9 guibg=#33859E gui=NONE
highlight link Boolean Constant
highlight link Character Constant
highlight Comment guifg=#195466 gui=NONE
highlight link Conditional Statement
highlight Constant guifg=#888ca6 gui=NONE
highlight link Debug Special
highlight link Define PreProc
highlight link Delimiter Special
highlight Error guifg=#c23127 guibg=#11151c gui=NONE
highlight link Exception Statement
highlight link Float Number
highlight link Function Identifier
highlight Identifier guifg=#599cab gui=NONE
highlight Ignore guifg=bg gui=NONE
highlight link Include PreProc
highlight link Keyword Statement
highlight link Label Statement
highlight link Macro PreProc
highlight Number guifg=#d26937 gui=NONE
highlight link Operator Statement
highlight link PreCondit PreProc
highlight PreProc guifg=#c23127 gui=NONE
highlight link Repeat Statement
highlight Special guifg=#d26937 gui=NONE
highlight link SpecialChar Special
highlight link SpecialComment Special
highlight Statement guifg=#599cab gui=NONE
highlight link StorageClass Type
highlight String guifg=#2aa889 gui=NONE
highlight link Structure Type
highlight link Tag Special
highlight Todo guifg=#888ca6 guibg=#0c1014 gui=NONE
highlight Type guifg=#d26937 gui=NONE
highlight link Typedef Type
highlight Underlined guifg=#edb443 gui=underline


"ColorScheme metadata{{{
if v:version >= 700
	let g:gotham256_Metadata = {
				\"Palette" : "black:white:gray50:red:purple:blue:light blue:green:yellow:orange:lavender:brown:goldenrod4:dodger blue:pink:light green:gray10:gray30:gray75:gray90",
				\"Last Change" : "2018 Oct 12",
				\"Name" : "gotham256",
				\}
endif
"}}}
" vim:set foldmethod=marker expandtab filetype=vim:

" Colorscheme created with ColorSchemeEditor v1.2.3
"Name: BlackSea
"Maintainer: 
"Last Change: 2013 Aug 08
set background=dark
if version > 580
	highlight clear
	if exists("syntax_on")
		syntax reset
	endif
endif
let g:colors_name = "BlackSea"

if v:version >= 700
	highlight CursorColumn guibg=Grey40 gui=NONE
	highlight CursorLine guibg=Grey40 gui=NONE
	highlight Pmenu guibg=Magenta gui=NONE
	highlight PmenuSel guibg=DarkGrey gui=NONE
	highlight PmenuSbar guibg=Grey gui=NONE
	highlight PmenuThumb guibg=White gui=NONE
	highlight TabLine guibg=DarkGrey gui=underline
	highlight TabLineFill gui=reverse
	highlight TabLineSel gui=bold
	if has('spell')
		highlight SpellBad gui=undercurl
		highlight SpellCap gui=undercurl
		highlight SpellLocal gui=undercurl
		highlight SpellRare gui=undercurl
	endif
endif
highlight Cursor guifg=bg guibg=fg gui=NONE
highlight CursorIM gui=NONE
highlight DiffAdd guibg=DarkGreen gui=NONE
highlight DiffChange guibg=Gray30 gui=NONE
highlight DiffDelete guifg=Black guibg=DarkRed gui=bold
highlight DiffText guibg=DarkCyan gui=NONE
highlight Directory guifg=Cyan gui=NONE
highlight ErrorMsg guifg=White guibg=Red gui=NONE
highlight FoldColumn guifg=Cyan guibg=Grey gui=NONE
highlight Folded guifg=Cyan guibg=DarkGrey gui=NONE
highlight IncSearch gui=reverse
highlight LineNr guifg=Yellow gui=NONE
highlight MatchParen guibg=DarkCyan gui=NONE
highlight ModeMsg gui=bold
highlight MoreMsg guifg=SeaGreen gui=bold
highlight NonText guifg=LavenderBlush gui=bold
highlight Normal guifg=seashell guibg=Black gui=NONE
highlight Question guifg=Green gui=bold
highlight Search guifg=Black guibg=Gold3 gui=NONE
highlight SignColumn guifg=Cyan guibg=Grey gui=NONE
highlight SpecialKey guifg=Cyan gui=NONE
highlight StatusLine guifg=DarkSeaGreen guibg=#1f001f gui=bold,reverse
highlight StatusLineNC guifg=Gray gui=reverse
highlight Title guifg=Magenta gui=bold
highlight VertSplit guifg=Gray gui=reverse
highlight Visual guibg=DarkGrey gui=NONE
highlight VisualNOS gui=bold,underline
highlight WarningMsg guifg=Red gui=NONE
highlight WildMenu guifg=Black guibg=Yellow gui=NONE
highlight link Boolean Constant
highlight link Character Constant
highlight Comment guifg=#7A7A7A gui=italic
highlight link Conditional Statement
highlight Constant guifg=DeepPink gui=NONE
highlight link Debug Special
highlight link Define PreProc
highlight link Delimiter Special
highlight Error guifg=White guibg=Red gui=NONE
highlight link Exception Statement
highlight link Float Number
highlight link Function Identifier
highlight Identifier guifg=Cyan gui=NONE
highlight Ignore guifg=bg gui=NONE
highlight link Include PreProc
highlight link Keyword Statement
highlight link Label Statement
highlight link Macro PreProc
highlight link Number Constant
highlight link Operator Statement
highlight link PreCondit PreProc
highlight PreProc guifg=Magenta gui=NONE
highlight link Repeat Statement
highlight Special guifg=Orange gui=NONE
highlight link SpecialChar Special
highlight link SpecialComment Special
highlight Statement guifg=brown3 gui=bold
highlight link StorageClass Type
highlight link String Constant
highlight link Structure Type
highlight link Tag Special
highlight Todo guifg=Blue guibg=Yellow gui=NONE
highlight Type guifg=#60ff60 gui=NONE
highlight link Typedef Type
highlight Underlined guifg=#80a0ff gui=underline


"ColorScheme metadata{{{
if v:version >= 700
	let g:BlackSea_Metadata = {
				\"Palette" : "black:white:gray50:red:purple:blue:light blue:green:yellow:orange:lavender:brown:goldenrod4:dodger blue:pink:light green:gray10:gray30:gray75:gray90",
				\"Last Change" : "2013 Aug 08",
				\"Name" : "BlackSea",
				\}
endif
"}}}
" vim:set foldmethod=marker expandtab filetype=vim:

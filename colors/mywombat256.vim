" Original Maintainer:	Lars H. Nielsen (dengmao@gmail.com)
" Last Change:	April 15 2010
"
" Converting for 256-color terminals by
" Danila Bespalov (danila.bespalov@gmail.com)
" with great help of tool by Wolfgang Frisch (xororand@frexx.de)
" inspired by David Liang's version (bmdavll@gmail.com)

set background=dark

hi clear

if exists("syntax_on")
	syntax reset
endif

let colors_name = "wombat256"


" Vim >= 7.0 specific colors
if version >= 700
	hi CursorLine							ctermbg=236		cterm=none
	hi CursorColumn						ctermbg=236
	hi MatchParen		ctermfg=7		ctermbg=243		cterm=bold
	hi Pmenu				ctermfg=7		ctermbg=238
	hi PmenuSel			ctermfg=0		ctermbg=186
endif

" General colors
hi Cursor				ctermfg=none	ctermbg=241		cterm=none
"hi Normal				ctermfg=253		ctermbg=234		cterm=none
hi Normal				ctermfg=253		ctermbg=232		cterm=none
hi NonText				ctermfg=244		ctermbg=236		cterm=none
hi LineNr				ctermfg=254		ctermbg=233		cterm=none
hi StatusLine			ctermfg=230		ctermbg=238		cterm=none
hi StatusLineNC		ctermfg=243		ctermbg=238		cterm=none
hi VertSplit			ctermfg=238		ctermbg=238		cterm=none
hi Folded				ctermfg=103		ctermbg=238		cterm=none
hi Title					ctermfg=7		ctermbg=none	cterm=bold
hi Visual				ctermfg=15		ctermbg=238		cterm=none
hi SpecialKey			ctermfg=244		ctermbg=236		cterm=none

" Syntax highlighting
hi Comment				ctermfg=246		cterm=none
hi Todo					ctermfg=245		cterm=none
hi Constant				ctermfg=173		cterm=none
hi String				ctermfg=113		cterm=none
hi Identifier			ctermfg=192		cterm=none
hi Function				ctermfg=192		cterm=none
hi Type					ctermfg=186		cterm=none
hi Statement			ctermfg=111		cterm=none
hi Keyword				ctermfg=111		cterm=none
hi PreProc				ctermfg=173		cterm=none
hi Number				ctermfg=173		cterm=none
hi Special				ctermfg=194		cterm=none


" Original version by Lars H. Nielsen (dengmao@gmail.com)
" to display in GUI

" Vim >= 7.0 specific colors
if version >= 700
	hi CursorLine							guibg=#2d2d2d
	hi CursorColumn						guibg=#2d2d2d
	hi MatchParen		guifg=#f6f3e8	guibg=#857b6f	gui=bold
	hi Pmenu				guifg=#f6f3e8	guibg=#444444
	hi PmenuSel			guifg=#000000	guibg=#cae682
endif

" General colors
hi Cursor				guifg=NONE		guibg=#656565	gui=none
hi Normal				guifg=#f6f3e8	guibg=#242424	gui=none
hi NonText				guifg=#808080	guibg=#303030	gui=none
hi LineNr				guifg=#857b6f	guibg=#000000	gui=none
hi StatusLine			guifg=#f6f3e8	guibg=#444444	gui=italic
hi StatusLineNC		guifg=#857b6f	guibg=#444444	gui=none
hi VertSplit			guifg=#444444	guibg=#444444	gui=none
hi Folded				guifg=#a0a8b0	guibg=#384048	gui=none
hi Title					guifg=#f6f3e8	guibg=NONE		gui=bold
hi Visual				guifg=#f6f3e8	guibg=#444444	gui=none
hi SpecialKey			guifg=#808080	guibg=#343434	gui=none

" Syntax highlighting
hi Comment				guifg=#99968b	gui=italic
hi Todo					guifg=#8f8f8f	gui=italic
hi Constant				guifg=#e5786d	gui=none
hi String				guifg=#95e454	gui=italic
hi Identifier			guifg=#cae682	gui=none
hi Function				guifg=#cae682	gui=none
hi Type					guifg=#cae682	gui=none
hi Statement			guifg=#8ac6f2	gui=none
hi Keyword				guifg=#8ac6f2	gui=none
hi PreProc				guifg=#e5786d	gui=none
hi Number				guifg=#e5786d	gui=none
hi Special				guifg=#e7f6da	gui=none


" Additions to original wombat color scheme:

hi Search				ctermfg=177		ctermbg=240
hi Cursor				ctermfg=234		ctermbg=228

hi Search				guifg=#d787ff	guibg=#5f5f5f
hi Cursor				guifg=#222222	guibg=#ecee90

" Diff highlighting
hi DiffAdd									ctermbg=17
hi DiffChange								ctermbg=236
hi DiffDelete			ctermfg=234		ctermbg=60
hi DiffText									ctermbg=88		cterm=none

hi DiffAdd									guibg=#00005f
hi DiffChange								guibg=#383030
hi DiffDelete			guifg=#242424	guibg=#5f5f87	gui=none
hi DiffText									guibg=#870000	gui=none

" Links
hi! link NonText		LineNr
hi! link FoldColumn	Folded

" vim:set ts=3 sw=3 noet:

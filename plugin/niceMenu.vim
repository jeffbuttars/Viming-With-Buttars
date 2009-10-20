"    Author:  Jeff Buttars(jeffbuttars@gmail.com)
"             a easy config auto complete popup plugin
"   Version:  v01
"   Created:  2009-10-14
"   License:  Copyright (c)2009
"             This program is free software; you can redistribute it and/or
"             modify it under the terms of the GNU General Public License as
"             published by the Free Software Foundation, version 2 of the
"             License.
"             This program is distributed in the hope that it will be
"             useful, but WITHOUT ANY WARRANTY; without even the implied
"             warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
"             PURPOSE.
"             See the GNU General Public License version 2 for more details.
"     Usage:  Important NOTE: This plugin will only work if your using vim
"    		  built with clientserver enabled. If your  
"     		  Put this file in your VIM plugin dir  
"
"             You can set usr pupop like this.
"             let b:useTable = [[auto_exec_complete1, key_word], ...]
"
"             All Option is belong to current buffer, 
"             so if you put it in ther .vimrc you need 
"
"             For c gtk Complete:
"             autocmd FileType c
"                         \ let b:usrTable = [
"                         \ ["\<c-x>\<c-o>",'\k\.','\k->',
"                         \ 'gtk_\k\{2,}','GTK_\k\{1,}','Gtk\k\{1,}',
"                         \ 'gdk_\k\{2,}','GDK_\k\{1,}','Gdk\k\{1,}',
"                         \ 'g_\k\{2,}', 'G_\k\{1,}'],
"                         \ ["\<c-n>",'\k\{3,}'],
"                         \ ]
"
"popup_it.vim: {{{1
if !has("clientserver")
    finish
endif
if v:version < 700 || exists("loaded_menu_delayed")
    finish
endif

" Set g:NiceMenuDelay in your .vimrc to change the menu delay
" You can even change this based on the filetype if you wish or
" while vim is running.
if !exists( "NiceMenuDelay" )
	let g:NiceMenuDelay = '.5' 
endif

let loaded_menu_delayed= 1

let s:keys    = [
            \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
            \ 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            \ 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
            \ 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
            \ 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2',
            \ '3', '4', '5', '6', '7', '8', '9', '-', '_', '~', '^',
            \ '.', ',', ':', '!', '#', '=', '%', '$', '@', '<', '>',
            \ '/', '\', '']

autocmd bufreadpost,BufNewFile * call <SID>NiceMenuCplRun()
autocmd FileType * call <SID>NiceMenuCplRun()


amenu <silent> &Complete.Auto\ Start :call <SID>NiceMenuCplRun()<CR>
amenu <silent> &Complete.Auto\ Stop  :call <SID>NiceMenuCplClr()<CR>

fun! s:GetSid()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfun


python << PEOF
import vim,threading,subprocess
ptimer = None

def NiceMenuShowMenu():

	sname = vim.eval( 'v:servername' )
	if not sname or sname == "":
		return

	try:
		dnull = open( '/dev/null' , 'w' )
		subprocess.call( ["gvim", "--servername", "%s"%sname, "--remote-expr", "NiceMenuAsyncCpl()"],
	  		stdout=dnull, stderr=dnull )
	except:
		pass
PEOF

"NiceMenuCheckContext: {{{1
fun! s:NiceMenuCheckContext()
	
    "ignore
    if &paste 
        return ""
    end

	" Still in testing
	"if pumvisible()
		"return ""
	"endif

python << PEOF
global ptimer
if ptimer:
	ptimer.cancel()

delay = vim.eval("g:NiceMenuDelay")
if not delay:
	delay = '.8'
ptimer = threading.Timer( float(delay), NiceMenuShowMenu )
ptimer.start()
PEOF
	return ""
endfun

"NiceMenuCplClr: {{{1
fun! s:NiceMenuCplClr()
    let b:pumTips = ''
    let b:nowcpl  = []
    for key in s:keys
        if maparg(key, 'i') =~ 'NiceMenuCpl'
            exec "silent! iunmap <buffer> ".key
        endif
    endfor
    silent! iunmap <buffer> <c-x><c-o>
    silent! iunmap <buffer> <c-n>
    silent! iunmap <buffer> <c-b>
endfun

" Setup the mapping to trigger the menu events
"NiceMenuCplRun: {{{1
fun! s:NiceMenuCplRun()
    call s:NiceMenuCplClr()
    call s:GetNowCpl()

    if has("autocmd") && exists("+omnifunc")
        if &omnifunc == "" 
            setlocal omnifunc=syntaxcomplete#Complete 
        endif
    endif
    silent! inoremap <buffer> <expr> <c-x><c-o> 
                \ (pumvisible()?"\<c-y>":"").
                \ "\<c-x>\<c-o>\<c-r>=<SID>NiceMenuFix('OmniTips')\<cr>"
    silent! inoremap <buffer> <expr> <c-n> 
                \ (pumvisible()?"\<c-n>":
                \ "\<c-n>\<c-r>=<SID>NiceMenuFix('CtrlNTips')\<cr>")
    silent! inoremap <buffer> <expr> <c-b>
                \ (pumvisible()?"\<c-y>":"").
                \ "\<c-n>\<c-r>=<SID>NiceMenuFix('CtrlNTips')\<cr>"

    for key in s:keys
        if maparg(key, 'i') == ''
            exec "silent! inoremap <buffer> ".key." ".key.
                        \ "\<c-r>=<SID>NiceMenuCheckContext()\<cr>"
		endif
    endfor
endfun

"NiceMenuFix: {{{1
fun! s:NiceMenuFix(who)
    if !pumvisible() 
        call feedkeys("\<c-e>", "n")
    else
        let b:pumTips = a:who
        call feedkeys("\<c-p>", "n")
    endif
    return ""
endfun

fun! NiceMenuAsyncCpl()

	if "i" != mode()
        return ""
	endif
	 
    "ignore
    if &paste 
        return ""
    endif

	" Not sure about this yet.
    "if pumvisible()
        "return ""
    "endif

	" Make sure the current character
	" is in the allowed key map. In the time
	" past since the trigger the cursor may be on a
	" char we don't want to complete.
    let b:nchar = getline('.')[col('.')-2]
	let b:goahead = 0
	for key in s:keys
		if key == b:nchar
			let b:goahead = 1
			break
		endif
	endfor
	if 0 == b:goahead
		return ""
	endif

    if pumvisible() && (b:pumTips == "SnipTips" 
                \ ||b:pumTips == "SelTips"
                \ ||b:pumTips == "CtrlNTips"
                \ ||b:pumTips == "OmniTips"
                \)
        return ""
    endif

    let iLine = getline('.')[:col('.')-2]
    let i = 0
    for cpl in b:nowcpl
        let first_item = 1
        for pattern in cpl
            if first_item == 1 
                let first_item = 0
                continue
            endif
            if pattern != "" && iLine =~ '\m\C'.pattern.'$'
                if !(pumvisible() && b:pumTips == "AutoTips".i)
                    "\C-r = don't see map
                    "return cpl[0]."\<c-r>=".s:GetSid()."NiceMenuFix('AutoTips".i."')\<CR>"
                    "Feedkeys seed map
                    let mapFlag = 'm'
                    if cpl[0] == "\<c-n>" 
                                \|| cpl[0] == "\<c-x>\<c-o>" 
                        let mapFlag = 'n'
                    end
                    let stopCpl = ""
                    if pumvisible()
                        let stopCpl = "\<c-e>"
                    endif
					let cplcmd = stopCpl.cpl[0]."\<c-r>=".s:GetSid()."NiceMenuFix('AutoTips".i."')\<CR>"
					"let cplcmd = stopCpl.cpl[0]
					call feedkeys( cplcmd, mapFlag ) 
                    return ""
                else
                    return ""
                endif
            endif
        endfor
        let i += 1
    endfor
    return ""
endfun

"NiceMenuExtend: {{{1
fun! s:NiceMenuExtend(list1, list2)
    let listTmp = copy(a:list1)
    for item2 in a:list2
        let append = 1
        for item1 in listTmp
            if item2[0] == item1[0]
                let append = 0
                break
            endif
        endfor
        if append 
            call add(a:list1, item2)
        endif
    endfor
endfun

"GetNowCpl: {{{1
fun! s:GetNowCpl()
    if exists("b:usrTable") && type(b:usrTable) ==  type([])
        call s:NiceMenuExtend(b:nowcpl, b:usrTable)
    endif
    if has_key(s:defTable, &ft)
        call s:NiceMenuExtend(b:nowcpl, s:defTable[&ft])
    endif
    call s:NiceMenuExtend(b:nowcpl, s:defTable['*'])
endfun

"def Table: {{{1
let s:defTable = {}
let s:defTable["*"]    = [
            \ ["\<c-x>\<c-f>",'\f/\f\{1,}'],
            \ ["\<c-n>",'\k\@<!\k\{3,20}'],
            \]
let s:defTable["c"]    = [
            \ ["\<c-x>\<c-o>",'\k\.','\k->'],
            \ ["\<c-n>",'\k\{4,\}'],
            \]
let s:defTable["text"]  = [
            \ ["\<c-n>",'\\\k\{2,20}','\([\|{\)\k\{2,20}'],
            \ ["\<c-k>",'\\\k\{4,20}','\([\|{\)\k\{4,20}'],
            \]
let s:defTable["mkd"]  = [
            \ ["\<c-n>",'\\\k\{3,20}','\([\|{\)\k\{3,20}'],
            \ ["\<c-k>",'\\\k\{4,20}','\([\|{\)\k\{4,20}'],
            \]
let s:defTable["html"] = [
            \ ["\<c-x>\<c-o>",'&','<','</','<.*\s\+\k','<.*\k\+\s*="\k'],
            \]
let s:defTable["css"] = [
            \ ["\<c-x>\<c-o>",'\(\k\|-)\@<!\(\k\|-\)\{2,}'],
            \]
let s:defTable["javascript"] = [
            \ ["\<c-x>\<c-o>",'\k\.'],
            \ ["\<c-n>",'\k\{4,\}'],
            \]
let s:defTable["php"]    = [
            \ ["\<c-x>\<c-o>",'\k.'],
            \ ["\<c-n>",'\k\{4,\}'],
            \]
let s:defTable["python"]    = [
            \ ["\<c-x>\<c-o>",'\k.'],
            \ ["\<c-n>",'\k\{3,\}'],
            \]
" vim: set ft=vim ff=unix fdm=marker :

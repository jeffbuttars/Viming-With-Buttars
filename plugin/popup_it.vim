"    Author:  Fvw (vimtexhappy@gmail.com)
"             a easy config auto complete popup plugin
"   Version:  v01.02
"   Created:  2008-09-10
"   License:  Copyright (c) 2001-2009, Fvw
"             This program is free software; you can redistribute it and/or
"             modify it under the terms of the GNU General Public License as
"             published by the Free Software Foundation, version 2 of the
"             License.
"             This program is distributed in the hope that it will be
"             useful, but WITHOUT ANY WARRANTY; without even the implied
"             warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
"             PURPOSE.
"             See the GNU General Public License version 2 for more details.
"     Usage:  Put this file in your VIM plugin dir  
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
if v:version < 700 || exists("loaded_popup_it")
    finish
endif
let loaded_popup_it= 1

let s:keys    = [
            \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
            \ 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            \ 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
            \ 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
            \ 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2',
            \ '3', '4', '5', '6', '7', '8', '9', '-', '_', '~', '^',
            \ '.', ',', ':', '!', '#', '=', '%', '$', '@', '<', '>',
            \ '/', '\']

autocmd bufreadpost,BufNewFile * call <SID>AutoCplRun()
autocmd FileType * call <SID>AutoCplRun()
amenu <silent> &Complete.Auto\ Start :call <SID>AutoCplRun()<CR>
amenu <silent> &Complete.Auto\ Stop  :call <SID>AutoCplClr()<CR>

fun! s:GetSid()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfun

"AutoCplClr: {{{1
fun! s:AutoCplClr()
    let b:pumTips = ''
    let b:nowcpl  = []
    for key in s:keys
        if maparg(key, 'i') =~ 'AutoCpl'
            exec "silent! iunmap <buffer> ".key
        endif
    endfor
    silent! iunmap <buffer> <c-x><c-o>
    silent! iunmap <buffer> <c-n>
    silent! iunmap <buffer> <c-b>
endfun

"AutoCplRun: {{{1
fun! s:AutoCplRun()
    call s:AutoCplClr()
    call s:GetNowCpl()

    if has("autocmd") && exists("+omnifunc")
        if &omnifunc == "" 
            setlocal omnifunc=syntaxcomplete#Complete 
        endif
    endif
    silent! inoremap <buffer> <expr> <c-x><c-o> 
                \ (pumvisible()?"\<c-y>":"").
                \ "\<c-x>\<c-o>\<c-r>=<SID>AutoFix('OmniTips')\<cr>"
    silent! inoremap <buffer> <expr> <c-n> 
                \ (pumvisible()?"\<c-n>":
                \ "\<c-n>\<c-r>=<SID>AutoFix('CtrlNTips')\<cr>")
    silent! inoremap <buffer> <expr> <c-b>
                \ (pumvisible()?"\<c-y>":"").
                \ "\<c-n>\<c-r>=<SID>AutoFix('CtrlNTips')\<cr>"

    for key in s:keys
        if maparg(key, 'i') == ''
            exec "silent! inoremap <buffer> ".key." ".key.
                        \ "\<c-r>=<SID>AutoCpl()\<cr>"
		endif
    endfor
endfun

"AutoFix: {{{1
fun! s:AutoFix(who)
    if !pumvisible() 
        call feedkeys("\<c-e>", "n")
    else
        let b:pumTips = a:who
        call feedkeys("\<c-p>", "n")
    endif
    return ""
endfun

"AutoCpl: {{{1
fun! s:AutoCpl()
	 
    "ignore
    if &paste 
        return ""
    end

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
                    "return cpl[0]."\<c-r>=".s:GetSid()."AutoFix('AutoTips".i."')\<CR>"
                    "Feedkeys seed map
                    let mapFlag = 'm'
                    if cpl[0] == "\<c-n>" 
                                \|| cpl[0] == "\<c-x>\<c-o>" 
                        let mapFlag = 'n'
                    else
                        let mapFlag = 'm'
                    end
                    let stopCpl = ""
                    if pumvisible()
                        let stopCpl = "\<c-e>"
                    endif
                    call feedkeys(
                                \ stopCpl.
                                \ cpl[0].
                                \ "\<c-r>=".s:GetSid()."AutoFix('AutoTips".i."')\<CR>"
                                \ , mapFlag)
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

"MyExtend: {{{1
fun! s:MyExtend(list1, list2)
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
        call s:MyExtend(b:nowcpl, b:usrTable)
    endif
    if has_key(s:defTable, &ft)
        call s:MyExtend(b:nowcpl, s:defTable[&ft])
    endif
    call s:MyExtend(b:nowcpl, s:defTable['*'])
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
let s:defTable["tex"]  = [
            \ ["\<c-n>",'\\\k\{3,20}','\([\|{\)\k\{3,20}'],
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
            \ ["\<c-x>\<c-o>",'\k\{3,\}'],
            \ ["\<c-n>",'\k\{4,\}'],
            \]
" vim: set ft=vim ff=unix fdm=marker :

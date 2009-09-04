"    Author:  Vande (vimtexhappy@gmail.com)
"             a easy config auto complete popup plugin
"   Version:  v01
"   Created:  2008-03-14
"   License:  Copyright (c) 2001-2009, Vande
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
"             You can put a user auto popup table in you .vimrc like this:
"             let useTable[filetype] = [[auto_exec_complete1, key_word], ...]
"
"             This is a example for c file.
"             let usrTable = {}
"             let usrTable["c"] = [
"                         \ ["\<c-x>\<c-o>",'\k.','\k->',
"                         \ 'gtk_\k\{2,\}','GTK_\k\{1,\}','Gtk\k\{1,\}',
"                         \ 'g_\k\{2,\}', 'G_\k\{1,\}'],
"                         \ ["\<c-n>",'\k\{3,\}'],
"                         \]
"             When you type . -> gtk_(>2char) GTK_(>1char) Gtk_(>1char) 
"             g_(>2char) G_(>1char) than <c-x><c-o> exec.
"             When you type >3char <c-n> exec.
"popup_it.vim: {{{1
if v:version < 700 || exists("loaded_popup_it")
    finish
endif
let loaded_popup_it= 1

let popup_it_in_word = 0

let s:keys    = [
            \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
            \ 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            \ 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
            \ 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
            \ 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2',
            \ '3', '4', '5', '6', '7', '8', '9', '-', '_', '~', '^',
            \ '.', ',', ':', '!', '#', '=', '%', '$', '@', '<', '>',
            \ '/', '\']

autocmd bufreadpost,BufNewFile * call AutoCompleteStart()
amenu <silent> &Complete.Auto\ Start :call AutoCompleteStart()<CR>
amenu <silent> &Complete.Auto\ Stop  :call ClearAutoComplete()<CR>


"ClearAutoComplete: {{{1
fun! ClearAutoComplete()
    let b:pumtips = ''
    let b:nowcpl  = []
    if maparg('<c-b>', 'i') =~ 'AutoSelect'
        silent! iunmap <buffer> <c-b>
    endif
    for key in s:keys
        if maparg(key, 'i') =~ 'AutoComplete'
            exec "silent! iunmap <buffer> ".key
        endif
    endfor
endfun

"AutoCompleteStart: {{{1
fun! AutoCompleteStart()
    call ClearAutoComplete()
    call s:GetNowCpl()
    setlocal completeopt=menuone
    if has("autocmd") && exists("+omnifunc")
        if &omnifunc == "" 
            setlocal omnifunc=syntaxcomplete#Complete 
        endif
    endif
    if maparg('<c-b>', 'i') == ''
        silent! inoremap <buffer> <c-b> 
                    \ <c-x><c-o><c-r>=AutoSelect('OmniTips')<cr>
    endif
    for key in s:keys
        if maparg(key, 'i') == ''
            exec "silent! inoremap <buffer> "
                        \ .key." ".key."\<c-r>=<SID>AutoComplete()\<CR>"
        endif
    endfor
endfun

"AutoSelect: {{{1
fun! AutoSelect(who)
    if !pumvisible() 
        return ''
    endif
    let b:pumtips = a:who
    return "\<c-p>"
endfun

"AutoComplete: {{{1
fun! s:AutoComplete()
    let iLine = getline('.')[:col('.')-2]
    let i = 0
    for cpl in b:nowcpl
        let first_item = 1
        for pattern in cpl
            if first_item == 1 
                let first_item = 0
                continue
            endif
            if iLine =~ '\V\C'.pattern.'\$'
                if pumvisible() && b:pumtips == "AutoTips".i
                    return ""
                else 
                    return cpl[0]."\<c-r>=AutoSelect('AutoTips".i."')\<CR>"
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
    if exists("g:usrTable") && has_key(g:usrTable, &ft)
        call s:MyExtend(b:nowcpl, g:usrTable[&ft])
    endif
    if has_key(s:defTable, &ft)
        call s:MyExtend(b:nowcpl, s:defTable[&ft])
    endif
    call s:MyExtend(b:nowcpl, s:defTable['*'])
endfun

"defTable: {{{1
let s:defTable = {}
let s:defTable["*"]    = [
            \ ["\<c-n>",'\k\{3,\}']
            \]
let s:defTable["c"]    = [
            \ ["\<c-x>\<c-o>",'\k.','\k->'],
            \ ["\<c-n>",'\k\{3,\}'],
            \]
let s:defTable["tex"]  = [
            \ ["\<c-n>",'\\\k\{2,\}','\([\|{\)\.\*\k\{2,\}'],
            \]
let s:defTable["html"] = [
            \ ["\<c-x>\<c-o>",'<','</','<\.\*\s\+\k','<\.\*\k\+\s\*="\k'],
            \]
" vim: set ft=vim ff=unix fdm=marker :

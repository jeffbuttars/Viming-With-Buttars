" Vim syntax file
" Language:     markmin
" Author:       Jeff Buttars <jeffbuttrs@gmail.com>
" Version:      1.0.0
" Last Change:  2011.09.29
"
" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif

syntax spell toplevel
syntax case ignore
syntax sync linebreaks=1


let b:current_syntax = "markmin"

delcommand HtmlHiLink
" vim: tabstop=2

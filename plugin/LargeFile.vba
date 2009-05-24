" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
plugin/LargeFile.vim	[[[1
72
" LargeFile: Sets up an autocmd to make editing large files work with celerity
"   Author:		Charles E. Campbell, Jr.
"   Date:		May 24, 2007
"   Version:	3
" GetLatestVimScripts: 1506 1 LargeFile.vim
" \| echomsg 'f='.f.' getfsize(f)='.getfsize(f).' g:LargeFile='.g:LargeFile.'M'

" ---------------------------------------------------------------------
" Load Once: {{{1
if exists("g:loaded_LargeFile") || &cp
 finish
endif
let g:loaded_LargeFile = "v3"
let s:keepcpo          = &cpo
set cpo&vim

" ---------------------------------------------------------------------
" Commands: {{{1
com! Unlarge call s:Unlarge()

" ---------------------------------------------------------------------
"  Options: {{{1
if !exists("g:LargeFile")
 let g:LargeFile= 20	" in megabytes
endif

" ---------------------------------------------------------------------
"  LargeFile Autocmd: {{{1
" for large files: turns undo, syntax highlighting, undo off etc
" (based on vimtip#611)
augroup LargeFile
 au!
 au BufReadPre *
 \  let f=expand("<afile>")
 \| if getfsize(f) >= g:LargeFile*1024*1024 || getfsize(f) <= -2
 \|  let b:eikeep = &ei
 \|  let b:ulkeep = &ul
 \|  let b:bhkeep = &bh
 \|  let b:fdmkeep= &fdm
 \|  let b:swfkeep= &swf
 \|  set ei=FileType
 \|  setlocal noswf bh=unload fdm=manual
 \|  let f=escape(substitute(f,'\','/','g'),' ')
 \|  exe "au LargeFile BufEnter ".f." set ul=-1"
 \|  exe "au LargeFile BufLeave ".f." let &ul=".b:ulkeep."|set ei=".b:eikeep
 \|  exe "au LargeFile BufUnload ".f." au! LargeFile * ". f
 \|  echomsg "***note*** handling a large file"
 \| endif
 au BufReadPost *
 \  if &ch < 2 && getfsize(expand("<afile>")) >= g:LargeFile*1024*1024
 \|  echomsg "***note*** handling a large file"
 \| endif
augroup END

" ---------------------------------------------------------------------
" s:Unlarge: this function will undo what the LargeFile autocmd does {{{2
fun! s:Unlarge()
"  call Dfunc("s:Unlarge()")
  if exists("b:eikeep") |let &ei  = b:eikeep |endif
  if exists("b:ulkeep") |let &ul  = b:ulkeep |endif
  if exists("b:bhkeep") |let &bh  = b:bhkeep |endif
  if exists("b:fdmkeep")|let &fdm = b:fdmkeep|endif
  if exists("b:swfkeep")|let &swf = b:swfkeep|endif
  doau FileType
"  call Dret("s:Unlarge")
endfun

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
doc/LargeFile.txt	[[[1
41
*LargeFile.txt*	Editing Large Files Quickly			May 24, 2007

Author:  Charles E. Campbell, Jr.  <NdrOchip@ScampbellPfamily.AbizM>
	  (remove NOSPAM from Campbell's email first)
Copyright: (c) 2004-2007 by Charles E. Campbell, Jr.	*LargeFile-copyright*
           The VIM LICENSE applies to LargeFile.vim
           (see |copyright|) except use "LargeFile" instead of "Vim"
	   No warranty, express or implied.  Use At-Your-Own-Risk.

==============================================================================
1. Large File Plugin						*largefile* {{{1

The LargeFile plugin is fairly short -- it simply sets up an |autocmd| that
checks for large files.  There is one parameter: >
	g:LargeFile
which, by default, is 100.  Thus with this value of g:LargeFile, 100MByte
files and larger are considered to be "large files"; smaller ones aren't.  Of
course, you as a user may set g:LargeFile to whatever you want in your
<.vimrc> (in units of MBytes).

LargeFile.vim always assumes that when the file size is larger than what
can fit into a signed integer (2^31, ie. about 2GB) that the file is "Large".

Basically, this autocmd simply turns off a number of features in Vim,
including event handling, undo, and syntax highlighting, in the interest of
speed and responsiveness.

LargeFile.vim borrows from vimtip#611.

To undo what LargeFile does, type >
	:Unlarge
<
==============================================================================
2. History						*largefile-history* {{{1

  3 : May 24, 2007 * Unlarge command included
                   * If getfsize() returns something less than -1, then it
		     will automatically be assumed to be a large file.

==============================================================================
vim:tw=78:ts=8:ft=help:fdm=marker:

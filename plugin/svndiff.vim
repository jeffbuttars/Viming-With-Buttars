"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" svndiff (C) 2007 Ico Doornekamp
"
" Introduction
" ------------
"
" NOTE: This plugin is linux-only!
"
" An experimental vim 7.0 plugin for showing svn diff information in a file
" while editing. This plugin runs a diff between the current buffer and the
" original subversion file, and applies highlighting to show where the buffer
" differs. The original text is not shown, only colors are used to indicate
" where changes were made.
"
" The following syntax highlight groups are used:
"
"   DiffAdd:    Newly added lines. (default=blue)
"
"   DiffChange: Lines which are changed from the original. (default=cyan)
"
"   DiffDel:    Applied to the lines directly above and below a deleted 
"               block (default=magenta)
"
" Usage
" -----
"
" The plugin defines one function: Svndiff_show(). This function figures out
" the difference between the current file and it's subversion original, and
" creates the syntax highlighting patterns. You'll need to call this function
" after making changes to update the highlighting.
"
" The function takes an optional argument specifying an additional action to
" perform:
"
"   "prev": jump to the previous different block 
"   "next": jump to the next different block
"
" You might want to map some keys to run the Svndiff_show function. For example, 
" add to your .vimrc:
"
"   noremap <F3> :call Svndiff_show("prev")<CR>
"   noremap <F4> :call Svndiff_show("next")<CR>
"
" And optionally another keymap to cleanup the diff highlighting and revert to
" the original syntax:
"
"   noremap <F5> :syntax on<CR>
"
"
" Changelog
" ---------
"
" 1.0 2007-04-02	Initial version
"
" 1.1 2007-04-02	Added goto prev/next diffblock commands
"
" 1.2 2007-06-14  Updated diff arguments from -u0 (obsolete) to -U0
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


function! Svndiff_show(...)

	let cmd = exists("a:1") ? a:1 : ''
	let fname = bufname("%")
	let jump_to = 0


	" Check if this file is managed by subversion, exit otherwise
	
	let info = system("svn info " . fname)
	if match(info, "Path") == -1
		echom "Svndiff: Warning, file " . fname . " is not managed by subversion, or error running svn."
		return
	end


	" Reset syntax highlighting
	
	syntax off


	" Pipe the current buffer contents to a shell command calculating the diff
	" in a friendly parsable format

	let contents = join(getbufline("%", 1, "$"), "\n")
	let diff = system("diff -U0 <(svn cat " . fname . ") <(cat;echo)", contents)


	" Parse the output of the diff command and hightlight changed, added and
	" removed lines

	for line in split(diff, '\n')
		
    let part = matchlist(line, '@@ -\([0-9]*\),*\([0-9]*\) +\([0-9]*\),*\([0-9]*\) @@')

		if ! empty(part)
			let old_from  = part[1]
			let old_count = part[2] == '' ? 1 : part[2]
			let new_from  = part[3]
			let new_count = part[4] == '' ? 1 : part[4]

			" Figure out if text was added, removed or changed.
			
			if old_count == 0
				let from  = new_from
				let to    = new_from + new_count - 1
				let group = 'DiffAdd'
			elseif new_count == 0
				let from  = new_from
				let to    = new_from + 1
				let group = 'DiffDelete'
			else
				let from  = new_from
				let to    = new_from + new_count - 1
				let group = 'DiffChange'
			endif

			" Set the actual syntax highlight
			
			exec 'syntax region ' . group . ' start=".*\%' . from . 'l" end=".*\%' . to . 'l"'


			" Check if we need to jump to prev/next diff block

			if cmd == 'prev'
				if from < line(".")
					let jump_to = from 
				endif
			endif

			if cmd == 'next' 
				if from > line(".") 
					if jump_to == 0 
						let jump_to = from 
					endif
				endif
			endif

		endif

	endfor

	if jump_to > 0
		call setpos(".", [ 0, jump_to, 1, 0 ])
	endif

endfunction


" vi: ts=2 sw=2


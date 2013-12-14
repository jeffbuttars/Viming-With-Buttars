if exists("b:htmltidy_plugin_loaded")
  finish
endif

" Uncomment the next line to use tidy as the = program
"exe 'set equalprg=tidy -quiet -f '.&errorfile

fun! s:HTMLTidyLint()

	let l:tidy_errors = system("tidy ".expand('%'))
	let l:has_errors = 0

	cclose " Close quickfix window
	cexpr [] " Create empty quickfix list

	if strlen(l:tidy_errors) > 0
		for error in split( l:tidy_errors,"\n" )
			"Match errors like: 'line 142 column 9 - Warning: <div> proprietary attribute'
			let l:eparts = matchlist( error, "^line\ \\(\\d\\+\\)\ column\ \\(\\d\\+\\)\ -\ \\(.*\\)$" )
			if !empty(l:eparts) && len(l:eparts) > 2
				let l:has_errors = 1
				"filename:line#:col#:errormsg"
				caddexpr expand("%") . ":" . l:eparts[1] . ":" . l:eparts[2] . ":" . l:eparts[3]
			endif
		endfor
	endif

	if l:has_errors
		copen
	else
		echo "HTMLTidyLint: All good."
	endif
endfun
command! HTMLTidyLint call s:HTMLTidyLint()


let b:htmltidy_plugin_loaded = 1


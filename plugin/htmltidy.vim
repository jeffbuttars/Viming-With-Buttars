if exists("b:htmltidy_plugin_loaded")
  finish
endif

fun! s:HTMLTidy()

	let l:tidy_errors = system("tidy ".expand('%'))
	let l:has_errors = 0

	cclose " Close quickfix window
	cexpr [] " Create empty quickfix list

	if strlen(l:tidy_errors) > 0
		for error in split( l:tidy_errors,"\n" )
			"Match 'line 142 column 9 - Warning: <div> proprietary attribute'
			"let l:eparts = matchlist( error, "^.*:\\(.*\\)\ in\ \\(.*\\)\ on\ line\ \\(\\d\\+\\)" )
			let l:eparts = matchlist( error, "^line\ \\(\\d\\+\\)\ column\ \\(\\d\\+\\)\ -\ \\(.*\\)$" )
			if !empty(l:eparts) && len(l:eparts) > 2
				let l:has_errors = 1
				caddexpr expand("%") . ":" . l:eparts[1] . ":" . l:eparts[2] . ":" . l:eparts[3]
			endif
		endfor
	endif

	if l:has_errors
		copen
	else
		echo "HTMLTidy: All good."
	endif
endfun
command! HTMLTidy call s:HTMLTidy()

let b:htmltidy_plugin_loaded = 1

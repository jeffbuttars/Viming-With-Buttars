if exists("b:bashrun_plugin_loaded")
  finish
endif

fun! s:BashRun()

	let b:bash_errors = system("bash ".expand('%'))
	let b:has_errors = 0

	cclose " Close quickfix window
	cexpr [] " Create empty quickfix list

	if strlen(b:bash_errors) > 0
		for error in split( b:bash_errors,"\n" )
			"Match {file}: line {line}: {message}
			let b:eparts = matchlist( error, "^\\(.*\\):\ line\ \\(\\d\\+\\):\ \\(.*\\)$" )
			if !empty(b:eparts) && len(b:eparts) > 2
				let b:has_errors = 1
				caddexpr b:eparts[1] . ":" . b:eparts[2] . ":" . b:eparts[3]
			endif
		endfor
	endif

	if b:has_errors
		copen
	else
		echo "BashRun: All good."
	endif
endfun
command! BashRun call s:BashRun()

let b:bashrun_plugin_loaded = 1


if exists("b:phplint_plugin_loaded")
  finish
endif

fun! s:PHPLintRaw()
	echo system("php -l ".expand('%'))
endfun

fun! s:PHPLint()

	let b:php_errors = system("php -l ".expand('%'))
	let b:has_errors = 0

	cclose " Close quickfix window
	cexpr [] " Create empty quickfix list

	if strlen(b:php_errors) > 0
		for error in split( b:php_errors,"\n" )
			"Match {message} in {file} on line {line}
			let b:eparts = matchlist( error, "^.*:\\(.*\\)\ in\ \\(.*\\)\ on\ line\ \\(\\d\\+\\)" )
			if !empty(b:eparts) && len(b:eparts) > 2
				let b:has_errors = 1
				caddexpr b:eparts[2] . ":" . b:eparts[3] . ":" . b:eparts[1]
			endif
		endfor
	endif

	if b:has_errors
		copen
	else
		echo "PHPLint: All good."
	endif
endfun
command! PHPLint call s:PHPLint()
command! PHPLintRaw call s:PHPLintRaw()

let b:phplint_plugin_loaded = 1

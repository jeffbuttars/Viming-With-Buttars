
" Get jsonval at:
" URL: http://github.com/dangerousben/jsonval

if exists("b:jsonlint_plugin_loaded")
  finish
endif

fun! s:JSONLint()

	let b:json_errors = system("jsonval ".expand('%'))
	let b:has_errors = 0

	cclose " Close quickfix window
	cexpr [] " Create empty quickfix list

	if strlen(b:json_errors) > 0
		for error in split( b:json_errors,"\n" )
			"Match {message} in {file} on line {line}
			"errorformat=%E%f:\ %m\ at\ line\ %l,%-G%.%#
			" TODO: fix matchilist to match above errorformat
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
		echo "JSONLint: All good."
	endif
endfun
command! JSONLint call s:JSONLint()

let b:jsonlint_plugin_loaded = 1

if exists("b:myfind_plugin_loaded")
  finish
endif

fun! s:Find( ... )

	let l:find_args = join(a:000, " ")
	echo "Be patient, running find " l:find_args
	let b:find_results = system("find ".l:find_args)
	let b:has_results = 0

	cclose " Close quickfix window
	cexpr [] " Create empty quickfix list

	if strlen(b:find_results) > 0
		for result in split( b:find_results,"\n" )
			"Match {message} in {file} on line {line}
			let b:has_results = 1
			caddexpr result . ":0: "
		endfor
		copen
	else
		echo "Found nothing"
	endif

endfun
command! -nargs=* Find call s:Find()

let b:myfind_plugin_loaded = 1

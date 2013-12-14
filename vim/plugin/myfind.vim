if exists("b:myfind_plugin_loaded")
  finish
endif

fun! g:Find( firstarg, ... )

	let l:find_args = a:firstarg . " " . join(a:000, " ")
	echo "Be patient, running find" l:find_args

	let b:find_results = system("find ".l:find_args)
	let b:has_results = 0

	cclose " Close quickfix window
	cexpr [] " Create empty quickfix list

	if strlen(b:find_results) > 0
		for result in split( b:find_results,"\n" )
			"Match {filename}:{linenumber}:{message} 
			let b:has_results = 1
			caddexpr result.":0:F"
		endfor
		copen
	else
		echo "Found nothing"
	endif

endfun
command! -nargs=* Find call g:Find( '<args>' )

set errorformat+=myfind:%f
let b:myfind_plugin_loaded = 1

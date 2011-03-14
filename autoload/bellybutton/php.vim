function bellybutton#php#exec()
	" If we find errors, return the matchlist.
	" If we don't find errors, or don't care about finding
	" errors, it's best to just print the results out.
	let sysout = system( "php ".shellescape(expand('%')))

	" sysout: the raw output from the command
	" ecode:  exit code of the command
	" good_ecode: what is a good exit code for the comand, any other exit code
	" is considered an error.
	" parse_error: if a bad exit code is found should bellybutton parse the
	" output and put error lines in the quickfix buffer
	"
	" If you just want to dump the output to the screen you only need to
	" provide sysout
	return {'sysout':l:sysout, 'ecode':v:shell_error, 'good_ecode':0, 'parse_error':1}
endfunction

function bellybutton#php#execParseError( e_line )
	return bellybutton#php#parseLintErrorLine( a:e_line )
endfunction

function bellybutton#php#lintRaw()
	return system( "php -ql ".shellescape(expand('%')))
endfunction

function bellybutton#php#parseLintErrorLine( e_line )
	"Match {message} in {file} on line {line}
	let l:eparts = matchlist( a:e_line, "^.*:\\(.*\\)\ in\ \\(.*\\)\ on\ line\ \\(\\d\\+\\)" )
	if !empty(l:eparts) && len(l:eparts) > 2
		" filename, line number, message
		return { 'filename':l:eparts[2], 'lnum':l:eparts[3], 'errmsg':l:eparts[1] }
	endif
	return {} 
endfunction

function bellybutton#php#Info()
	return "A helpful message"
endfunction

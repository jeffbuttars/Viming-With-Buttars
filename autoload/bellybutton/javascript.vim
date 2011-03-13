" Global Options
"
" Enable/Disable highlighting of errors in source.
" Default is Enable
" To disable the highlighting put the line
" let g:JSLintHighlightErrorLine = 0 
" in your .vimrc
if !exists("g:JSLintHighlightErrorLine")
	let g:JSLintHighlightErrorLine = 1 
endif
if !exists("g:JSLintIgnoreImpliedGlobals")
	let g:JSLintIgnoreImpliedGlobals = 0 
endif

if !exists("g:JSLintExecutable")
	let g:JSLintExecutable = ""
endif
let s:jslint_execs = ['js', 'd8'] 

function! s:JSLintClear()
  " Delete previous matches
  if exists('b:errors')
    for error in b:errors
      call matchdelete(error)
    endfor
  endif
endfunction

function! s:getJSExec()

	if len(g:JSLintExecutable) > 0 && executable(g:JSLintExecutable)
		return g:JSLintExecutable
	endif

	if has("win32")
		return 'cscript /NoLogo '
	endif

	for ext in s:jslint_execs
		if executable(ext)
			return ext
		endif
	endfor

	echoerr "No javascript executable found."
	return "" 
endfunction


"function bellybutton#javascript#exec()
	" If we find errors, return the matchlist.
	" If we don't find errors, or don't care about finding
	" errors, it's best to just print the results out.
	"let sysout = system( "php ".shellescape(expand('%')))

	" sysout: the raw output from the command
	" ecode:  exit code of the command
	" good_ecode: what is a good exit code for the comand, any other exit code
	" is considered an error.
	" parse_error: if a bad exit code is found should bellybutton parse the
	" output and put error lines in the quickfix buffer
	"
	" If you just want to dump the output to the screen you only need to
	" provide sysout
	"return {'sysout':l:sysout, 'ecode':v:shell_error, 'good_ecode':0, 'parse_error':1}
"endfunction

function bellybutton#javascript#execParseError( e_line )
	"return bellybutton#php#parseLintErrorLine( a:e_line )
endfunction

function bellybutton#javascript#lintRaw()

	let l:jslint = s:getJSExec()
	echo "Using jslint:" l:jslint
	"return system( "php -ql ".shellescape(expand('%')))

	"~/bin/d8 ~/bin/runjslint.js "`cat $1`" | ~/bin/format_lint_output.py
	" Set up command and parameters
	let l:bbase = BellyButtonModuleBase()."jslint/"
	if has("win32")
		let s:runjslint_ext = 'wsf'
	else
		let s:runjslint_ext = 'js'
	endif

	echo l:bbase
	let l:cmd = "cd " . l:bbase . " && " . l:jslint . " "
				\ . "runjslint." . s:runjslint_ext

	echo l:cmd
	let b:jslint_output = system(l:cmd, join(getline(1, '$'), "\n")."\n")
	return b:jslint_output
endfunction

function bellybutton#javascript#parseLintErrorLine( e_line )
	"
	" Match {line}:{char}:{message}
	let b:parts = matchlist(a:e_line, "\\(\\d\\+\\):\\(\\d\\+\\):\\(.*\\)")
	if empty(b:parts) || len(b:parts) < 3
		return {}
	endif

	" Implied global errors can be overwhelming. Let the user
	" squash that error if they wish.
	if g:JSLintIgnoreImpliedGlobals && b:parts[3] =~ '^Implied global'
		return {}
	endif

	return { 'filename':expand('%'), 'lnum':b:parts[1], 'char':b:parts[2], 'errmsg':b:parts[3] }
endfunction

function bellybutton#javascript#Info()
	return "A helpful message"
endfunction

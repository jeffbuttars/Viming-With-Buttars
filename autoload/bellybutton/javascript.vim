" Global Options
"
" Enable/Disable highlighting of errors in source.
" Default is Enable
" To disable the highlighting put the line
" let g:JSLintHighlightErrorLine = 0 
" in your .vimrc

	
" Available JSLint options, override the defaults
" with the var g:BBJSLint_Options = {}
"adsafe     true, if ADsafe rules should be enforced
"bitwise    true, if bitwise operators should not be allowed
"browser    true, if the standard browser globals should be predefined
"cap        true, if upper case HTML should be allowed
"'continue' true, if the continuation statement should be tolerated
"css        true, if CSS workarounds should be tolerated
"debug      true, if debugger statements should be allowed
"devel      true, if logging should be allowed (console, alert, etc.)
"es5        true, if ES5 syntax should be allowed
"evil       true, if eval should be allowed
"forin      true, if for in statements need not filter
"fragment   true, if HTML fragments should be allowed
"indent     the indentation factor
"maxerr     the maximum number of errors to allow
"maxlen     the maximum length of a source line
"newcap     true, if constructor names must be capitalized
"nomen      true, if names should be checked
"on         true, if HTML event handlers should be allowed
"onevar     true, if only one var statement per function should be allowed
"passfail   true, if the scan should stop on first error
"plusplus   true, if increment/decrement should not be allowed
"regexp     true, if the . should not be allowed in regexp literals
"rhino      true, if the Rhino environment globals should be predefined
"undef      true, if variables should be declared before used
"safe       true, if use of some browser features should be restricted
"windows    true, if MS Windows-specigic globals should be predefined
"strict     true, require the "use strict"; pragma
"sub        true, if all forms of subscript notation are tolerated
"white      true, if strict whitespace rules apply
"widget     true  if the Yahoo Widgets globals should be predefined
let s:jslint_options_defaults = { 'adsafe':0,
			\'bitwise':0, 'browser':0, 'cap':0,
			\'continue':0, 'css':0, 'debug':0,
			\'devel':0, 'es5':0, 'evil':0,
			\'forin':0, 'fragment':0, 'indent':0,
			\'maxerr':0, 'maxlen':0, 'newcap':0,
			\'nomen':0, 'on':0, 'onevar':0,
			\'passfail':0, 'plusplus':0, 'regexp':0,
			\'rhino':0, 'undef':0, 'safe':0,
			\'windows':0, 'strict':0, 'sub':0,
			\'white':0, 'widget':0 }


if !exists('g:BBJSLint_Options')
	" Set up some defaults, use the same defaults
	" from Crawkfords web version of jslint:
	" white 	: strict whitespace rules apply
	" onevar	: only one var statement per function should be allowed
	" undef     : variables should be declared before used
	" newcap    : constructor names must be capitalized
	" nomen     : names should be checked
	" regexp    : the . should not be allowed in regexp literals
	" plusplus  : increment/decrement should not be allowed
	" bitwise   : bitwise operators should not be allowed
	g:BBJSLint_Options = { 'white':1, 'onevar':1,
		\'undef':1, 'newcap':1, 'nomen':1,
		\'regexp':1, 'plusplus':1, 'bitwise':1 }
endif


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

function! s:getOptions()
	" verify any given options also exist
	" in our default options array, ignore
	" any that aren't.
	let l:jsl_opts = {}

	for key in keys(g:BBJSLint_Options)
		if get( s:jslint_options_defaults, key )
			if 1 != g:BBJSLint_Options[key]
				let g:BBJSLint_Options[key] = 0
			endif
			let l:jsl_opts[key] = g:BBJSLint_Options[key]
		endif
	endfor

	return l:jsl_opts
endfunction

function! s:writeOptionFile( jsl_opts )
	if !a:jsl_opts || empty(a:jsl_opts)
		return 0
	endif

	let l:jsl_str = "var BBJSLINT_OPTS = {};\n"
	for key in keys(a:jsl_opts)
		let l:jsl_str .= "BBJSLINT_OPTS['".key."'] = ".a:jsl_opts[key].";\n"
	endfor

	let l:fname = tempname()
	writefile(l:jsl_str, l:fname)

	return l:fname
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

"function bellybutton#javascript#execParseError( e_line )
	"return bellybutton#php#parseLintErrorLine( a:e_line )
"endfunction

function bellybutton#javascript#lintRaw()

	let l:jslint = s:getJSExec()

	"echo "Using jslint:" l:jslint

	" Set up command and parameters
	let l:bbase = BellyButtonModuleBase()."jslint/"
	if has("win32")
		let s:runjslint_ext = 'wsf'
	else
		let s:runjslint_ext = 'js'
	endif

	let l:opt_file = s:writeOptionFile(s:getOptions())

	"echo l:bbase
	let l:cmd = "cd " . l:bbase . " && " . l:jslint . " "
				\ . "runjslint." . s:runjslint_ext

	"echo l:cmd
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

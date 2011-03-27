" Global Options
"
" Enable/Disable highlighting of errors in source.
" Default is Enable
" To disable the highlighting put the line
" in your .vimrc

" Available JSLint options, override the defaults
" with the var g:BellyButton_javascript_jslint_options = {}
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
"
" XXXXXXXXXXXXXXXXXXXXXXXX This is one is very handy!!! XXXXXXXXXXXXXXXX
"predef		[] an array of globals for jslint to not rais an error on


function! BellyButton#javascript#load()
	let s:js_execs = [ {'exec':'d8'}, {'exec':'js','pre_opt':'-f '}]

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
	"
	" Here set up default options. The defaults
	" are taken from the default options enabled
	" on the jslint webpage with the excption
	" of 'adsafe'
	let s:jsl_default_options = { 'white':'true', 'onevar':'true',
			\'undef':'true', 'newcap':'true', 'nomen':'true',
			\'regexp':'true', 'plusplus':'true', 'bitwise':'true' }
endfunction

function! BellyButton#javascript#init()

	" Rebuild the options everytime.
	" This makes things more responsive
	" and immediate for the user when they change options
	" without restarting, because they don't have to 
	" restart. They adjust options mid hack and keep 
	" rocking.
	let s:jsl_options = copy(s:jsl_default_options)

	"merge the users global options over the default 
	"options
	if exists('g:BellyButton_javascript_jslint_options')
		"echo "BellyButton#javascript#init() initial g:BellyButton_javascript_jslint_options"
		for key in keys(g:BellyButton_javascript_jslint_options)
			if '' != get(g:BellyButton_javascript_jslint_options, key, '')
				let s:jsl_options[key] = g:BellyButton_javascript_jslint_options[key]
			endif
		endfor
	endif

	" merge any buffer local options
	" over the current options
	if exists('b:BellyButton_javascript_jslint_options')
		for key in keys(b:BellyButton_javascript_jslint_options)
			if '' != get(b:BellyButton_javascript_jslint_options, key, '')
				let s:jsl_options[key] = b:BellyButton_javascript_jslint_options[key]
			endif
		endfor
	endif

endfunction

function! s:getJSExec()

	if exists('g:JSLintExecutable') && 
				\!empty(g:JSLintExecutable) && 
				\0 != get(g:JSLintExecutable, 'exec') && 
				\executable(g:JSLintExecutable['exec'])
		return g:JSLintExecutable
	endif

	if has("win32")
		return 'cscript /NoLogo '
	endif

	for ext in s:js_execs
		if executable(ext['exec'])
			return ext
		endif
	endfor

	echoerr "No javascript executable found."
	return {} 
endfunction

function! s:writeLintOptionFile()

	if empty(s:jsl_options)
		"echo "s:writeLintOptionFile() no options"
		return "" 
	endif
	
	let l:jsl_str = ["var BBJSLINT_OPTS = {};"]
	for key in keys(s:jsl_options)
		"echo key.":".s:jsl_options[key]
		let l:jsl_str += ["BBJSLINT_OPTS['".key."'] = ".s:jsl_options[key].";"]
	endfor

	let l:fname = tempname().".js"
	call writefile(l:jsl_str, l:fname)

	"echo "option file ".l:fname
	return l:fname
endfunction

function! s:writeBeautyOptionFile()

"JSBEAUTYOPTS = {
"outfile:'outfilename',
"funcargs:[]
"}

	let l:fname = tempname().".js"

	let l:jsl_str = ["var JSBEAUTYOPTS = {};"]
	let l:jsl_str += ["JSBEAUTYOPTS['outfile'] = '".l:fname."';"]
	echo "Beauty is at".l:fname

	let l:fname = tempname().".js"
	call writefile(l:jsl_str, l:fname)

	"echo "option file ".l:fname
	return l:fname
endfunction

function! BellyButton#javascript#extra()

	let l:jslint = s:getJSExec()
"JSBEAUTYOPTS = {
"outfile:'outfilename',
"funcargs:[]
"}

	" Set up command and parameters
	let l:bbase = BellyButtonModuleBase()."Pretty-Diff/"
	if has("win32")
		let s:runjslint_ext = 'wsf'
	else
		let s:runjslint_ext = 'js'
	endif

	let l:opt_file = s:writeBeautyOptionFile()

	"echo l:opt_file
	let l:cmd = "cd " . l:bbase . " && " . l:jslint['exec']. " "
	if len(l:opt_file) > 0
		let l:cmd .= l:opt_file." "
	endif
	let l:cmd .= "runbeauty." . s:runjslint_ext

	echo l:cmd
	let l:jsbeauty_output = system(l:cmd, join(getline(1, '$'), "\n")."\n")

	if v:shell_error != 0 
		echoerr "Non zero return code from ".l:jslint['exec']
		echoerr l:jsbeauty_output
		return
	endif

	let l:blines = getline(1, '$')
	let l:nlines = split(l:jsbeauty_output, '\n')
	let lnum = 0
	while lnum < len(l:nlines)
		call setline(lnum+1, l:nlines[lnum] )
		let lnum = lnum + 1
	endwhile

	"let lnum = len(l:blines)
	"if lnum > len(l:nlines)
		"while lnum > len(l:nlines)
			"call setline(lnum, '' )
			"let lnum = lnum - 1
		"endwhile
	"endif

	return
endfunction

"function BellyButton#javascript#exec()
"endfunction

"function BellyButton#javascript#execParseError( e_line )
"endfunction

function! BellyButton#javascript#lintRaw()

	let l:jslint = s:getJSExec()

	""echo "Using jslint:" l:jslint
	let l:pre_arg = ""
	if '0' != "".get(l:jslint, 'pre_opt' )
		let l:pre_arg = l:jslint['pre_opt'] 
	endif

	" Set up command and parameters
	let l:bbase = BellyButtonModuleBase()."jslint/"
	if has("win32")
		let s:runjslint_ext = 'wsf'
	else
		let s:runjslint_ext = 'js'
	endif

	let l:opt_file = s:writeOptionFile()

	"echo l:opt_file
	let l:cmd = "cd " . l:bbase . " && " . l:jslint['exec']. " "
	if len(l:opt_file) > 0
		let l:cmd .= l:pre_arg.l:opt_file." "
	endif
	let l:cmd .= l:pre_arg."runjslint." . s:runjslint_ext

	"echo l:cmd
	let b:jslint_output = system(l:cmd, join(getline(1, '$'), "\n")."\n")
	if v:shell_error != 0 
		echoerr("Non zero return code from ".l:jslint['exec'])
		return ""
	endif
	"echo b:jslint_output
	return b:jslint_output
endfunction

function! BellyButton#javascript#parseLintError( e_line )
	"
	" Match {line}:{char}:{message}
	let b:parts = matchlist(a:e_line, "\\(\\d\\+\\):\\(\\d\\+\\):\\(.*\\)")
	if empty(b:parts) || len(b:parts) < 3
		return {}
	endif

	return { 'filename':expand('%'), 'lnum':b:parts[1], 'char':b:parts[2], 'errmsg':b:parts[3] }
endfunction

function! BellyButton#javascript#info()
	return {'lint':"Uses jslint to analyze code",
		\'extra':"Beutifier, uses the Pretty-Diff js-beutifier on the buffer",
		\'author':"Jeff Buttars",
		\'authro_email':"jeffbuttars@gmail.com",
		\'externals':["JSlint 2011-03-07 by Douglas Crockford http://www.jslint.com/",
		\"SpiderMonkey  http://www.mozilla.org/js/spidermonkey/",
		\"V8 http://code.google.com/p/v8/"],
		\'desc':"Checks your Javascript using the jslint tool from Douglas Crockford. Jslint itself
		\ is included with this plugin but you will need to have a Javascript interpreter
		\ installed on your system for this plugin to work. Currently only the Spidermonkey
		\ and V8 Javascript interpreters have been
		\ tested and used with this plugin. You only need to have one of them installed."}
endfunction

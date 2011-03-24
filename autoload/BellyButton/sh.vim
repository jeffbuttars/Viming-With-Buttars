
function! BellyButton#sh#init()

	if !exists('s:bbsh_initialized')
		let s:bbsh_initialized = 1
		" Add any additional 'firs time, one time' initializtion code here. 
	endif

	" put any code down here that you want to run every time the
	" #lintRaw, #exec, and #extra hooks are called, but right before they
	" are caled. This can be a good place to setup options for external
	" tools.
endfunction

function! BellyButton#sh#clean()
	" put any code down here that you want to run every time the
	" #lintRaw, #exec, and #extra hooks are called, but right _after_ they
	" are caled. This hook is generally not needed. But for those that
	" want or need it, it's available.
endfunction

function! BellyButton#sh#lintRaw()
	return system( "sh -n ".shellescape(expand('%')))
endfunction

function! BellyButton#sh#parseLintError( e_line )

	" test.sh: line 9: syntax error near unexpected token `newline'
	"'filename: line <line number>:  message'
	let l:eparts = matchlist( a:e_line, "^\\(.*\\)\:\ line \\(\\d\\+\\):\ \\(.*\\)" )
	if !empty(l:eparts) && len(l:eparts) > 2
		return { 'filename':l:eparts[1], 'lnum':l:eparts[2], 'errmsg':l:eparts[3] }
	endif
	return {} 
endfunction

function! BellyButton#sh#exec()
	" This is where you put the code to execute or possible make
	" the current buffer. If the #exec hook doesn't make sense for your
	" plugin, simple don't include it. If you implement the #exec hook
	" you'll need to return a Dictionary as the result. See the API
	" documentation BellyButton_filetype_exec for more details
	
	let l:sysout = system( "sh ".shellescape(expand('%')))
	return {'sysout':l:sysout, 
				\'ecode':v:shell_error, 
				\'good_ecode':0, 
				\'parse_error':1}
endfunction

function! BellyButton#sh#parseExecError( e_line )
	return BellyButton#sh#parseLintError( a:e_line )
endfunction

function! BellyButton#sh#extra()
	" Anything code you wish! See the API for further explanation of this
	" hook 
endfunction

function! BellyButton#sh#info()
	return {}
endfunction


function! BellyButton#css#load()
	let s:js_execs = [ {'exec':'d8'}, {'exec':'js','pre_opt':'-f '}]
endfunction

function! s:getJSExec()
	if exists('g:JSExecutable') && 
				\!empty(g:JSExecutable) && 
				\0 != get(g:JSExecutable, 'exec') && 
				\executable(g:JSExecutable['exec'])
		return g:JSExecutable
	endif

	if has("win32")
		return 'cscript /NoLogo '
	endif

	for ext in s:js_execs
		if executable(ext['exec'])
			return ext
		endif
	endfor

	echoerr "No css executable found."
	return {} 
endfunction

function! s:writeOptionFile()

	let l:fname = tempname().".js"

	let l:jsl_str = ["var CSSCLEANOPTS = {};"]


	if &expandtab
		let l:jsl_str += ["CSSCLEANOPTS['character'] = ' ';"]
		if 0 != &softtabstop
			let l:jsl_str += ["CSSCLEANOPTS['size'] = ".&softtabstop.";"]
		elseif 0 != &shiftwidth
			let l:jsl_str += ["CSSCLEANOPTS['size'] = ".&shiftwidth.";"]
		else
			let l:jsl_str += ["CSSCLEANOPTS['size'] = 8;"]
		endif
	else
		let l:jsl_str += ["CSSCLEANOPTS['character'] = '\t';"]
		let l:jsl_str += ["CSSCLEANOPTS['size'] = 1;"]
	end

	let l:jsl_str += ["CSSCLEANOPTS['comment'] = '';"]
	let l:jsl_str += ["CSSCLEANOPTS['alter'] = true;"]


	" echo "CSS clean is at".l:fname

	let l:fname = tempname().".js"
	call writefile(l:jsl_str, l:fname)

	"echo "option file ".l:fname
	return l:fname
endfunction

function! BellyButton#css#extra()

	let l:jsexec = s:getJSExec()

	" Set up command and parameters
	let l:bbase = BellyButtonModuleBase()."Pretty-Diff/"
	if has("win32")
		let s:runjsexec_ext = 'wsf'
	else
		let s:runjsexec_ext = 'js'
	endif

	let l:opt_file = s:writeOptionFile()

	"echo l:opt_file
	let l:cmd = "cd " . l:bbase . " && " . l:jsexec['exec']. " "
	if len(l:opt_file) > 0
		let l:cmd .= l:opt_file." "
	endif
	let l:cmd .= "runcleancss." . s:runjsexec_ext

	let l:cleanCSS_output = system(l:cmd, join(getline(1, '$'), "\n")."\n")

	if v:shell_error != 0 
		echo l:cleanCSS_output
		echo l:cmd
		echoerr "Non zero return code from ".l:jsexec['exec']
		return
	endif

	call BellyButtonBufferStr(l:cleanCSS_output)
endfunction

function! BellyButton#css#info()
		return { 'extra':"cleanCSS",
		\'author':"Jeff Buttars",
		\'authro_email':"jeffbuttars@gmail.com",
		\'externals':["cleanCSS from Pretty-Diff, http://prettydiff.com",
		\"SpiderMonkey  http://www.mozilla.org/js/spidermonkey/",
		\"V8 http://code.google.com/p/v8/"],
		\'desc':""}
endfunction

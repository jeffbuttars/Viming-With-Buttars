
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

function! s:JSLintClear()
  " Delete previous matches
  if exists('b:errors')
    for error in b:errors
      call matchdelete(error)
    endfor
  endif
endfunction

function! s:JSLint(args) range
  cclose " Close quickfix window
  cexpr [] " Create empty quickfix list

  " Detect range
  if a:firstline == a:lastline
    let b:firstline = 1
    let b:lastline = '$'
  else 
    let b:firstline = a:firstline
    let b:lastline = a:lastline
  endif

  " Delete previous matches
  if exists('b:errors')
    for error in b:errors
      call matchdelete(error)
    endfor
  endif

  " Set up command and parameters
  let s:plugin_path = '"' . expand("~/") . '"'
  if has("win32")
    let s:cmd = 'cscript /NoLogo '
    let s:plugin_path = s:plugin_path . "vimfiles"
    let s:runjslint_ext = 'wsf'
  else
    let s:cmd = 'js'
    let s:plugin_path = s:plugin_path . ".vim"
    let s:runjslint_ext = 'js'
  endif
  let s:plugin_path = s:plugin_path . "/plugin/jslint/"
  let s:cmd = "cd " . s:plugin_path . " && " . s:cmd . " " . s:plugin_path 
               \ . "runjslint." . s:runjslint_ext
  let b:jslint_output = system(s:cmd, join(getline(b:firstline, b:lastline), 
              \ "\n") . "\n")

  let b:errors = []
  let b:impliedGlobals = 0
  let b:has_errors = 0
  let b:error_under_cursor = 'No error on current line' "default
  "let b:global_err_list = []

  for error in split(b:jslint_output, "\n")

    " Match {line}:{char}:{message}
    let b:parts = matchlist(error, "\\(\\d\\+\\):\\(\\d\\+\\):\\(.*\\)")
    if !empty(b:parts)
      let l:line = b:parts[1] + (b:firstline - 1) " Get line relative to selection

	  " Implied global errors can be overwhelming. Let the user
	  " squash that error if they wish.
	  if g:JSLintIgnoreImpliedGlobals && b:parts[3] =~ '^Implied global'
			let b:impliedGlobals = 1
			"let b:parts[1] = l:line
			"call add(b:global_err_list, b:parts )
			continue
	  endif

      let b:has_errors = 1

      " Add line to match list
	  if g:JSLintHighlightErrorLine == 1
		  call add(b:errors, matchadd('Error', '\%' . l:line . 'l'))
	  endif

      " Store the error for an error under the cursor
      if l:line == line('.')
         let b:error_under_cursor = 'Line '. l:line .': '.b:parts[3]
      endif

      " Add to quickfix
      caddexpr expand("%") . ":" . l:line . ":" . b:parts[2] . ":" . b:parts[3]
    endif
  endfor

  if g:JSLintIgnoreImpliedGlobals && b:impliedGlobals
      "caddexpr expand("%") . ":0:0:" . "Implied global errors were found"
      echo "Implied global errors were found"
	  "for error in b:global_err_list
		  "caddexpr expand("%") . ":" . error[1] . ":" . error[2] . ":" . error[3]
	  "endfor
  endif

  " Open the quickfix window if errors are present
  if b:has_errors == 1
    if a:args == "qf"
      copen
    elseif a:args == "echo"
      echo b:error_under_cursor
    endif
  else
	cclose " Close quickfix window
    echo "JSLint: All good."
  endif
endfunction

" Highlight errors and echo error under cursor
command! -range JSLintLight <line1>,<line2>call s:JSLint("echo")
" Highlight errors and open quick fix window
command! -range JSLint <line1>,<line2>call s:JSLint("qf")
" Un Highlight errors
command! JSLintClear call s:JSLintClear()


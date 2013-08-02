
" Synxtax options
let python_highlight_builtins = 1
let python_highlight_builtin_objs = 1
let python_highlight_builtin_funcs = 1
let python_highlight_exceptions = 1
let python_highlight_string_formatting = 1
let python_highlight_string_format = 1
let python_highlight_string_templates = 1
let python_highlight_indent_errors = 1
let python_highlight_space_errors = 1
let python_highlight_doctests = 1
let python_highlight_all = 1
let python_slow_sync = 1
let python_print_as_function = 1

let g:ultisnips_python_style = 'rst'

" Python-mode options
" 
" Don't run lint on write, let Syntastic handle that 
let g:pymode_lint = 0
let g:pymode_lint_write = 0
" Turn off folding
" let g:pymode_folding = 0
" Enable some extra syntax highlighting
let g:pymode_syntax_print_as_function = 1

" Indent Python in the Google way.

setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

function! GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"


" If autopep8 is installed, map it to F5
" Syntastic handles this now
" let found_ap = system("which autopep8")
" if found_ap != ""
"     imap <F5> <ESC>:%!autopep8 -i %<CR>
"     nmap <F5> <ESC>:%!autopep8 -i %<CR>
" endif

" Our own foo
call SetColorColumn(99)

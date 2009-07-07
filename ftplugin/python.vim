
" Got this from
"http://freegnu.blogspot.com/2009/06/python-file-type-plugin-for-vim-part-1.html

function! PythonGrep(tool)
  set lazyredraw              
  " Close any existing cwindows.
  cclose                       
  let l:grepformat_save = &grepformat
  let l:grepprogram_save = &grepprg 
  set grepformat&vim                
  set grepformat&vim                
  let &grepformat = '%f:%l:%m'      
  if a:tool == "pylint"             
    "let &grepprg = 'pylint --output-format=parseable --reports=n --indent-string="        "'
    let &grepprg = 'pylint --output-format=parseable --reports=n --indent-string=""'
  elseif a:tool == "pychecker"                                                             
    let &grepprg = 'pychecker --quiet -q'                                                  
  elseif a:tool == "pyflakes"                                                              
    let &grepprg = 'pyflakes'                                                              
  else                                                                                     
    echohl WarningMsg                                                                      
    echo "PythonGrep Error: Unknown Tool"                                                  
    echohl none                                                                            
  endif                                                                                    
  if &readonly == 0 | update | endif                                                       
  silent! grep! %                                                                          
  let &grepformat = l:grepformat_save                                                      
  let &grepprg = l:grepprogram_save                                                        
  let l:mod_total = 0                                                                      
  let l:win_count = 1                                                                      
  " Determine correct window height                                                        
  windo let l:win_count = l:win_count + 1                                                  
  if l:win_count <= 2 | let l:win_count = 4 | endif                                        
  windo let l:mod_total = l:mod_total + winheight(0)/l:win_count |                         
        \ execute 'resize +'.l:mod_total                                                   
  " Open cwindow                                                                           
  execute 'belowright cw '.l:mod_total                                                     
  nnoremap   c :cclose                                                 
  set nolazyredraw                                                                         
  redraw!                                                                                  
endfunction

command! Pyflakes call PythonGrep('pyflakes')
command! PyFlakes call PythonGrep('pyflakes')
command! Pychecker call PythonGrep('pychecker')
command! PyChecker call PythonGrep('pychecker')
command! Pylint call PythonGrep('pylint')
command! PyLint call PythonGrep('pylint')

" These three are successively more informative and aggressive in their
" warnings with pyflakes as the least noisy. Only uncomment one.
"autocmd BufWrite *.{py} :Pyflakes
autocmd BufWrite *.{py} :Pychecker
"autocmd BufWrite *.{py} :Pylint

if !exists("g:NERDCustomDelimiters")
    let g:NERDCustomDelimiters = {}
endif
call extend(g:NERDCustomDelimiters, {'django': { 'left': '{#', 'right': '#}', 'leftAlt': '{%comment%}', 'rightAlt': '{%endcomment%}' }})

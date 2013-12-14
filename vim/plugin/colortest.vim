" Color test: Save this file, then enter ':so %'
" Then enter one of following commands:
"   :VimColorTest    "(for console/terminal Vim)
"   :GvimColorTest   "(for GUI gvim)
" Increase numbers in next line to see more colors.
"if exists( 't_Co' )
function! VimColorTest(outfile, tsize)
	let num = &t_Co
	let result = []
	while num > 0
		let num = num - 1

		if a:tsize == 'huge'
			let bnum = &t_Co
			while bnum > 0
				let bnum = bnum - 1
				let kw = printf('%-7s', printf('c_%d_%d', num, bnum ))
				let h = printf('hi %s ctermbg=%d ctermfg=%d', kw, num, bnum)
				let s = printf('syn keyword %s %s', kw, kw)
				call add(result, printf('%-32s | %s', h, s))
			endwhile
			continue
		endif

		let kw = printf('%-7s', printf('c_w_%d', num ))
		let h = printf('hi %s ctermbg=%d ctermfg=white', kw, num)
		let s = printf('syn keyword %s %s', kw, kw)
		call add(result, printf('%-32s | %s', h, s))

		if a:tsize == 'medium'
			let kw = printf('%-7s', printf('c_b_%d', num ))
			let h = printf('hi %s ctermbg=%d ctermfg=black', kw, num)
			let s = printf('syn keyword %s %s', kw, kw)
			call add(result, printf('%-32s | %s', h, s))
		endif
	endwhile
	call writefile(result, a:outfile)
	execute 'edit '.a:outfile
	source %
endfunction
command! VimColorTest call VimColorTest('vim-color-test.tmp', 'small')
command! VimColorTestBW call VimColorTest('vim-color-test.tmp', 'medium')
command! VimColorTestAll call VimColorTest('vim-color-test.tmp', 'huge')

function! GvimColorTest(outfile)
  let result = []
  for red in range(0, 255, 16)
    for green in range(0, 255, 16)
      for blue in range(0, 255, 16)
        let kw = printf('%-13s', printf('c_%d_%d_%d', red, green, blue))
        let fg = printf('#%02x%02x%02x', red, green, blue)
        let bg = '#fafafa'
        let h = printf('hi %s guifg=%s guibg=%s', kw, fg, bg)
        let s = printf('syn keyword %s %s', kw, kw)
        call add(result, printf('%s | %s', h, s))
      endfor
    endfor
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
command! GvimColorTest call GvimColorTest('gvim-color-test.tmp')

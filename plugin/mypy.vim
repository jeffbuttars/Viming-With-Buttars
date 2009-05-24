python << EOF
import vim,re
jumppos = []

def NJ_pushJump( rc, vcmd ):
    jumppos.append( { 'rc':rc, 'vcmd':vcmd } )

def NJ_jumpBack():

    if len(jumppos) == 0:
        return

    jitem = jumppos.pop()

    if jitem[ 'rc' ]:
        vim.current.window.cursor = jitem[ 'rc' ]
    if jitem[ 'vcmd' ]:
        vim.command( jitem[ 'vcmd' ] )

def NJ_prevWord( line ):

    if not line:
        return None

    res = line.rsplit( None, 1 )

    if res :
        #print "NJ_prevWord:%s" % res[0]
        return res[0]

    return None

def NJ_breakLine( line, pos ):

    l,c,r = None,None,None
    linea = line[:pos+1]
    lineb = line[pos+1:]

    if linea:
        l = line[pos].lstrip()
    if lineb:
        c = line[pos+1].lstrip()
    if len(lineb) > 1:
        r = line[pos+2].lstrip()

    return { 'l':l, 'c':c, 'r':r, 'linea':linea, 'lineb':lineb }

def NJ_quote( qc="\""):

    w = vim.current.window
    row = w.cursor[0]
    col = w.cursor[1]

    cline = vim.current.line
    bline = NJ_breakLine( cline, col )
    if not bline:
        return


#Insert '' on empty lines or when
# surrounded by space on both sides of the cursor.
# Otherwise, just one '
# XXX Perhaps in the futue, if were on the left side of word
# we'll quote that word.

    sstr = "%s" % qc
    coff = 2
    l = bline[ 'l' ]
    c = bline[ 'c' ]
    r = bline[ 'r' ]

    #print "%s%s%s" % ( l,c,r )
    slist = (')','}',']')


    # double up if not surrounded
    if (not l and not r):
        sstr = "%s%s" % (qc,qc)

    # BUT!, if right is special, insert a double with space
    # on the right.
    if r in slist  or c in slist:
        if not c:
            sstr = "%s%s" % (qc,qc)
        else:
            sstr = "%s%s " % (qc,qc)


    if l in ('(','{','['):
        coff = 3
        sstr = " %s%s" % (qc,qc)
        if c in slist and r:
            sstr = "%s " % (sstr)

    vim.current.line = "%s%s%s" % (bline['linea'], sstr, bline['lineb'])
    if len(cline) == 0:
        coff=1
    w.cursor = (row, col+coff)

    NJ_pushJump( (row,col+coff), "normal f%sl" % qc )

    return
#NJ_quote()

def  NJ_squote():
    return NJ_quote( "'" )
#NJ_squote()

def  NJ_dquote():
    return NJ_quote( "\"" )
#NJ_dquote()

def NJ_DoubleBrace():

    cline = vim.current.line
    w = vim.current.window
    col = w.cursor[1]
    row = w.cursor[0]
    xstr = " {"


    cline = vim.current.line
    if cline[len(cline)-1] is ' ':
        xstr = "{"

    vim.current.line = "%s%s" % (cline,xstr)

    b = vim.current.buffer
    b[row:row] = ["\t"]
    b[row+1:row+1] = ["}"]
    w.cursor = (row+1, 0)

def NJ_lparen( cstyle=True ):

    w = vim.current.window
    row = w.cursor[0]
    col = w.cursor[1]
    cline = vim.current.line

    if len(cline) == 0:
        vim.current.line = "%s()" % (cline)
        w.cursor = (row, col+3)
        return

    bline = NJ_breakLine( cline, col )

    clinea = bline[ 'linea' ]
    clineb = bline[ 'lineb' ]
    l = bline[ 'l' ]
    c = bline[ 'c' ]
    r = bline[ 'r' ]

    if not r:
        nline = "%s()%s" % (clinea, clineb)

        # If the right side is empty and we have a control
        # keyword, finish the block.
        pword = NJ_prevWord( cline )

        klist = ( 'if', 'while' )
        if cstyle and not ( clineb.lstrip() ) and pword in klist:
            vim.current.line = nline
            vim.command( "normal $a {" )

            #nline = "%s%s" % (nline, ' {' ) 
            b = vim.current.buffer
            b[row:row] = [""]
            w.cursor = (row+1,0)
            vim.command( "normal i}" )
            vim.command( "normal ==" )
            NJ_pushJump( (row,col), "normal o" )
            w.cursor = (row, col+2)
            return

        vim.current.line = nline
        w.cursor = (row, col+2)
        return 

    vim.current.line = "%s(%s" % (clinea, clineb)
    w.cursor = (row, col+2)

#NJ_lparen()
EOF



"autocmd FileType c,h,javascript,html,xhtml,shtml,php,vim imap ( <ESC>:python NJ_lparen()<CR>i
"autocmd FileType python imap ( <ESC>:python NJ_lparen( False )<CR>i

"autocmd FileType c,h,javascript,html,xhtml,shtml,python,php,vim imap ' <ESC>:python NJ_squote()<CR>i
"autocmd FileType c,h,javascript,html,xhtml,shtml,python,php imap " <ESC>:python NJ_dquote()<CR>i
"autocmd FileType c,h,js,javascript,html,xhtml,shtml,bash,php imap <silent> {{ <ESC>:call NJ_DoubleBrace()<CR>
"autocmd FileType c,h,js,javascript,html,xhtml,shtml,css,bash,php,python imap {{ <END>{<esc>o}<esc>
"autocmd FileType c,h,javascript,html,xhtml,shtml,bash,python,php imap  [[ []


autocmd FileType c,h,javascript,html,xhtml,shtml,bash,php,css nmap ;; <INSERT><END>;<ESC>:w<CR>
autocmd FileType c,h,javascript,html,xhtml,shtml,bash,php,css imap ;; <END>;<ESC>:w<CR>
autocmd FileType c,h,javascript,html,xhtml,shtml,bash,php,css nmap ;; <INSERT><END>;<ESC>:w<CR>
autocmd FileType c,h,javascript,html,xhtml,shtml,bash,php,css imap ;; <END>;<ESC>:w<CR>

" Run current file with python
autocmd FileType python map <F5> <ESC>:w<CR>:!python %<CR>
autocmd FileType python nmap :: <INSERT><END>:<ESC>:w<CR>
autocmd FileType python imap :: <END>:<ESC>:w<CR>
"autocmd FileType python inoremap else else<SPACE>:<esc>o



autocmd FileType c,h,javascript,html,xhtml,shtml,python,php,vim imap <C-j> <ESC>:python NJ_jumpBack()<CR>i


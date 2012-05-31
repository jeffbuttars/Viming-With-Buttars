
if exists("b:current_syntax")
    finish
endif

" keywords
syn keyword syntaxElementKeyword LEFT RIGHT UNSIGNED INTEGER
syn match eclType '\<UNSIGNED\d*\>\c'
syn match eclType '\<INTEGER\d*\>\c'
syn match eclType '\<Q\?STRING\d*\>\c'
syn match eclType '\<RECORD\c'
syn match eclType '\<DATASET\>\c'

syn match eclConstant '\<LEFT\>\c'
syn match eclConstant '\<RIGHT\>\c'
syn match eclBoolean '\<TRUE\>\c'
syn match eclBoolean '\<FALSE\>\c'

syn match eclFunction '\<XML\>\c'
syn match eclFunction '\<XMLTEXT\>\c'
syn match eclFunction '\<NORMALIZE\>\c'
syn match eclFunction '\<PARSE\>\c'
syn match eclFunction '\<OUTPUT\>\c'

syn match eclRepeat '\<TRANSFORM\>\c'
syn match eclRepeat '\<XMLPROJECT\>\c'

syntax match eclStatement '\<SELF\>\c'

syntax match eclDefine '\<EXPORT\>\c'

syntax match eclIdent '\<end\>\s*;\c'
" syn region eclTransformBlock start="\<tranform\>\c"	end="\<end\>" contains=ALLBUT,@rubyNotTop fold

syn match	eclImport   display "^\s*IMPORT\s\+\a\w*\c"
syn match	eclImport   display "MODULE\c"

syn match	eclOperator   display "\<+\>\c"

syntax region eclComment start="/\*" end="\*/"
syntax region eclString start="'" end="'"

hi def link eclCommentL		eclComment
hi def link eclCommentStart	eclComment
hi def link eclBoolean		Boolean
hi def link eclLabel		Label
hi def link eclUserLabel		Label
hi def link eclConditional	Conditional
hi def link eclFunction     Function	
hi def link eclRepeat		Repeat
hi def link eclCharacter		Character
hi def link eclSpecialCharacter	SpecialChar
hi def link eclNumber		Number
hi def link eclOctal		Number
hi def link eclOctalZero		PreProc	 " link this to Error if you want
hi def link eclFloat		Float
hi def link eclOctalError		eclError
hi def link eclParenError		eclError
hi def link eclErrInParen		eclError
hi def link eclErrInBracket	eclError
hi def link eclCommentError	eclError
hi def link eclCommentStartError	eclError
hi def link eclSpaceError		eclError
hi def link eclSpecialError	    eclError
hi def link eclCurlyError		eclError
hi def link eclOperator		Operator
hi def link eclStructure		Structure
hi def link eclStorageClass	StorageClass
hi def link eclImport		Include
hi def link eclPreProc		PreProc
hi def link eclDefine	    Define
" hi def link eclDefine		Macro
" hi def link eclIncluded		cString
hi def link eclError		Error
hi def link eclStatement		Statement
hi def link eclCppInWrapper	eclCppOutWrapper
hi def link eclCppOutWrapper	eclPreCondit
hi def link eclPreConditMatch	eclPreCondit
hi def link eclPreCondit		PreCondit
hi def link eclType		Type
hi def link eclConstant		Constant
hi def link eclString		String
hi def link eclComment		Comment
hi def link eclSpecial		Special
hi def link eclTodo		Todo
hi def link eclBadContinuation	Error
hi def link eclIdent Identifier

let b:current_syntax = "ecl"

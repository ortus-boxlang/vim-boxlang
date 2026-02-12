" Vim syntax file
"
" Language:     BoxLang (Template)
" Maintainer:   Ortus Solutions <info@ortussolutions.com>
" URL:          https://github.com/ortus-solutions/vim-boxlang
" Last Change:  2026 Feb 12
" License:      Apache 2.0
"
" Filenames:    *.bxm
" Description:  Syntax highlighting for BoxLang template files (.bxm)
"               Supports bx: tags, HTML markup, and embedded script blocks

" Quit when a syntax file was already loaded.
if exists("b:current_syntax")
  finish
endif

" Using line continuation here.
let s:cpo_save=&cpo
set cpo&vim

" BoxLang templates are case-insensitive
syn case ignore

" Include HTML syntax for markup (but we'll override for BoxLang constructs)
runtime! syntax/html.vim
unlet! b:current_syntax

" Set higher priority for BoxLang syntax
syn cluster htmlTop add=boxlangTemplateComment,boxlangTagStart,boxlangTagEnd,boxlangExpression,boxlangScriptBlock

" TEMPLATE COMMENTS {{{
" BoxLang template comments: <!--- ... --->
syn region boxlangTemplateComment start="<!---" end="--->" contains=boxlangTemplateComment,boxlangTodo fold

" Todo markers in comments
syn keyword boxlangTodo contained TODO FIXME XXX NOTE HACK
" / TEMPLATE COMMENTS }}}

" EXPRESSION INTERPOLATION {{{
" Hash-delimited expressions in template text and HTML content
" Syntax: #expression#
" Non-contained version for use anywhere in template (including HTML text)
syn region boxlangExpression matchgroup=boxlangExpressionDelim start="#" end="#" skip="##" contains=boxlangIdentifier,boxlangNumber,boxlangOperator,boxlangFunction,boxlangScope,boxlangDot,boxlangKeyword,boxlangBoolean,boxlangNull

" Escaped hash mark (appears as literal ##)
syn match boxlangEscapedHash "##"
" / EXPRESSION INTERPOLATION }}}

" BX: TAGS {{{
" Tag bracket delimiters
syn match boxlangTagBracket contained "[<>/]"

" Tag name (bx:tagname)
syn match boxlangTagName contained "\<bx:\w\+\>"

" Self-closing tag indicator
syn match boxlangTagSlash contained "/>"

" Tag attribute name
syn match boxlangAttrName contained "\<\w\+\ze\s*="

" Tag attribute value
syn region boxlangAttrValue contained start=+"+ skip=+""+ end=+"+ contains=boxlangExpression
syn region boxlangAttrValue contained start=+'+ skip=+''+ end=+'+ contains=boxlangExpression

" Tag start region
" Matches: <bx:tagname attr="value">
syn region boxlangTagStart transparent start="<bx:\w\+" end=">" contains=boxlangTagBracket,boxlangTagName,boxlangAttrName,boxlangAttrValue,boxlangTemplateComment keepend

" Tag end
" Matches: </bx:tagname>
syn match boxlangTagEnd transparent "</bx:\w\+>" contains=boxlangTagBracket,boxlangTagName

" Common bx: tags
syn keyword boxlangTag contained if elseif else output set function argument return
syn keyword boxlangTag contained try catch finally throw rethrow
syn keyword boxlangTag contained for while break continue switch case defaultcase
syn keyword boxlangTag contained include import property component interface
syn keyword boxlangTag contained script abort exit lock thread transaction param
" / BX: TAGS }}}

" TAG REGIONS AND FOLDING {{{
" <bx:if> ... </bx:if>
syn region boxlangIfRegion transparent fold start="<bx:if\>" end="</bx:if>" contains=ALL

" <bx:output> ... </bx:output>
syn region boxlangOutputRegion transparent fold start="<bx:output\>" end="</bx:output>" contains=ALL

" <bx:function> ... </bx:function>
syn region boxlangFunctionRegion transparent fold start="<bx:function\>" end="</bx:function>" contains=ALL

" <bx:try> ... </bx:try>
syn region boxlangTryRegion transparent fold start="<bx:try\>" end="</bx:try>" contains=ALL

" <bx:for> ... </bx:for>
syn region boxlangForRegion transparent fold start="<bx:for\>" end="</bx:for>" contains=ALL

" <bx:while> ... </bx:while>
syn region boxlangWhileRegion transparent fold start="<bx:while\>" end="</bx:while>" contains=ALL

" <bx:switch> ... </bx:switch>
syn region boxlangSwitchRegion transparent fold start="<bx:switch\>" end="</bx:switch>" contains=ALL

" <bx:component> ... </bx:component>
syn region boxlangComponentRegion transparent fold start="<bx:component\>" end="</bx:component>" contains=ALL

" <bx:interface> ... </bx:interface>
syn region boxlangInterfaceRegion transparent fold start="<bx:interface\>" end="</bx:interface>" contains=ALL

" <bx:lock> ... </bx:lock>
syn region boxlangLockRegion transparent fold start="<bx:lock\>" end="</bx:lock>" contains=ALL

" <bx:thread> ... </bx:thread>
syn region boxlangThreadRegion transparent fold start="<bx:thread\>" end="</bx:thread>" contains=ALL

" <bx:transaction> ... </bx:transaction>
syn region boxlangTransactionRegion transparent fold start="<bx:transaction\>" end="</bx:transaction>" contains=ALL
" / TAG REGIONS }}}

" SCRIPT BLOCKS {{{
" <bx:script> embedded script content
" Include BoxLang script syntax within <bx:script> tags
" Guard against infinite recursion when including script syntax
if !exists("b:boxlang_include_depth")
  let b:boxlang_include_depth = 0
endif

if b:boxlang_include_depth < 1
  let b:boxlang_include_depth += 1
  syn include @boxlangScript syntax/boxlang.vim
  unlet! b:current_syntax
  let b:boxlang_include_depth -= 1

  syn region boxlangScriptBlock matchgroup=boxlangTagName start="<bx:script>" end="</bx:script>" contains=@boxlangScript,boxlangTemplateComment fold keepend
endif
" / SCRIPT BLOCKS }}}

" BASIC SYNTAX ELEMENTS FOR EXPRESSIONS {{{
" These are used within interpolated expressions
syn keyword boxlangBoolean contained true false
syn keyword boxlangNull contained null

" Numbers
syn match boxlangNumber contained "\<\d\+\>"
syn match boxlangNumber contained "\<\d\+\.\d\+\>"
syn match boxlangNumber contained "\<0[xX]\x\+\>"

" Operators
syn match boxlangOperator contained "\V+\|-\|*\|/\|%\|&\||\|!\|=\|<\|>\|?"
syn match boxlangDot contained "\."

" Keywords
syn keyword boxlangKeyword contained and or not xor eq neq gt lt gte lte is
syn keyword boxlangKeyword contained mod new

" Keywords that conflict with vim syntax arguments
syn match boxlangKeyword contained "\<contains\>"

" Scopes (all BoxLang variable scopes)
" Core function/class scopes
syn keyword boxlangScope contained variables local arguments this static super
" Persistence scopes
syn keyword boxlangScope contained application session request server
" Web-specific scopes
syn keyword boxlangScope contained cgi form url cookie client
" Thread scopes
syn keyword boxlangScope contained thread bxThread
" Special scopes
syn keyword boxlangScope contained bxFile bxHttp attributes caller cfcatch

" Function calls
syn match boxlangFunction contained "\<\w\+\ze\s*("

" Identifiers
syn match boxlangIdentifier contained "\<\w\+\>"
" / BASIC SYNTAX }}}

" HIGHLIGHTING LINKS {{{
" Template comments
hi def link boxlangTemplateComment Comment
hi def link boxlangTodo Todo

" Expression interpolation
hi def link boxlangExpression PreProc
hi def link boxlangExpressionDelim Delimiter
hi def link boxlangEscapedHash SpecialChar

" Tags
hi def link boxlangTagName Function
hi def link boxlangTagBracket Delimiter
hi def link boxlangTagSlash Delimiter
hi def link boxlangAttrName Type
hi def link boxlangAttrValue String
hi def link boxlangTag Keyword

" Basic syntax elements (for expressions)
hi def link boxlangBoolean Boolean
hi def link boxlangNull Constant
hi def link boxlangNumber Number
hi def link boxlangOperator Operator
hi def link boxlangDot Operator
hi def link boxlangKeyword Keyword
hi def link boxlangScope Identifier
hi def link boxlangFunction Function
hi def link boxlangIdentifier Identifier
" / HIGHLIGHTING }}}

let b:current_syntax = "boxlangTemplate"

let &cpo = s:cpo_save
unlet s:cpo_save

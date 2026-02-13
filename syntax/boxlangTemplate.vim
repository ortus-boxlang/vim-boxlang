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
"               no html.vim inclusion for performance

" Quit when a syntax file was already loaded.
if exists("b:current_syntax")
  finish
endif

" Using line continuation here.
let s:cpo_save=&cpo
set cpo&vim

" BoxLang templates are case-insensitive
syn case ignore

" Include BoxLang script syntax for use in expressions and script blocks
" Guard against infinite recursion
if !exists("b:boxlang_include_depth")
  let b:boxlang_include_depth = 0
endif

if b:boxlang_include_depth < 1
  let b:boxlang_include_depth += 1
  syn include @boxlangScript syntax/boxlang.vim
  unlet! b:current_syntax
  let b:boxlang_include_depth -= 1
endif

" Don't include HTML syntax - it causes conflicts and performance issues
syn sync fromstart

" TEMPLATE COMMENTS {{{
" BoxLang template comments: <!--- ... --->
syn region boxlangTemplateComment start="<!---" end="--->" contains=boxlangTodo fold

" Todo markers in comments
syn keyword boxlangTodo contained TODO FIXME XXX NOTE HACK
" / TEMPLATE COMMENTS }}}

" EXPRESSION INTERPOLATION {{{
" Hash-delimited expressions in template text (#variable.name#)
" Use @boxlangScript cluster for all expression syntax
syn region boxlangExpression matchgroup=boxlangExpressionDelim start="#" end="#" skip="##" keepend oneline contains=@boxlangScript

" Escaped hash mark (##)
syn match boxlangEscapedHash "##"
" / EXPRESSION INTERPOLATION }}}

" BX: TAGS {{{
" simple transparent regions with contained matches

" Tag start region: <bx:tagname attr="value">
syn region boxlangTagStart keepend transparent start="\c<bx:\w\+" end=">" contains=boxlangTagBracket,boxlangTagName,boxlangAttrName,boxlangAttrValue,boxlangExpression,boxlangTemplateComment

" Tag end: </bx:tagname>
syn match boxlangTagEnd transparent "\c</bx:\w\+>" contains=boxlangTagBracket,boxlangTagName

" Tag brackets: < > /
syn match boxlangTagBracket contained "[<>/]"

" Tag name: bx:tagname
" Use \zs to start match after < and /
syn match boxlangTagName contained "\v<\/*\zs\cbx:\w+"

" Self-closing tag indicator
syn match boxlangTagSlash contained "/>"

" Tag attribute name
syn match boxlangAttrName contained "\<\w\+\ze\s*="

" Tag attribute value (can contain expressions)
syn region boxlangAttrValue contained start=+"+ skip=+""+ end=+"+ contains=boxlangExpression
syn region boxlangAttrValue contained start=+'+ skip=+''+ end=+'+ contains=boxlangExpression
" / BOX: TAGS }}}

" HTML TAGS {{{
" Basic HTML tag highlighting (different from bx: tags)

" HTML Tag Name - generic word
syn match boxlangHtmlTagName contained "\v<\/*\zs\w+"

" HTML Special Tag Names (Doctype handled separately)
syn match boxlangHtmlSpecialTagName contained "\v<\/*\zs(html|head|body|style|script|link)\c"

" HTML Doctype
syn match boxlangHtmlDoctype "\c<!DOCTYPE\_[^>]*>"

" HTML Tag Start: matches <tag ... > but not <bx: ... >
" Uses negative lookahead for bx:
syn region boxlangHtmlTagStart keepend transparent start="\c<\(bx:\)\@!\w\+" end=">" contains=boxlangTagBracket,boxlangHtmlSpecialTagName,boxlangHtmlTagName,boxlangAttrName,boxlangAttrValue,boxlangExpression,boxlangTemplateComment

" HTML Tag End: matches </tag> but not </bx: ... >
syn match boxlangHtmlTagEnd transparent "\c</\(bx:\)\@!\w\+>" contains=boxlangTagBracket,boxlangHtmlSpecialTagName,boxlangHtmlTagName

" HTML Comments <!-- ... -->
" Use negative lookahead to avoid matching BoxLang comments <!--- ... --->
syn region boxlangHtmlComment start="<!--\(-\)\@!" end="-->" contains=boxlangTodo
" / HTML TAGS }}}

" TAG REGIONS FOR FOLDING {{{
" These define foldable regions for common block tags
" Define a cluster of what can be in template content
syn cluster boxlangTemplateContent contains=boxlangTemplateComment,boxlangExpression,boxlangTagStart,boxlangTagEnd,boxlangHtmlTagStart,boxlangHtmlTagEnd,boxlangHtmlComment,boxlangHtmlDoctype

" <bx:if> ... </bx:if>
syn region boxlangIfRegion transparent fold start="\c<bx:if\>" end="\c</bx:if>" contains=@boxlangTemplateContent,boxlangIfRegion,boxlangOutputRegion,boxlangForRegion,boxlangWhileRegion,boxlangSwitchRegion,boxlangTryRegion

" <bx:output> ... </bx:output>
syn region boxlangOutputRegion transparent fold start="\c<bx:output\>" end="\c</bx:output>" contains=@boxlangTemplateContent,boxlangIfRegion,boxlangForRegion,boxlangWhileRegion

" <bx:function> ... </bx:function>
syn region boxlangFunctionRegion transparent fold start="\c<bx:function\>" end="\c</bx:function>" contains=@boxlangTemplateContent,boxlangIfRegion,boxlangOutputRegion,boxlangForRegion,boxlangWhileRegion,boxlangTryRegion

" <bx:try> ... </bx:try>
syn region boxlangTryRegion transparent fold start="\c<bx:try\>" end="\c</bx:try>" contains=@boxlangTemplateContent,boxlangIfRegion,boxlangOutputRegion,boxlangForRegion

" <bx:for> ... </bx:for>
syn region boxlangForRegion transparent fold start="\c<bx:for\>" end="\c</bx:for>" contains=@boxlangTemplateContent,boxlangIfRegion,boxlangOutputRegion,boxlangForRegion

" <bx:while> ... </bx:while>
syn region boxlangWhileRegion transparent fold start="\c<bx:while\>" end="\c</bx:while>" contains=@boxlangTemplateContent,boxlangIfRegion,boxlangOutputRegion

" <bx:switch> ... </bx:switch>
syn region boxlangSwitchRegion transparent fold start="\c<bx:switch\>" end="\c</bx:switch>" contains=@boxlangTemplateContent

" <bx:component> ... </bx:component>
syn region boxlangComponentRegion transparent fold start="\c<bx:component\>" end="\c</bx:component>" contains=@boxlangTemplateContent,boxlangFunctionRegion

" <bx:interface> ... </bx:interface>
syn region boxlangInterfaceRegion transparent fold start="\c<bx:interface\>" end="\c</bx:interface>" contains=@boxlangTemplateContent,boxlangFunctionRegion

" <bx:lock> ... </bx:lock>
syn region boxlangLockRegion transparent fold start="\c<bx:lock\>" end="\c</bx:lock>" contains=@boxlangTemplateContent,boxlangIfRegion,boxlangOutputRegion

" <bx:thread> ... </bx:thread>
syn region boxlangThreadRegion transparent fold start="\c<bx:thread\>" end="\c</bx:thread>" contains=@boxlangTemplateContent,boxlangIfRegion,boxlangOutputRegion
" / TAG REGIONS }}}

" SCRIPT BLOCKS {{{
" <bx:script> embedded script content
syn region boxlangScriptBlock matchgroup=boxlangTagName start="\c<bx:script\>" end="\c</bx:script>" contains=@boxlangScript,boxlangTemplateComment fold keepend
" / SCRIPT BLOCKS }}}

" NOTE: HTML tags are not highlighted
" no HTML matching to avoid conflicts and performance issues
" BoxLang tags (bx:*) and expressions (#..#) are the focus of this syntax file

" HIGHLIGHTING LINKS {{{
" Template comments
hi def link boxlangTemplateComment Comment
hi def link boxlangTodo Todo
hi def link boxlangHtmlComment Comment

" Expression interpolation
hi def link boxlangExpression PreProc
hi def link boxlangExpressionDelim Delimiter
hi def link boxlangEscapedHash SpecialChar

" Tags
hi def link boxlangTagName Identifier
hi def link boxlangHtmlTagName Function
hi def link boxlangHtmlSpecialTagName Structure
hi def link boxlangHtmlDoctype PreProc
hi def link boxlangTagBracket Delimiter
hi def link boxlangTagSlash Delimiter
hi def link boxlangAttrName Type
hi def link boxlangAttrValue String
" / HIGHLIGHTING }}}

let b:current_syntax = "boxlangTemplate"

let &cpo = s:cpo_save
unlet s:cpo_save

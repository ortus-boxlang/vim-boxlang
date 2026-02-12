" Vim syntax file
"
" Language:     BoxLang (Script)
" Maintainer:   Ortus Solutions <info@ortussolutions.com>
" URL:          https://github.com/ortus-solutions/vim-boxlang
" Last Change:  2026 Feb 12
" License:      Apache 2.0
"
" Filenames:    *.bx *.bxs
" Description:  Syntax highlighting for BoxLang script files (.bx, .bxs)
"               Supports component islands (template blocks embedded in script)

" Quit when a syntax file was already loaded.
if exists("b:current_syntax")
  finish
endif

" Using line continuation here.
let s:cpo_save=&cpo
set cpo&vim

" BoxLang is case-insensitive
syn case ignore

" Sync from start for accuracy
syn sync fromstart

" KEYWORDS {{{
" Core control flow and declarations
syn keyword boxlangKeyword abort abstract as assert break case castas catch
syn keyword boxlangKeyword continue default do does else
syn keyword boxlangKeyword finally for function if import in include
syn keyword boxlangKeyword interface new param package private property
syn keyword boxlangKeyword public remote required rethrow return static
syn keyword boxlangKeyword switch throw to transaction try var when while
syn keyword boxlangKeyword class final exit lock thread

" Keywords that conflict with vim syntax arguments (use match instead)
syn match boxlangKeyword "\<contain\>"
syn match boxlangKeyword "\<contains\>"

" Modifiers and visibility
syn keyword boxlangModifier public private remote package static abstract final

" Types and special values
syn keyword boxlangType any array binary boolean component date function
syn keyword boxlangType guid numeric posdate query string struct uuid void xml

syn keyword boxlangBoolean true false
syn keyword boxlangNull null
" / KEYWORDS }}}

" OPERATORS {{{
" Arithmetic operators
syn match boxlangOperator "\v\+"
syn match boxlangOperator "\v-"
syn match boxlangOperator "\v\*"
syn match boxlangOperator "\v/"
syn match boxlangOperator "\v\%"
syn match boxlangOperator "\v\^"
syn match boxlangOperator "\v\\"

" Comparison operators
syn match boxlangOperator "\v\="
syn match boxlangOperator "\v\=\="
syn match boxlangOperator "\v\!\="
syn match boxlangOperator "\v\<\>"
syn match boxlangOperator "\v\>"
syn match boxlangOperator "\v\<"
syn match boxlangOperator "\v\>\="
syn match boxlangOperator "\v\<\="

" Strict equality (BoxLang-specific)
syn match boxlangOperator "\v\=\=\="
syn match boxlangOperator "\v\!\=\="

" Logical operators
syn keyword boxlangOperator and or not xor eqv imp
syn match boxlangOperator "\v\&\&"
syn match boxlangOperator "\v\|\|"
syn match boxlangOperator "\v\!"

" Elvis and ternary
syn match boxlangOperator "\v\?\:"
syn match boxlangOperator "\v\?"

" Bitwise operators (BoxLang-specific)
syn match boxlangBitwiseOp "\vb\|"
syn match boxlangBitwiseOp "\vb\&"
syn match boxlangBitwiseOp "\vb\^"
syn match boxlangBitwiseOp "\vb\~"
syn match boxlangBitwiseOp "\vb\<\<"
syn match boxlangBitwiseOp "\vb\>\>"
syn match boxlangBitwiseOp "\vb\>\>\>"

" Special operators
syn keyword boxlangOperator eq equal neq gt greater than lt less gte lte
syn keyword boxlangOperator is instanceof mod

" Arrows and special symbols
syn match boxlangArrow "\v-\>"
syn match boxlangArrow "\v\=\>"
syn match boxlangOperator "\v\:\:"
syn match boxlangOperator "\v\&"

" Increment/Decrement
syn match boxlangOperator "\v\+\+"
syn match boxlangOperator "\v--"
syn match boxlangOperator "\v\+\="
syn match boxlangOperator "\v-\="
syn match boxlangOperator "\v\*\="
syn match boxlangOperator "\v/\="
syn match boxlangOperator "\v\%\="
syn match boxlangOperator "\v\&\="
" / OPERATORS }}}

" COMMENTS {{{
" Single-line comment
syn match boxlangLineComment "//.*$"

" Multi-line comment
syn region boxlangBlockComment start="/\*" end="\*/" contains=boxlangTodo

" JavaDoc-style comment
syn region boxlangDocComment start="/\*\*" end="\*/" contains=boxlangTodo,boxlangDocTag

" Documentation tags
syn match boxlangDocTag contained "@\w\+\>" nextgroup=boxlangDocParam skipwhite
syn match boxlangDocParam contained "\S\+"

" Template comment (for embedded template islands)
syn region boxlangTemplateComment start="<!---" end="--->" contains=boxlangTemplateComment

" Todo markers
syn keyword boxlangTodo contained TODO FIXME XXX NOTE HACK
" / COMMENTS }}}

" STRINGS AND INTERPOLATION {{{
" String interpolation expression
syn region boxlangInterpolation contained matchgroup=boxlangInterpolationDelim start="#" end="#" skip="##" contains=boxlangIdentifier,boxlangNumber,boxlangOperator,boxlangFunction

" Single-quoted string
syn region boxlangStringSingle matchgroup=boxlangStringDelim start=+'+ skip=+''+ end=+'+ contains=boxlangInterpolation

" Double-quoted string
syn region boxlangStringDouble matchgroup=boxlangStringDelim start=+"+ skip=+""+ end=+"+ contains=boxlangInterpolation

" Escaped hash mark
syn match boxlangEscapedHash "##"
" / STRINGS }}}

" NUMBERS {{{
" Hexadecimal
syn match boxlangNumber "\<0[xX]\x\+\>"

" Scientific notation
syn match boxlangNumber "\<\d\+\(\.\d\+\)\?[eE][-+]\?\d\+\>"

" Floating point
syn match boxlangNumber "\<\d\+\.\d\+\>"

" Integer
syn match boxlangNumber "\<\d\+\>"
" / NUMBERS }}}

" FUNCTIONS {{{
" Function definition
syn keyword boxlangFunctionKeyword function nextgroup=boxlangFunctionName skipwhite

" Function name in definition
syn match boxlangFunctionName contained "\w\+" nextgroup=boxlangFunctionParams skipwhite

" Function call
syn match boxlangFunction "\<\w\+\ze\s*("

" Arrow function
syn match boxlangArrowFunction "=>\|=>"

" Lambda function
syn match boxlangLambdaFunction "->"
" / FUNCTIONS }}}

" ANNOTATIONS {{{
" Annotation with parameters
syn region boxlangAnnotation start="@\w\+\s*(" end=")" contains=boxlangAnnotationName,boxlangString,boxlangNumber,boxlangAnnotationKey,boxlangOperator
syn match boxlangAnnotationName contained "@\w\+"
syn match boxlangAnnotationKey contained "\w\+\s*="

" Simple annotation
syn match boxlangAnnotationSimple "@\w\+"
" / ANNOTATIONS }}}

" COMPONENT ISLANDS {{{
" Triple backtick template blocks embedded in script
" Syntax: ```<template>...</template>```
" Guard against infinite recursion when including template syntax
if !exists("b:boxlang_include_depth")
  let b:boxlang_include_depth = 0
endif

if b:boxlang_include_depth < 1
  let b:boxlang_include_depth += 1
  syn include @boxlangTemplateIsland syntax/boxlang-template.vim
  unlet! b:current_syntax
  let b:boxlang_include_depth -= 1

  syn region boxlangComponentIsland matchgroup=boxlangIslandDelim start="```" end="```" contains=@boxlangTemplateIsland keepend
endif
" / COMPONENT ISLANDS }}}

" BRACKETS AND BRACES {{{
syn match boxlangBracket "[\[\]]"
syn match boxlangBrace "[{}]"
syn match boxlangParen "[()]"
" / BRACKETS }}}

" PUNCTUATION {{{
syn match boxlangComma ","
syn match boxlangSemicolon ";"
syn match boxlangDot "\."
syn match boxlangColon ":"
" / PUNCTUATION }}}

" IDENTIFIERS {{{
syn match boxlangIdentifier "\<\w\+\>"
" / IDENTIFIERS }}}

" SCOPES {{{
" Core function/class scopes
syn keyword boxlangScope variables local arguments this static super
" Persistence scopes
syn keyword boxlangScope application session request server
" Web-specific scopes
syn keyword boxlangScope cgi form url cookie client
" Thread scopes
syn keyword boxlangScope thread bxThread
" Special scopes
syn keyword boxlangScope bxFile bxHttp attributes caller cfcatch
" / SCOPES }}}

" SPECIAL CONSTRUCTS {{{
" Import statement
syn keyword boxlangImport import nextgroup=boxlangPackage skipwhite
syn match boxlangPackage contained "\S\+"

" Package statement
syn keyword boxlangPackageKeyword package nextgroup=boxlangPackageName skipwhite
syn match boxlangPackageName contained "\S\+"

" New operator
syn keyword boxlangNew new

" Param statement
syn keyword boxlangParam param

" Include statement
syn keyword boxlangInclude include
" / SPECIAL CONSTRUCTS }}}

" REGIONS AND FOLDING {{{
" Class/Component definition folding
syn region boxlangClassRegion start="\<class\>" end="}" transparent fold

" Interface definition folding
syn region boxlangInterfaceRegion start="\<interface\>" end="}" transparent fold

" Function definition folding
syn region boxlangFunctionRegion start="\<function\>" end="}" transparent fold contains=ALL

" Control structure folding
syn region boxlangIfRegion start="\<if\>" end="}" transparent fold contains=ALL
syn region boxlangForRegion start="\<for\>" end="}" transparent fold contains=ALL
syn region boxlangWhileRegion start="\<while\>" end="}" transparent fold contains=ALL
syn region boxlangSwitchRegion start="\<switch\>" end="}" transparent fold contains=ALL
syn region boxlangTryRegion start="\<try\>" end="}" transparent fold contains=ALL
" / REGIONS }}}

" HIGHLIGHTING LINKS {{{
" Keywords and control flow
hi def link boxlangKeyword Keyword
hi def link boxlangModifier StorageClass
hi def link boxlangType Type
hi def link boxlangBoolean Boolean
hi def link boxlangNull Constant

" Operators
hi def link boxlangOperator Operator
hi def link boxlangBitwiseOp Special
hi def link boxlangArrow Special

" Comments
hi def link boxlangLineComment Comment
hi def link boxlangBlockComment Comment
hi def link boxlangDocComment SpecialComment
hi def link boxlangTemplateComment Comment
hi def link boxlangDocTag SpecialComment
hi def link boxlangDocParam Identifier
hi def link boxlangTodo Todo

" Strings
hi def link boxlangStringSingle String
hi def link boxlangStringDouble String
hi def link boxlangStringDelim Delimiter
hi def link boxlangInterpolation PreProc
hi def link boxlangInterpolationDelim Delimiter
hi def link boxlangEscapedHash SpecialChar

" Numbers
hi def link boxlangNumber Number

" Functions
hi def link boxlangFunctionKeyword Keyword
hi def link boxlangFunctionName Function
hi def link boxlangFunction Function
hi def link boxlangArrowFunction Special
hi def link boxlangLambdaFunction Special

" Annotations
hi def link boxlangAnnotation PreProc
hi def link boxlangAnnotationName PreProc
hi def link boxlangAnnotationKey Identifier
hi def link boxlangAnnotationSimple PreProc

" Component Islands
hi def link boxlangIslandDelim Special

" Brackets and punctuation
hi def link boxlangBracket Delimiter
hi def link boxlangBrace Delimiter
hi def link boxlangParen Delimiter
hi def link boxlangComma Delimiter
hi def link boxlangSemicolon Delimiter
hi def link boxlangDot Operator
hi def link boxlangColon Operator

" Scopes
hi def link boxlangScope Identifier

" Special constructs
hi def link boxlangImport Include
hi def link boxlangPackage String
hi def link boxlangPackageKeyword Keyword
hi def link boxlangPackageName String
hi def link boxlangNew Keyword
hi def link boxlangParam Keyword
hi def link boxlangInclude Include
" / HIGHLIGHTING }}}

let b:current_syntax = "boxlang"

let &cpo = s:cpo_save
unlet s:cpo_save

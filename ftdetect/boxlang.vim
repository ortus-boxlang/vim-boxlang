" Vim filetype detection file
"
" Language:     BoxLang
" Maintainer:   Ortus Solutions <info@ortussolutions.com>
" URL:          https://github.com/ortus-solutions/vim-boxlang
" Last Change:  2026 Feb 12
" License:      Apache 2.0
"
" Description:  Filetype detection for BoxLang files

" BoxLang script files (.bx, .bxs)
au BufNewFile,BufRead *.bx,*.bxs setfiletype boxlang

" BoxLang template files (.bxm)
au BufNewFile,BufRead *.bxm setfiletype boxlangTemplate

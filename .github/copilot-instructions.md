# Copilot Instructions for vim-boxlang

## Project Overview

**vim-boxlang** is a Vim/Neovim syntax highlighting plugin for BoxLang - a dynamic JVM language with modern features. This is NOT a language runtime; it only provides syntax highlighting through `.vim` files.

## Architecture: Dual-Syntax System

The plugin uses **two separate syntax files** because BoxLang has fundamentally different modes:

1. **`syntax/boxlang.vim`** - Script syntax (`.bx`, `.bxs` files)
   - Pure script code with classes, functions, operators
   - Supports component islands (triple backtick blocks containing template syntax)
   - ~330 lines

2. **`syntax/boxlang-template.vim`** - Template/markup syntax (`.bxm` files)
   - HTML + `bx:` prefixed tags (`<bx:if>`, `<bx:output>`, etc.)
   - Embedded `<bx:script>` blocks containing full script syntax
   - Includes vim's html.vim for markup highlighting
   - ~190 lines

3. **`ftdetect/boxlang.vim`** - Filetype auto-detection
   - Maps extensions to filetypes (`*.bx,*.bxs` → `boxlang`, `*.bxm` → `boxlangTemplate`)

**Critical Pattern**: Both files use `syntax include` to embed the other's syntax, enabling cross-syntax contexts.

## BoxLang Language Features (Syntax Highlighting Requirements)

BoxLang is **case-insensitive** (`syn case ignore` required) and has these key features:

### BoxLang-Specific Operators (Not in CFML)
- **Bitwise**: `b|`, `b&`, `b^`, `b~`, `b<<`, `b>>`, `b>>>`  (must use `\v` very magic mode)
- **Strict equality**: `===`, `!==`
- **Elvis**: `?:`
- **Arrow/Lambda functions**: `=>`, `->`
- **Static BIF reference**: `::`

### Modern Keywords (BoxLang vs. CFML Differences)
- `class` (BoxLang) vs. `component` (CFML) - use `class`
- `interface`, `assert`, `final`, `package` - first-class keywords
- All control flow: `if`, `for`, `while`, `switch`, `try`, `catch`, etc.

### String Interpolation
- `#expression#` inside strings - requires nested region syntax
- `##` escapes to single `#`
- Works in both script strings AND template attributes

### Comments (All Types)
- Script: `//`, `/* */`, `/** */` (JavaDoc)
- Template: `<!--- --->`

### Template Tags
- All use `bx:` prefix (NOT `cf` prefix)
- Pattern: `<bx:if>`, `<bx:output>`, `<bx:script>`, etc.
- Must support both self-closing (`<bx:set ... />`) and body tags

## Vim Syntax Conventions Used

### Naming Pattern
All syntax groups prefixed with `boxlang` (lowercase):
```vim
syn keyword boxlangKeyword class interface
syn match boxlangOperator "\v\=\=\="
hi def link boxlangKeyword Keyword
```

### Organization Pattern (Folding Markers)
```vim
" SECTION NAME {{{
syn keyword boxlangKeyword ...
" / SECTION NAME }}}
```

### Very Magic Mode (`\v`)
Always use `\v` for readable regex patterns:
```vim
syn match boxlangBitwiseOp "\vb\|"  " NOT: "\<b|\>"
```

### Cross-Syntax Embedding
```vim
" In boxlang.vim (script file):
syn include @boxlangTemplateIsland syntax/boxlang-template.vim
unlet b:current_syntax
syn region boxlangComponentIsland matchgroup=boxlangIslandDelim start="```" end="```" contains=@boxlangTemplateIsland

" In boxlang-template.vim (template file):
syn include @boxlangScript syntax/boxlang.vim
unlet b:current_syntax
syn region boxlangScriptBlock start="<bx:script>" end="</bx:script>" contains=@boxlangScript
```

**Critical**: Always `unlet b:current_syntax` after `syn include` to allow re-inclusion.

### Performance Rules
1. Use `syn keyword` instead of `syn match` when possible (faster)
2. Use `contained` for nested syntax items
3. Avoid lookahead/lookbehind regex - vim's engine is slow
4. `syn sync fromstart` for accuracy (acceptable for syntax files <1000 lines)

## Common Development Workflows

### Testing Changes Locally
```bash
# Symlink for live development (Vim)
ln -sf $PWD/syntax/boxlang.vim ~/.vim/syntax/
ln -sf $PWD/syntax/boxlang-template.vim ~/.vim/syntax/
ln -sf $PWD/ftdetect/boxlang.vim ~/.vim/ftdetect/

# Or Neovim
ln -sf $PWD/syntax/* ~/.config/nvim/syntax/
ln -sf $PWD/ftdetect/* ~/.config/nvim/ftdetect/

# Reload syntax in vim
:syntax clear
:edit
# Or force filetype
:set filetype=boxlang
```

### Testing Checklist
1. Create test files: `test.bx`, `test.bxs`, `test.bxm`
2. Verify keywords, operators (especially bitwise), string interpolation
3. Test with multiple colorschemes (`:colorscheme desert`, `:colorscheme murphy`)
4. Test folding: `:set foldmethod=syntax`, `za` to toggle
5. Verify no performance issues with large files (500+ lines)

### Common Debugging
```vim
" Check current syntax groups under cursor
:echo synIDattr(synID(line('.'), col('.'), 1), 'name')

" List all syntax groups
:syntax list

" Check filetype detection
:set filetype?
```

## Repository Conventions

- **Main branch**: `main` (stable releases only)
- **Development branch**: `development` (all PRs go here)
- **Issues**: GitHub Issues at https://github.com/ortus-boxlang/vim-boxlang/issues
- **License**: Apache 2.0

## Critical "Gotchas"

1. **Case insensitivity**: BoxLang keywords work in any case - always use `syn case ignore`
2. **Repository name**: `ortus-boxlang/vim-boxlang` (not `ortus-solutions`)
3. **No CFML compatibility**: This highlights BoxLang only (`bx:` tags, `class` keyword, bitwise ops)
4. **HTML integration**: Template files must include `runtime! syntax/html.vim` for markup support
5. **Dual syntax**: Changes to operators/keywords often need updates in BOTH files

## Adding New Syntax Features

### Add a keyword:
```vim
" In syntax/boxlang.vim
syn keyword boxlangKeyword mynewkeyword
" Already linked to Keyword group via hi def link
```

### Add an operator:
```vim
syn match boxlangOperator "\v\<mynewop\>"
" Or for keyword-style operators:
syn keyword boxlangOperator mynewop
```

### Add a template tag:
```vim
" In syntax/boxlang-template.vim
syn keyword boxlangTag contained mynewTag
" Add region for folding if it's a body tag:
syn region boxlangMyNewTagRegion transparent fold start="<bx:mynewTag\>" end="</bx:mynewTag>" contains=ALL
```

### Add string pattern:
```vim
syn region boxlangCustomString start=+"+ end=+"+ contains=boxlangInterpolation
hi def link boxlangCustomString String
```

## Reference Files

- **Main BoxLang runtime**: https://github.com/ortus-boxlang/boxlang (has ANTLR grammars)
- **BoxGrammar.g4/BoxLexer.g4**: Source of truth for script syntax
- **CFGrammar.g4/CFLexer.g4**: Source of truth for template tag syntax
- **CONTRIBUTING.md**: Full development setup and vim syntax guidelines

## Related Documentation

- BoxLang docs: https://boxlang.ortusbooks.com/
- Vim syntax guide: `:help syntax`
- Very magic mode: `:help /\v`

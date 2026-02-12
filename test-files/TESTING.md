# Testing Guide for vim-boxlang

This guide will help you test the BoxLang syntax highlighting plugin.

## Quick Start Testing

### 1. Install the Plugin Locally

For **Vim**:
```bash
cd /Users/lmajano/Sites/projects/vim-boxlang

# Create directories if they don't exist
mkdir -p ~/.vim/syntax ~/.vim/ftdetect

# Create symlinks for live development
ln -sf $PWD/syntax/boxlang.vim ~/.vim/syntax/
ln -sf $PWD/syntax/boxlang-template.vim ~/.vim/syntax/
ln -sf $PWD/ftdetect/boxlang.vim ~/.vim/ftdetect/
```

For **Neovim**:
```bash
cd /Users/lmajano/Sites/projects/vim-boxlang

# Create directories if they don't exist
mkdir -p ~/.config/nvim/syntax ~/.config/nvim/ftdetect

# Create symlinks for live development
ln -sf $PWD/syntax/boxlang.vim ~/.config/nvim/syntax/
ln -sf $PWD/syntax/boxlang-template.vim ~/.config/nvim/syntax/
ln -sf $PWD/ftdetect/boxlang.vim ~/.config/nvim/ftdetect/
```

### 2. Open Test Files in Vim

```bash
# Open script file
vim test-files/test-script.bx

# Or template file
vim test-files/test-template.bxm

# Or executable script
vim test-files/test-executable.bxs
```

### 3. Verify Syntax Highlighting

Once in vim, check that syntax is active:

```vim
:syntax on
:set filetype?
```

You should see `filetype=boxlang` for `.bx`/`.bxs` files or `filetype=boxlangTemplate` for `.bxm` files.

## Detailed Testing Checklist

### Test 1: Filetype Detection

Open each test file and verify automatic detection:

```bash
vim test-files/test-script.bx
```

In vim, run:
```vim
:set filetype?
```

Expected output: `filetype=boxlang`

Repeat for:
- `test-executable.bxs` → should be `boxlang`
- `test-template.bxm` → should be `boxlangTemplate`

### Test 2: Keywords Highlighting

Open `test-script.bx` and verify these keywords are highlighted:
- `class`, `interface` (BoxLang-specific)
- `function`, `return`, `var`, `final`, `static`
- `if`, `else`, `for`, `while`, `switch`, `case`
- `try`, `catch`, `finally`, `throw`, `rethrow`
- `assert` (BoxLang-specific)
- `true`, `false`, `null`

### Test 3: Operators Highlighting

Look for these operators in `test-script.bx`:

**Bitwise operators (BoxLang-specific):**
- `b|`, `b&`, `b^`, `b~`, `b<<`, `b>>`, `b>>>`

**Strict equality (BoxLang-specific):**
- `===`, `!==`

**Elvis operator:**
- `?:`

**Arrow/Lambda:**
- `=>`, `->`

**Static reference:**
- `::`

### Test 4: String Interpolation

In `test-script.bx`, find the `testStrings()` function and verify:
- `#expression#` inside strings is highlighted differently
- `##` escaped hashes are highlighted correctly
- Works in both single and double quotes

### Test 5: Comments

Verify all comment types are highlighted:
- `//` single line comments
- `/* */` multi-line comments
- `/** */` JavaDoc-style comments
- `<!--- --->` template comments (in `.bxm` files)
- TODO, FIXME, XXX, HACK, NOTE markers are highlighted

### Test 6: Template Tags (in test-template.bxm)

Open `test-template.bxm` and verify:
- `<bx:if>`, `<bx:output>`, `<bx:for>`, etc. are highlighted
- Tag attributes are highlighted
- HTML tags are also highlighted (due to html.vim inclusion)
- Expression interpolation in attributes works: `condition="#value#"`

### Test 7: Embedded Syntax

**Script with template islands:**
In `test-script.bx`, find the `getTemplate()` function:
- The triple backtick blocks should highlight template syntax inside

**Template with script blocks:**
In `test-template.bxm`, find the `<bx:script>` section:
- Script syntax should work inside the `<bx:script>` tags

### Test 8: Code Folding

Enable folding in vim:
```vim
:set foldmethod=syntax
:set foldenable
```

Test folding with:
- `za` - Toggle fold under cursor
- `zR` - Open all folds
- `zM` - Close all folds

Verify folding works for:
- Classes
- Functions
- Control structures (if, for, while, switch, try)
- Template tag regions

## Testing with Different Color Schemes

Test the highlighting with various color schemes:

```vim
:colorscheme desert
:colorscheme murphy
:colorscheme slate
:colorscheme delek
:colorscheme evening
:colorscheme default
```

Verify that syntax highlighting is visible and distinct in each scheme.

## Debugging Syntax Issues

### Check what syntax group is under cursor:

```vim
:echo synIDattr(synID(line('.'), col('.'), 1), 'name')
```

Move cursor to different tokens and check their syntax groups.

### List all active syntax groups:

```vim
:syntax
```

This shows all syntax rules currently loaded.

### Reload syntax file:

If you make changes to the syntax files:

```vim
:syntax clear
:edit
```

Or explicitly reload:
```vim
:set filetype=boxlang
```

### Enable syntax debugging:

```vim
:syntime on
" Open a file and move around
:syntime report
```

This shows which syntax patterns are slow.

## Performance Testing

Test with a larger file:

```bash
# Create a large test file
for i in {1..1000}; do
    cat test-files/test-script.bx >> test-files/large-test.bx
done

# Open it in vim
vim test-files/large-test.bx
```

Check if:
- Syntax highlighting loads quickly
- Scrolling is smooth
- No noticeable lag when editing

## Manual Visual Tests

Go through each test file and verify these elements look correct:

### In test-script.bx:
- [ ] `@Component` annotation highlighted
- [ ] `class UserService` - class keyword and name highlighted
- [ ] Property declarations highlighted
- [ ] `===` strict equality operator
- [ ] `b|` bitwise OR operator
- [ ] `=>` arrow function
- [ ] `->` lambda function
- [ ] `#name#` string interpolation
- [ ] `##` escaped hash
- [ ] Comments (all types)
- [ ] `interface` keyword

### In test-template.bxm:
- [ ] `<!--- --->` template comments
- [ ] `<bx:if>`, `<bx:output>` tags highlighted
- [ ] HTML tags highlighted
- [ ] `#expression#` in text
- [ ] `#expression#` in attributes
- [ ] `<bx:script>` block has script highlighting

### In test-executable.bxs:
- [ ] Same as test-script.bx
- [ ] Shebang line `#!/usr/bin/env boxlang`

## Automated Testing (Future)

Currently testing is manual/visual. Future improvements could include:

1. **Vim script tests** - Using vim's testing framework
2. **Screenshot comparison** - Compare rendering across versions
3. **Syntax coverage** - Ensure all language features have syntax rules
4. **Performance benchmarks** - Measure syntax loading time

## Common Issues

### Syntax not working?

1. Check filetype: `:set filetype?`
2. Check syntax is on: `:syntax on`
3. Reload: `:syntax clear` then `:edit`
4. Check symlinks exist: `ls -la ~/.vim/syntax/boxlang*.vim`

### Wrong filetype detected?

Manually set it:
```vim
:set filetype=boxlang
```

Or add to file:
```
// vim: set filetype=boxlang:
```

### Colors look weird?

Try different color scheme:
```vim
:colorscheme desert
```

Or customize highlighting:
```vim
hi boxlangKeyword ctermfg=cyan guifg=#00ffff
```

## Reporting Issues

If you find syntax highlighting issues:

1. Note the specific code pattern that's not highlighted correctly
2. Check the syntax group: `:echo synIDattr(synID(line('.'), col('.'), 1), 'name')`
3. Your vim version: `:version`
4. Color scheme in use: `echo g:colors_name`
5. Create a minimal test case
6. Report at: https://github.com/ortus-boxlang/vim-boxlang/issues

## Next Steps

After testing:

1. If everything works, the plugin is ready to use!
2. If issues found, check the syntax files in `syntax/` directory
3. Refer to `CONTRIBUTING.md` for development guidelines
4. Check `.github/copilot-instructions.md` for AI coding assistance

Happy testing! 🎨

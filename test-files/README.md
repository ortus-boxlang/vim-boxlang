# Test Files for vim-boxlang

This directory contains comprehensive test files for validating BoxLang syntax highlighting.

## Quick Start

Run the automated setup script:

```bash
./setup-test.sh
```

This will:
- Detect vim or neovim
- Create necessary directories
- Symlink syntax files for live development
- Show you test commands to run

## Test Files

- **`test-script.bx`** - Comprehensive BoxLang script syntax test
  - Classes, interfaces, functions
  - All operators including bitwise (`b|`, `b&`, etc.)
  - Arrow functions, lambdas
  - String interpolation
  - Annotations
  - Component islands

- **`test-template.bxm`** - BoxLang template syntax test
  - All `bx:` tags
  - HTML integration
  - Expression interpolation
  - Embedded `<bx:script>` blocks

- **`test-executable.bxs`** - Executable script test
  - Same as script syntax
  - Can be run directly with BoxLang

- **`test-modern-syntax.bx`** - Newer grammar features test
  - Range operators (`..`, `..<`, `>..`, `>..<`)
  - Spread/rest operator (`...`) in arrays, structs, and function calls
  - Object and array destructuring, including rest bindings
  - `set{}` / `sb{}` / `stringbuilder{}` collection literals
  - Two-variable `for (item, index in arr)` / `for (key, value in struct)`
  - `assert expr : "message"`
  - Local (in-body) classes

- **`TESTING.md`** - Complete testing guide with detailed instructions

## Manual Testing

If you prefer manual setup:

### For Vim:
```bash
ln -sf $PWD/../syntax/boxlang.vim ~/.vim/syntax/
ln -sf $PWD/../syntax/boxlangTemplate.vim ~/.vim/syntax/
ln -sf $PWD/../ftdetect/boxlang.vim ~/.vim/ftdetect/
```

### For Neovim:
```bash
ln -sf $PWD/../syntax/boxlang.vim ~/.config/nvim/syntax/
ln -sf $PWD/../syntax/boxlangTemplate.vim ~/.config/nvim/syntax/
ln -sf $PWD/../ftdetect/boxlang.vim ~/.config/nvim/ftdetect/
```

Then open any test file:
```bash
vim test-script.bx
```

## What to Check

Inside vim/neovim:

1. **Verify filetype detection:**
   ```vim
   :set filetype?
   ```
   Should show `boxlang` for `.bx`/`.bxs` or `boxlangTemplate` for `.bxm`

2. **Check syntax highlighting:**
   - Keywords (class, interface, assert, final, etc.)
   - Operators (especially `b|`, `===`, `?:`, `=>`, `->`)
   - String interpolation (`#expression#`)
   - Comments (all types)
   - Template tags (`<bx:if>`, `<bx:output>`, etc.)

3. **Test folding:**
   ```vim
   :set foldmethod=syntax
   za
   ```

4. **Try different themes:**
   ```vim
   :colorscheme desert
   :colorscheme murphy
   ```

## Debugging

If something doesn't look right:

```vim
" Check syntax group under cursor
:echo synIDattr(synID(line('.'), col('.'), 1), 'name')

" Reload syntax
:syntax clear
:edit

" List all syntax rules
:syntax
```

## See Also

- Full testing guide: [TESTING.md](TESTING.md)
- Contributing guide: [../CONTRIBUTING.md](../CONTRIBUTING.md)
- AI coding guide: [../.github/copilot-instructions.md](../.github/copilot-instructions.md)

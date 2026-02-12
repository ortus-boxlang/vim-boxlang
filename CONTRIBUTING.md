# vim-boxlang Contributing Guide

Hola amigo! I'm really excited that you are interested in contributing to vim-boxlang. Before submitting your contribution, please make sure to take a moment and read through the following guidelines:

- [Code Of Conduct](#code-of-conduct)
- [Bug Reporting](#bug-reporting)
- [Support Questions](#support-questions)
- [Pull Request Guidelines](#pull-request-guidelines)
- [Development Setup](#development-setup)
- [Testing Your Changes](#testing-your-changes)
- [Vim Syntax Guidelines](#vim-syntax-guidelines)
- [Financial Contributions](#financial-contributions)
- [Contributors](#contributors)

## Code Of Conduct

This project is open source, and as such, the maintainers give their free time to build and maintain the source code held within. They make the code freely available in the hope that it will be of use to other developers and/or businesses. Please be considerate towards maintainers when raising issues or presenting pull requests.  **We all follow the Golden Rule: Do to others as you want them to do to you.**

- As contributors and maintainers of this project, we pledge to respect all people who contribute through reporting issues, posting feature requests, updating documentation, submitting pull requests or patches, and other activities.
- Participants will be tolerant of opposing views.
- Examples of unacceptable behavior by participants include the use of sexual language or imagery, derogatory comments or personal attacks, trolling, public or private harassment, insults, or other unprofessional conduct.
- Project maintainers have the right and responsibility to remove, edit, or reject comments, commits, code, wiki edits, issues, and other contributions that are not aligned with this Code of Conduct. Project maintainers who do not follow the Code of Conduct may be removed from the project team.
- When interpreting the words and actions of others, participants should always assume good intentions.  Emotions cannot be derived from textual representations.
- Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by opening an issue or contacting one or more of the project maintainers.

## Bug Reporting

vim-boxlang tracks its issues on GitHub:

- GitHub Issues: https://github.com/ortus-boxlang/vim-boxlang/issues

If you file a bug report, your issue should contain:

- A clear, descriptive title
- A detailed description of the issue
- Steps to reproduce the issue
- BoxLang code samples that demonstrate the problem
- Your vim/neovim version (`:version`)
- Expected syntax highlighting behavior vs. actual behavior
- Screenshots if applicable

The goal of a bug report is to make it easy for yourself - and others - to replicate the bug and develop a fix for it. All issues that do not contain a way to replicate will not be addressed.

## Support Questions

If you have any questions on usage, professional support or just ideas to bounce off the maintainers, please do not create an issue. Leverage our support channels first:

- Ortus Community Discourse: https://community.ortussolutions.com
- BoxLang Slack Team: http://boxteam.ortussolutions.com/
- Professional Support: https://www.ortussolutions.com/services/support

## Pull Request Guidelines

- The `main` branch is just a snapshot of the latest stable release. All development should be done in dedicated branches. Do not submit PRs against the main branch. They will be closed.
- All pull requests should be sent against the `development` branch.
- It's OK to have multiple small commits as you work on the PR - GitHub will automatically squash it before merging.
- Test your changes with real BoxLang code samples before submitting.
- Include example BoxLang code in your PR description that demonstrates the fix/improvement.
- Reference any related GitHub issues in your PR description.

## Development Setup

To develop on vim-boxlang, you will need:

- [Vim](https://www.vim.org/) 8.0+ or [Neovim](https://neovim.io/) 0.5+
- Basic knowledge of [Vim script syntax](https://learnvimscriptthehardway.stevelosh.com/)
- Access to BoxLang code samples for testing

Here's how to set up for development:

1. Fork and clone the repository:
   ```bash
   git clone git@github.com:YOUR-USERNAME/vim-boxlang.git
   cd vim-boxlang
   ```

2. Install the plugin locally for testing:
   
   **For Vim:**
   ```bash
   mkdir -p ~/.vim/syntax ~/.vim/ftdetect
   ln -s $PWD/syntax/boxlang.vim ~/.vim/syntax/
   ln -s $PWD/syntax/boxlang-template.vim ~/.vim/syntax/
   ln -s $PWD/ftdetect/boxlang.vim ~/.vim/ftdetect/
   ```
   
   **For Neovim:**
   ```bash
   mkdir -p ~/.config/nvim/syntax ~/.config/nvim/ftdetect
   ln -s $PWD/syntax/boxlang.vim ~/.config/nvim/syntax/
   ln -s $PWD/syntax/boxlang-template.vim ~/.config/nvim/syntax/
   ln -s $PWD/ftdetect/boxlang.vim ~/.config/nvim/ftdetect/
   ```

3. Create test BoxLang files:
   ```bash
   mkdir -p test-files
   # Create .bx, .bxs, and .bxm files for testing
   ```

## Testing Your Changes

Before submitting a PR, test your syntax changes thoroughly:

1. **Create comprehensive test files** with various BoxLang constructs:
   - Keywords, operators, and control structures
   - String interpolation with `#expressions#`
   - Functions (arrow, lambda, regular)
   - Annotations and comments
   - Template tags and HTML (for .bxm files)
   - Edge cases and complex nesting

2. **Visual inspection** in vim/neovim:
   ```vim
   :e test-files/sample.bx
   :syntax on
   :set filetype=boxlang
   ```

3. **Test different color schemes** to ensure highlighting works across themes:
   ```vim
   :colorscheme desert
   :colorscheme murphy
   :colorscheme default
   ```

4. **Test folding** if you modified fold regions:
   ```vim
   :set foldmethod=syntax
   :set foldenable
   za  " Toggle fold
   ```

5. **Check filetype detection**:
   ```vim
   :set filetype?
   ```

## Vim Syntax Guidelines

When contributing to the syntax files, please follow these guidelines:

### File Organization

- **boxlang.vim** - Script syntax (`.bx`, `.bxs` files)
- **boxlang-template.vim** - Template syntax (`.bxm` files)
- **ftdetect/boxlang.vim** - Filetype detection

### Syntax Patterns

1. **Use descriptive names** with `boxlang` prefix:
   ```vim
   syn keyword boxlangKeyword class interface
   syn match boxlangOperator "==="
   ```

2. **Group related items**:
   ```vim
   " KEYWORDS {{{
   syn keyword boxlangKeyword ...
   " / KEYWORDS }}}
   ```

3. **Add comments** explaining complex patterns:
   ```vim
   " Bitwise operators (BoxLang-specific)
   syn match boxlangBitwiseOp "\vb\|"
   ```

4. **Use regions for containment**:
   ```vim
   syn region boxlangString start='"' end='"' contains=boxlangInterpolation
   ```

5. **Link to standard highlight groups**:
   ```vim
   hi def link boxlangKeyword Keyword
   hi def link boxlangString String
   ```

### Performance Considerations

- Prefer `keyword` over `match` when possible (faster)
- Use `\v` very magic mode for readable regex
- Keep patterns specific to avoid over-matching
- Use `contained` for nested syntax items
- Test with large files (1000+ lines)

### BoxLang-Specific Notes

- BoxLang is **case-insensitive**: use `syn case ignore`
- String interpolation uses `#expression#`
- Support both script (`.bx`, `.bxs`) and template (`.bxm`) modes
- Template files need HTML syntax integration
- Script files can have template islands (triple backticks)
- Template files can have `<bx:script>` blocks

### Testing Checklist

- [ ] Keywords highlighted correctly
- [ ] Operators (including bitwise) highlighted
- [ ] String interpolation works (`#var#`, `##` escape)
- [ ] Comments (all types: `//`, `/* */`, `/** */`, `<!--- --->`)
- [ ] Functions (regular, arrow, lambda)
- [ ] Annotations (`@name(...)`)
- [ ] Template tags (`<bx:if>`, etc.)
- [ ] HTML in template files
- [ ] Folding works correctly
- [ ] No performance issues with large files
- [ ] Works with different color schemes

## Financial Contributions

You can support BoxLang and all of our Open Source initiatives at Ortus Solutions by becoming a patreon. You can also get lots of goodies and services depending on the level of contributions.

- [Become a backer or sponsor on Patreon](https://www.patreon.com/ortussolutions)
- [One-time donations via PayPal](https://www.paypal.com/paypalme/ortussolutions)


## Contributors

Thank you to all the people who have already contributed to vim-boxlang! We ❤️❤️❤️ love you!

<a href="https://github.com/ortus-boxlang/vim-boxlang/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ortus-boxlang/vim-boxlang"/>
</a>

Made with [contributors-img](https://contrib.rocks)

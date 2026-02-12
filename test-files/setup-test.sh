#!/bin/bash
# Quick test setup script for vim-boxlang

set -e

echo "🧪 vim-boxlang Testing Setup"
echo "=============================="
echo ""

# Detect vim or neovim
if command -v nvim &> /dev/null; then
    VIM_TYPE="neovim"
    VIM_DIR="$HOME/.config/nvim"
    VIM_CMD="nvim"
    echo "✓ Detected: Neovim"
elif command -v vim &> /dev/null; then
    VIM_TYPE="vim"
    VIM_DIR="$HOME/.vim"
    VIM_CMD="vim"
    echo "✓ Detected: Vim"
else
    echo "❌ Error: Neither vim nor neovim found!"
    exit 1
fi

echo ""

# Create directories
echo "📁 Creating syntax directories..."
mkdir -p "$VIM_DIR/syntax"
mkdir -p "$VIM_DIR/ftdetect"

# Get project directory
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "📦 Project directory: $PROJECT_DIR"

echo ""
echo "🔗 Creating symlinks..."

# Create symlinks
ln -sf "$PROJECT_DIR/syntax/boxlang.vim" "$VIM_DIR/syntax/"
ln -sf "$PROJECT_DIR/syntax/boxlang-template.vim" "$VIM_DIR/syntax/"
ln -sf "$PROJECT_DIR/ftdetect/boxlang.vim" "$VIM_DIR/ftdetect/"

echo "   ✓ boxlang.vim"
echo "   ✓ boxlang-template.vim"
echo "   ✓ ftdetect/boxlang.vim"

echo ""
echo "✅ Installation complete!"
echo ""
echo "📖 Quick Test Commands:"
echo ""
echo "  # Test script file (.bx):"
echo "  $VIM_CMD $PROJECT_DIR/test-files/test-script.bx"
echo ""
echo "  # Test template file (.bxm):"
echo "  $VIM_CMD $PROJECT_DIR/test-files/test-template.bxm"
echo ""
echo "  # Test executable script (.bxs):"
echo "  $VIM_CMD $PROJECT_DIR/test-files/test-executable.bxs"
echo ""
echo "📝 Inside vim, check filetype with:"
echo "  :set filetype?"
echo ""
echo "🎨 Try different color schemes:"
echo "  :colorscheme desert"
echo "  :colorscheme murphy"
echo ""
echo "📚 Full testing guide:"
echo "  cat $PROJECT_DIR/test-files/TESTING.md"
echo ""
echo "Happy testing! 🚀"

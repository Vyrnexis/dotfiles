# Local Binaries & Cheatsheets

Personal utility scripts and cheatsheets, managed with [GNU Stow](https://www.gnu.org/software/stow/).

These scripts are automatically placed into `~/.local/bin/` so they are available in your system `$PATH`.

## Structure

```
bin/.local/bin/
├── helix-cheatsheet.sh    # Quick reference for Helix editor keybindings
├── kitty-cheatsheet.sh    # Quick reference for Kitty terminal shortcuts
└── nvim-cheatsheet.sh     # Quick reference for Neovim mappings
```

## Installation

Ensure `~/.local/bin` is in your shell's `$PATH` (this is automatically handled if you use the Zsh configuration provided in this repository).

```bash
cd ~/dotfiles
stow bin
```

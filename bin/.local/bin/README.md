# Local Binaries & Cheatsheets

Personal utility scripts and cheatsheets, managed with [GNU Stow](https://www.gnu.org/software/stow/).

These scripts are automatically placed into `~/.local/bin/` so they are available in your system `$PATH`.

## Structure

```
bin/.local/bin/
├── helix-cheatsheet    # Helix defaults and custom mappings
├── kitty-cheatsheet    # Kitty defaults and configured features
└── nvim-cheatsheet     # Neovim defaults and custom mappings
```

Each command pages output only when connected to a terminal and emits plain
text when redirected. Use `--plain` to disable colors, `--no-pager` to print
directly, or `--help` to show usage.

## Installation

Ensure `~/.local/bin` is in your shell's `$PATH` (this is automatically handled if you use the Zsh configuration provided in this repository).

```bash
cd ~/dotfiles
stow bin
```

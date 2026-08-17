# Zsh Configuration

Personal Zsh shell configuration, managed with [GNU Stow](https://www.gnu.org/software/stow/).

This configuration completely moves Zsh out of the `$HOME` directory and into `~/.config/zsh`, maintaining a clean home folder. It is heavily optimized for fast startup times.

## Features

- **Blazing Fast:** Caches `compinit`, `zoxide`, and `starship` initializations for near-instant startup.
- **Modular:** Separated into `aliases.zsh`, `bindings.zsh`, `prompt.zsh`, etc.
- **Plugin Management:** A lightweight custom plugin loader (`plugins.zsh`) that pulls directly from GitHub without heavy frameworks.
- **FZF Integration:** Configured to cleanly search for files (excluding `.git`) and preview them using `bat`.

## Structure

```
zsh/.config/zsh/
├── .zshenv          # XDG directories, PATH, and EDITOR config
├── .zshrc           # Main configuration entry point
├── aliases.zsh      # Custom aliases
├── bindings.zsh     # Keybindings and vi-mode fixes
├── fzf.zsh          # Fuzzy finder configuration
├── plugins.zsh      # Custom plugin loader
├── prompt.zsh       # Starship prompt init
└── starship.toml    # Prompt configuration
```

## Prerequisites

| Tool | Install | Used for |
|------|---------|----------|
| `zsh` | Package manager | The shell |
| `starship` | Package manager / script | The cross-shell prompt |
| `zoxide` | Package manager | Smarter `cd` command |
| `eza` | Package manager | Better `ls` |
| `bat` | Package manager | Better `cat` |
| `fzf` | Package manager | Fuzzy finding |
| `fd` | Package manager | Faster `find` used by FZF |
| `rg` | Package manager | Ripgrep for searching text |

## Installation

Because this setup changes the Zsh configuration directory, you must add the following to your `/etc/zsh/zshenv` (or system-wide equivalent):

```bash
if [[ -z "$XDG_CONFIG_HOME" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi
if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
```

Then stow the config:

```bash
cd ~/dotfiles
stow zsh
```

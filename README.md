# Dotfiles

Personal Linux configuration managed as GNU Stow packages.

## Packages

- `bin`: local cheatsheet commands installed under `~/.local/bin`
- `helix`: Helix editor configuration and language-server settings
- `kitty`: Kitty terminal configuration and Dracula theme
- `nimlaunch`: NimLaunch configuration and launcher scripts
- `nvim`: minimal Lua-based Neovim configuration
- `zsh`: XDG-based Zsh configuration, plugins, and Starship prompt

The Zsh plugins are pinned as Git submodules. Machine-local files, such as the
Helix runtime symlink, are intentionally excluded from Git.

## Prerequisites

Install the packages you intend to stow, plus these base tools:

- `git`
- `stow`
- `zsh`
- `bash`, `less`, and `sed` for the cheatsheet scripts

Each package README documents its optional tools, fonts, language servers, and
formatters.

## Installation

Clone the repository with its Zsh plugin submodules:

```bash
git clone --recurse-submodules https://github.com/Vyrnexis/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Zsh is stored under `~/.config/zsh`. Before stowing it, configure Zsh to find
that directory in `/etc/zsh/zshenv` or the equivalent system-wide file:

```zsh
if [[ -z "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
```

Preview the links, then install all packages:

```bash
stow --no --verbose=2 --target="$HOME" bin helix kitty nimlaunch nvim zsh
stow --target="$HOME" bin helix kitty nimlaunch nvim zsh
```

Existing files at a target path can cause Stow conflicts. Review and move those
files yourself before retrying; do not use `stow --adopt` unless you intend to
replace repository files with the target files.

## Maintenance

Restow packages after reorganizing files:

```bash
stow --restow --target="$HOME" bin helix kitty nimlaunch nvim zsh
```

Remove the managed links without deleting repository files:

```bash
stow --delete --target="$HOME" bin helix kitty nimlaunch nvim zsh
```

Update submodules after pulling repository changes:

```bash
git submodule update --init --recursive
```

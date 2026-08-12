# Vyrnexis Dotfiles

This repository contains my personal configurations for Linux, managed with [GNU Stow](https://www.gnu.org/software/stow/).

It is designed to be highly portable, performant, and clean, meaning it can be easily deployed on any Linux distribution (Solus, Arch, Ubuntu, etc.) with a single command.

## 📦 What's Included

- **Neovim** (`nvim`): Super lightweight custom Lua-based configuration tailored for development.
- **Zsh** (`zsh`): Fully featured shell setup with intelligent paths, plugins, and fuzzy finding.
  - _Note: Zsh plugins are tracked as Git Submodules for easy syncing._
- **Kitty** (`kitty`): A beautiful, hardware-accelerated terminal configuration with Dracula theme.
- **NimLaunch** (`nimlaunch`): Configuration for my own custom launcher project, which you can find at [Vyrnexis/NimLaunch](https://github.com/Vyrnexis/NimLaunch).

## 🚀 Installation

To replicate this exact setup on a fresh Linux machine, simply follow these steps.

### 1. Prerequisites

Ensure you have the following installed on your system:

- `git`
- `stow`
- `zsh`
- `neovim`
- `kitty`
- `starship` (for the shell prompt)
- `nimlaunch` (optional, custom launcher)

### 2. Configure Zsh Directory

To keep the home directory clean, this configuration routes Zsh to `~/.config/zsh`. You must globally tell Zsh where to look by adding these intelligent checks to your system config (`/etc/zsh/zshenv`):

```bash
if [[ -z "$XDG_CONFIG_HOME" ]]
then
	export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
	export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
```

### 3. Clone the Repository

Because the Zsh plugins are managed via Git Submodules, you **must** use the `--recurse-submodules` flag when cloning so that they are downloaded automatically:

```bash
git clone --recurse-submodules https://github.com/Vyrnexis/dotfiles.git ~/dotfiles
```

### 4. Stow the Configs

Navigate into the dotfiles directory and use `stow` to automatically create the symlinks in your home directory:

```bash
cd ~/dotfiles
stow nvim zsh kitty nimlaunch
```

That's it! Restart your terminal and everything will be active.

## ✨ Highlights & Architecture

- **Clean Zsh Environment:** All Zsh configurations are elegantly routed into `~/.config/zsh` to keep your home directory completely free of clutter.
- **Logical PATH Management:** All `PATH` variables are defined as a unique Zsh array in `.zshenv` to prevent duplicate path bloat and guarantee execution availability across both the terminal and graphical apps.
- **AppImage Ready:** Automatically adds `~/.local/bin/Apps` to your path for instant execution of downloaded AppImages.

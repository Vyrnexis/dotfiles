# Vyrnexis Dotfiles

This repository contains my personal configurations for Linux, managed effortlessly with [GNU Stow](https://www.gnu.org/software/stow/). 

It is designed to be highly portable, performant, and clean, meaning it can be easily deployed on any Linux distribution (Solus, Arch, Ubuntu, etc.) with a single command.

## 📦 What's Included

* **Neovim** (`nvim`): Custom Lua-based configuration tailored for development.
* **Zsh** (`zsh`): Fully featured shell setup with intelligent paths, plugins, and fuzzy finding.
  * *Note: Zsh plugins are tracked as Git Submodules for easy syncing.*
* **Kitty** (`kitty`): A beautiful, borderless, hardware-accelerated terminal configuration with Dracula theme.

## 🚀 Installation

To replicate this exact setup on a fresh Linux machine, simply follow these steps.

### 1. Prerequisites
Ensure you have the following installed on your system:
* `git`
* `stow`
* `zsh`
* `neovim`
* `kitty`
* `starship` (for the shell prompt)

### 2. Clone the Repository
Because the Zsh plugins are managed via Git Submodules, you **must** use the `--recurse-submodules` flag when cloning so that they are downloaded automatically:

```bash
git clone --recurse-submodules https://github.com/Vyrnexis/dotfiles.git ~/dotfiles
```

### 3. Stow the Configs
Navigate into the dotfiles directory and use `stow` to automatically create the symlinks in your home directory:

```bash
cd ~/dotfiles
stow nvim zsh kitty
```

That's it! Restart your terminal and everything will be active.

## ✨ Highlights & Architecture

* **Portable Zsh Environment:** `ZDOTDIR` is automatically set in `~/.zshenv`, which cleanly routes all zsh configurations into `~/.config/zsh`. No more home folder clutter!
* **Logical PATH Management:** All `PATH` variables are defined as a unique Zsh array in `.zshenv` to prevent duplicate path bloat and guarantee execution availability across both the terminal and graphical apps.
* **AppImage Ready:** Automatically adds `~/.local/bin/Apps` to your path for instant execution of downloaded AppImages.

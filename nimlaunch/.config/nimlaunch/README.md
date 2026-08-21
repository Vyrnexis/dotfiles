# NimLaunch Configuration

Personal configuration for my custom application launcher, [NimLaunch](https://github.com/Vyrnexis/NimLaunch), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Features

- **Custom UI:** Positioned dynamically with a customized width, opacity, and borders.
- **Vim Integration:** Optional Vim-mode mappings for navigation.
- **Terminal Fallbacks:** Integrates directly with Kitty for slash commands.
- **Custom Groups:** Configures service, development, system, project, media, and script shortcuts.

## Structure

```
nimlaunch/.config/nimlaunch/
├── nimlaunch.toml    # Main layout, colors, and shortcut configuration
└── scripts/          # Optional dmenu-style integration scripts
```

## Prerequisites

| Tool | Install | Used for |
|------|---------|----------|
| `nimlaunch` | Build from source | The application launcher |
| `JetBrainsMono Nerd Font` | [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) | Custom prompt glyphs |

Individual scripts require the tools named in their file headers. Depending on
the selected shortcuts, these include PipeWire, NetworkManager, BlueZ, Steam,
Hyprland, KDE Klipper, `jq`, `bc`, `grim`, `slurp`, and `wl-copy`.

## Installation

```bash
cd ~/dotfiles
stow nimlaunch
```

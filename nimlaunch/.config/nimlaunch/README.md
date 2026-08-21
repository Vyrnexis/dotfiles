# NimLaunch Configuration

Personal configuration for my custom application launcher, [NimLaunch](https://github.com/Vyrnexis/NimLaunch), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Features

- One-third vertical placement with a ten-item result window.
- JetBrains Mono Nerd Font and selectable color themes.
- Kitty integration for interactive terminal commands.
- Filter groups for cheatsheets, documentation, projects, scripts, screenshots,
  and system actions.
- Pass-through service inspection with `systemctl` and `journalctl`.
- Direct web-search and calculator prefixes.

## Commands

| Input | Action |
|-------|--------|
| `:cheats` | Choose a Helix, Kitty, or Neovim cheatsheet |
| `:docs` | Choose Nim, Go, Python, or Free Pascal documentation |
| `:scripts` | Open desktop and hardware integration tools |
| `:sys` | Lock, suspend, log out, reboot, or shut down |
| `:svc <unit>` | Inspect a systemd service |
| `:proj` | Open a configured project directory |
| `:ss` | Capture an area or full-screen screenshot |
| `:g`, `:w`, `:y` | Search Google, Wikipedia, or YouTube |
| `:gh`, `:aw`, `:man` | Search GitHub, Arch Wiki, or manual pages |
| `:m` | Calculate an expression and copy the result |

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
| `kitty` | Package manager | Interactive terminal actions |
| `JetBrainsMono Nerd Font` | [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) | Launcher text |

Individual scripts require the tools named in their file headers. Depending on
the selected shortcuts, these include PipeWire, NetworkManager, BlueZ, Steam,
Hyprland, KDE Klipper, `jq`, `bc`, `grim`, `slurp`, and `wl-copy`.

The `:t` theme selector writes the selected theme to `[theme].last_chosen`.
Because this file is linked from the repository, selecting a theme modifies the
tracked configuration.

## Installation

```bash
cd ~/dotfiles
stow nimlaunch
```

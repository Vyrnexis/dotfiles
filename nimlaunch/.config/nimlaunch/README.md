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
- Self-contained script plugins that can be copied, shared, and registered in
  the launcher configuration.

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
└── scripts/
    ├── README.md     # Plugin interface and authoring guide
    └── *.sh          # Optional dmenu-style integration plugins
```

## Prerequisites

| Tool | Install | Used for |
|------|---------|----------|
| `nimlaunch` | Build from source | The application launcher |
| `kitty` | Package manager | Interactive terminal actions |
| `JetBrainsMono Nerd Font` | [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) | Launcher text |

Each plugin checks its own requirements and reports missing commands. Depending
on the selected plugins, these include PipeWire, NetworkManager, BlueZ, Steam,
Hyprland, KDE Klipper, `jq`, `bc`, `grim`, `slurp`, and `wl-copy`. Calculator
results are still shown when the optional `wl-copy` command is unavailable.

The clipboard plugin automatically uses `cliphist` with `wl-copy` when they are
available, otherwise it uses KDE Klipper through `busctl`. Wi-Fi passwords are
requested through `zenity` or `kdialog` so they are not shown in NimLaunch.

The `:t` theme selector writes the selected theme to `[theme].last_chosen`.
Because this file is linked from the repository, selecting a theme modifies the
tracked configuration.

## Installation

```bash
cd ~/dotfiles
stow nimlaunch
```

See [scripts/README.md](scripts/README.md) to create, register, and share a
plugin.

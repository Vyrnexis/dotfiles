# Kitty Configuration

Personal [Kitty](https://sw.kovidgoyal.net/kitty/) terminal configuration, managed with [GNU Stow](https://www.gnu.org/software/stow/).

**Theme:** Dracula · **Font:** JetBrainsMono Nerd Font · **Opacity:** 1.0

## Features

- **Performance Tuned:** Prioritizes keyboard input over rendering frame rate for maximum snappiness.
- **Clean UI:** Padding around the edges, hidden title bars, and slanted powerline tabs.
- **No Annoyances:** Suppressed OS close confirmation warnings.

## Prerequisites

| Tool/Font | Install | Used for |
|-----------|---------|----------|
| `kitty` | Package manager | The terminal emulator |
| `JetBrainsMono Nerd Font` | [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) | Displaying text and icons correctly |

## Installation

```bash
cd ~/dotfiles
stow kitty
```

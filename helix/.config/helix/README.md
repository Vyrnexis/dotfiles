# Helix Configuration

Personal [Helix](https://helix-editor.com/) editor configuration for **v25.07**, managed with [GNU Stow](https://www.gnu.org/software/stow/).

**Theme:** Catppuccin Mocha · **Statusline:** Mode / VCS / Diagnostics · **Auto-save:** On focus-lost + 5 s delay

## Structure

```
helix/.config/helix/
├── config.toml          # Editor settings, theme & keybindings
├── languages.toml       # Language servers & per-language config
└── themes/              # Custom Catppuccin theme overrides
    ├── default/
    └── no_italics/
```

## Prerequisites

| Tool | Install | Used for |
|------|---------|----------|
| `helix` (≥ 25.07) | Package manager / source | The editor |
| `nimlangserver` | `nimble install nimlangserver` | Nim LSP |
| `gopls` | `go install golang.org/x/tools/gopls@latest` | Go LSP |
| `pylsp` | `pip install python-lsp-server` | Python LSP |
| `rust-analyzer` | `rustup component add rust-analyzer` | Rust LSP |
| `pasls` | [pascal-language-server](https://github.com/castle-engine/pascal-language-server) | Pascal LSP |
| `uwu_colors` | `cargo install uwu_colors` | Inline color display LSP |
| `taplo` | `cargo install taplo-cli` | TOML LSP |
| `yazi` | Package manager | Terminal file picker |
| `lazygit` | Package manager | Git TUI |

## Installation

```bash
cd ~/dotfiles
stow helix
```

To verify:

```bash
hx --health
```

## Keybindings

### Helix Essentials

These are the most important built-in Helix keys. Helix uses a modal editing model similar to Vim/Kakoune.

#### Modes

| Key | Action |
|-----|--------|
| `i` | Enter **Insert** mode (before cursor) |
| `a` | Enter **Insert** mode (after cursor) |
| `v` | Enter **Select** mode |
| `Esc` | Return to **Normal** mode |

#### Movement

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Left / Down / Up / Right |
| `w` / `b` | Next / previous word |
| `e` | End of word |
| `f`_char_ / `t`_char_ | Find / till character |
| `gg` | Go to start of file |
| `ge` | Go to end of file |
| `Ctrl-u` / `Ctrl-d` | Half-page up / down |

#### Editing

| Key | Action |
|-----|--------|
| `d` | Delete selection |
| `c` | Change selection (delete + insert) |
| `y` | Yank (copy) |
| `p` / `P` | Paste after / before |
| `u` / `U` | Undo / Redo |
| `>` / `<` | Indent / Dedent |
| `~` | Toggle case |
| `J` | Join lines |

#### Selection

| Key | Action |
|-----|--------|
| `x` | Select entire line |
| `X` | Extend line above |
| `s` | Select regex matches within selection |
| `;` | Collapse selection to cursor |
| `Alt-;` | Flip selection direction |
| `C` | Copy selection to next line |
| `Alt-C` | Copy selection to previous line |

#### Search

| Key | Action |
|-----|--------|
| `/` | Search forward |
| `?` | Search backward |
| `n` / `N` | Next / previous match |

#### Space Menu (Leader)

| Key | Action |
|-----|--------|
| `Space` `f` | File picker |
| `Space` `b` | Buffer picker |
| `Space` `s` | Symbol picker (LSP or tree-sitter) |
| `Space` `a` | Code action |
| `Space` `r` | Rename symbol |
| `Space` `k` | Show docs for item under cursor |
| `Space` `d` | Show diagnostics |
| `Space` `y` / `p` | Yank / paste to system clipboard |
| `Space` `/` | Global search |
| `Space` `?` | Command palette |

#### Goto Menu

| Key | Action |
|-----|--------|
| `g` `d` | Go to definition |
| `g` `r` | Go to references |
| `g` `i` | Go to implementation |
| `g` `t` | Go to type definition |
| `g` `a` | Go to last accessed file |
| `g` `h` / `g` `l` | Go to line start / end |

#### Match Menu

| Key | Action |
|-----|--------|
| `m` `m` | Match bracket pair |
| `m` `s` _char_ | Surround selection with character |
| `m` `r` _old_ _new_ | Replace surrounding character |
| `m` `d` _char_ | Delete surrounding character |

#### Window Management

| Key | Action |
|-----|--------|
| `Ctrl-w` `s` / `v` | Horizontal / vertical split |
| `Ctrl-w` `h` `j` `k` `l` | Focus split |
| `Ctrl-w` `q` | Close split |

#### Commands

| Command | Action |
|---------|--------|
| `:w` | Write file |
| `:q` | Quit |
| `:wq` | Write & quit |
| `:q!` | Force quit |
| `:theme` _name_ | Switch theme |
| `:config-open` | Open config.toml |
| `:config-reload` | Reload config |
| `:lsp-restart` | Restart language server |
| `:tutor` | Open the built-in tutorial |

---

### Custom Keybindings

These are the keybindings defined in this config on top of Helix defaults.

#### Normal Mode

| Key | Action | Notes |
|-----|--------|-------|
| `Ctrl-s` | Save file | Works in insert mode too |
| `Ctrl-q` | Quit | |
| `Ctrl-h` | Previous buffer | |
| `Ctrl-l` | Next buffer | |
| `Ctrl-e` | Open **Superfile (spf)** file picker | Opens spf in current file's directory |
| `Ctrl-g` | Open **Lazygit** | Full git TUI inside Helix |
| `X` | Extend line above | Complement to `x` (select line below) |
| `Esc` | Collapse + keep primary | Clears multi-cursor back to one |

#### Vim-Style Motions

| Key | Action |
|-----|--------|
| `%` | Match brackets |
| `*` | Search word under cursor (forward) |
| `#` | Search word under cursor (backward) |
| `$` | Go to end of line |
| `0` | Go to start of line |
| `G` | Go to end of file |

#### Space Menu (Custom)

| Key | Action |
|-----|--------|
| `Space` `e` | Open file explorer (workspace root) |
| `Space` `E` | Open file explorer (current file's directory) |

## Language Servers

| Language | Server | Features |
|----------|--------|----------|
| Nim | `nimlangserver` | Completions, diagnostics, go-to-def |
| Go | `gopls` | Full LSP + inlay hints (types, params, etc.) |
| Python | `pylsp` | Completions, diagnostics, formatting |
| Rust | `rust-analyzer` | Full LSP + `clippy` as check command |
| Pascal | `pasls` | Completions, diagnostics |
| TOML | `taplo` | Validation, formatting |
| CSS / HTML | `vscode-*-language-server` | Standard web LSP |
| _All above_ | `uwu_colors` | Inline color swatches for hex/rgb values |

## Auto-Format

Auto-format on save is **enabled** for: Nim, Go, Python, Rust, Pascal, CSS, HTML, TOML, JSON.

Disabled for: Markdown, Bash (to avoid unwanted reformatting).

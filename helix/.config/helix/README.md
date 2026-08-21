# Helix Configuration

Personal configuration for Helix 25.07 with the experimental Steel plugin
system, managed with GNU Stow.

## Features

- Catppuccin Mocha theme, relative line numbers, soft wrapping, indent guides,
  rainbow brackets, inline diagnostics, and Wayland clipboard support.
- Delayed and focus-lost auto-save.
- Language tooling for Nim, Go, Python, Rust, Pascal, Bash, Markdown, TOML,
  JSON, CSS, and HTML.
- Superfile picker and Lazygit terminal integrations.
- CodeSnap and Yank Flash Steel plugins.

## Structure

```text
helix/.config/helix/
├── config.toml
├── languages.toml
├── helix.scm
├── init.scm
└── themes/
    └── yank_flash/
```

- `config.toml` contains editor settings and keybindings.
- `languages.toml` contains language servers and per-language overrides.
- `helix.scm` exports and configures Steel commands.
- `init.scm` loads plugins that register hooks at startup.
- `themes/yank_flash` contains the temporary theme used for yank feedback.

## Helix Runtime

The Steel plugin system requires a Steel-enabled Helix build. On this machine,
the checkout is located at `~/Projects/Rust/helix`.

The Zsh package conditionally exports:

```bash
HELIX_RUNTIME="$HOME/Projects/Rust/helix/runtime"
```

The variable is only set when that directory exists. This avoids storing an
absolute runtime symlink inside the Stow package and lets other machines use the
runtime bundled with their Helix installation.

## Installation

```bash
cd ~/dotfiles
stow helix zsh
```

Start a new shell after Stowing so `HELIX_RUNTIME` is available, then verify the
configuration:

```bash
hx --health
```

## Steel Plugins

Install the configured plugins with Steel's `forge` package manager:

```bash
forge pkg install --git https://github.com/Vyrnexis/codesnap.hx.git
forge pkg install --git https://github.com/dmyyy/yank-flash.hx.git
```

### CodeSnap

CodeSnap turns the current selection into an image using `silicon`. It is
configured for KDE Wayland with `wl-copy`:

```text
:codesnap
:codesnap-menu
:codesnap ~/Pictures/example.png
```

Required commands: `silicon` and `wl-copy`.

### Yank Flash

Yank Flash briefly switches to the generated `yank_flash` theme after a yank.
It is loaded from `init.scm` and requires the `yank-flash` Steel package.

## Custom Keybindings

| Key | Action |
|-----|--------|
| `Ctrl-s` | Save in normal or insert mode |
| `Ctrl-q` | Quit |
| `Ctrl-h` / `Ctrl-l` | Previous or next buffer |
| `Ctrl-e` | Select a file through Superfile |
| `Ctrl-g` | Open Lazygit in a detached Kitty window |
| `Space e` | Open the workspace file explorer |
| `Space E` | Open the current directory file explorer |
| `X` | Extend the selection one line upward |
| `%` | Match brackets |
| `*` / `#` | Search for the current word forward or backward |
| `$` / `0` | Move to the end or start of the line |
| `G` | Move to the end of the file |

The Superfile integration uses a chooser file scoped to the current Helix
process, preventing collisions between concurrent editor sessions.

## Language Tooling

| Language | Server | Formatter or checks |
|----------|--------|---------------------|
| Nim | `nimlsp`, `uwu_colors` | `nimpretty` |
| Go | `gopls`, `uwu_colors` | `gopls` formatting |
| Python | `pylsp`, `uwu_colors` | Available through installed pylsp plugins |
| Rust | `rust-analyzer`, `uwu_colors` | rust-analyzer and Clippy |
| Pascal | `pasls`, `uwu_colors` | Available through Pascal LSP capabilities |
| Bash | `bash-language-server` | Formatting disabled |
| Markdown | `marksman` | Formatting disabled |
| TOML | `taplo` | Taplo formatting |
| CSS | `vscode-css-language-server`, `uwu_colors` | LSP formatting |
| HTML | `vscode-html-language-server`, `uwu_colors` | LSP formatting |
| JSON | `vscode-json-language-server` | LSP formatting |

Rust being installed does not automatically provide `rust-analyzer`; it must be
installed separately.

On Solus, install the remaining language tools with:

```bash
sudo eopkg install marksman
npm install --global --prefix "$HOME/.local" bash-language-server
cargo install --git https://github.com/rust-lang/rust-analyzer.git --locked rust-analyzer
```

The active Pascal server is maintained at
[genericptr/pascal-language-server](https://github.com/genericptr/pascal-language-server).
It does not publish prebuilt GitHub releases and must be built for Linux using
Free Pascal and Lazarus. A macOS Mach-O build cannot run on Linux.

## External Tools

| Tool | Purpose |
|------|---------|
| `kitty` | Detached Lazygit terminal |
| `lazygit` | Git interface |
| `spf` | Superfile chooser |
| `forge` | Steel package manager |
| `silicon` | CodeSnap image renderer |
| `wl-copy` and `wl-paste` | Wayland clipboard integration |

## Diagnostics

Check a specific language integration with:

```bash
hx --health nim
hx --health go
hx --health bash
hx --health markdown
```

Helix reports command availability, runtime queries, formatter configuration,
and debugger availability for each language.

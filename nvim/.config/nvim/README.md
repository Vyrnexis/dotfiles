# Minimalist Neovim 0.12+ Configuration

Welcome to this hyper-minimal, lightning-fast Neovim configuration. It is built strictly for Neovim 0.12+ and strictly adheres to a **zero third-party plugin manager** philosophy. It uses Neovim's built-in APIs and tools to accomplish what usually takes dozens of plugins.

## Features & Modifications

- **Native Package Management:** Uses the brand new Neovim 0.12 `vim.pack.add` feature to install `nvim-treesitter` natively. No `lazy.nvim` or `packer` required.
- **Asynchronous Git Statusline:** A custom, 100% pure Lua statusline that asynchronously fetches Git branch and repository information without blocking the UI.
- **Blazing Fast File Finder:** The native `:find` command is overridden to use `rg` (ripgrep) under the hood, traversing huge projects instantly while respecting `.gitignore`.
- **Auto-Formatting:** Automatically formats files on save (`BufWritePre`) using lightweight CLI tools or falling back to the LSP.
- **Enhanced Netrw:** Replaces the clunky default Netrw file creation with a custom `%` mapping that smoothly creates files in the correct split buffer.

---

## Keybindings

Your leader key is set to **Space** (`<Space>`).

### General

| Keymap           | Action                         |
| ---------------- | ------------------------------ |
| `<Leader>w`      | Save file                      |
| `<Leader>q`      | Quit                           |
| `U`              | Redo (Undo is the default `u`) |
| `<Ctrl-h/j/k/l>` | Navigate between split windows |

### Navigation & Search

| Keymap      | Action                                                                      |
| ----------- | --------------------------------------------------------------------------- |
| `<Leader>e` | Toggle the file explorer (Netrw) on the left side                           |
| `<Leader>f` | Fuzzy find files (`rg` backed)                                              |
| `<Leader>g` | Grep text globally across the project (prompts for pattern, opens quickfix) |
| `<Leader>d` | Open project diagnostics/errors in a quickfix window                        |

### File Explorer (Netrw specific)

| Keymap | Action                                                                |
| ------ | --------------------------------------------------------------------- |
| `%`    | Create a new file or directory (creates in the previous split window) |

---

## Language Support & Dependencies

This configuration supports full Language Server (LSP) intelligence, auto-formatting, and Treesitter syntax highlighting for the following languages.

Because we rely on standard command-line tools rather than heavy Neovim wrappers, **you must ensure these programs are installed on your machine and their binary folders are added to your `$PATH`**.

> [!IMPORTANT]
> **System PATH Requirements**
> If you install tools using package managers like `cargo`, `go`, or `nimble`, their binaries are not always added to your system path by default. You must add them manually to your shell configuration (e.g. `~/.zshenv`, `~/.bashrc`, or `~/.profile`):
>
> ```bash
> export PATH="$HOME/.cargo/bin:$PATH"
> export PATH="$HOME/go/bin:$PATH"
> export PATH="$HOME/.nimble/bin:$PATH"
> ```

### Core Requirements (Required)

- **[Tree-sitter CLI](https://tree-sitter.github.io/tree-sitter/):** Required to compile syntax parsers.
  - Install: `cargo install tree-sitter-cli`
- **[Ripgrep (`rg`)](https://github.com/BurntSushi/ripgrep):** Required for the custom file finder and global grep.
  - Install: `sudo eopkg install ripgrep` (or OS equivalent)

### Languages

#### Python

- **LSP:** `pyright`
- **Formatter:** `black`
- **Install:** `pip install pyright black`

#### Go

- **LSP & Formatter:** `gopls`
- **Install:** `go install golang.org/x/tools/gopls@latest`

#### Nim

- **LSP & Formatter:** `nimlsp`
- **Install:** `nimble install nimlsp`

#### Pascal / Delphi

- **LSP:** `pasls` (Pascal Language Server)
- **Install:** Build from source via [genericptr/pascal-language-server](https://github.com/genericptr/pascal-language-server)

#### Lua (Neovim Configs)

- **LSP:** `lua-language-server`
- **Formatter:** `stylua`
- **Install:**
  ```bash
  # Download StyLua binary directly (much faster than cargo install)
  curl -sL https://github.com/JohnnyMorganz/StyLua/releases/download/v2.5.2/stylua-linux-x86_64.zip -o /tmp/stylua.zip
  unzip -o /tmp/stylua.zip -d ~/.local/bin/

  # Download LuaLS
  mkdir -p ~/.local/share/lua-language-server
  curl -sL https://github.com/LuaLS/lua-language-server/releases/download/3.19.0/lua-language-server-3.19.0-linux-x64.tar.gz | tar -xz -C ~/.local/share/lua-language-server
  ln -sf ~/.local/share/lua-language-server/bin/lua-language-server ~/.local/bin/lua-language-server
  ```

#### JSON, TOML, and Markdown

- **JSON Formatter:** `jq` (Usually pre-installed on Linux)
- **TOML Formatter:** `taplo` (`cargo install taplo-cli`)
- **Markdown Formatter:** `prettier` (`npm install -g prettier`)

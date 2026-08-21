# Zsh Configuration

Personal Zsh configuration for Solus and KDE, managed with GNU Stow.

## Features

- XDG-based configuration under `~/.config/zsh`.
- Consistent user-tool PATH in normal and login shells.
- Durable history, cached completion, and case-insensitive completion matching.
- Vi mode, autosuggestions, substring history search, and syntax highlighting.
- FZF file selection with `fd` and `bat`, plus a portable `find` fallback.
- Catppuccin Mocha Starship prompt.
- Zoxide directory navigation and a Superfile directory-changing wrapper.
- Nymph system summary in top-level interactive terminal sessions.
- Local Steel-enabled Helix runtime when its source checkout is available.

## Structure

```text
zsh/.config/zsh/
├── .zshenv
├── .zprofile
├── .zshrc
├── aliases.zsh
├── bindings.zsh
├── fzf.zsh
├── path.zsh
├── plugins.zsh
├── prompt.zsh
├── starship.toml
└── plugins/
```

- `.zshenv` defines XDG paths and environment variables for every Zsh process.
- `.zprofile` reapplies user paths after Solus initializes a login shell.
- `.zshrc` configures interactive history, completion, integrations, and Nymph.
- `path.zsh` is the shared, duplicate-free PATH definition.
- `plugins/` contains pinned Git submodules.

## Requirements

| Command | Purpose |
|---------|---------|
| `zsh` | Shell |
| `git` | Plugin submodules and dotfile commands |
| `starship` | Prompt |
| `zoxide` | Directory navigation |
| `eza` | Listing aliases |
| `fzf` | Interactive file selection and completion |
| `fd` | Fast file discovery for FZF |
| `bat` | FZF previews and manual-page rendering |
| `spf` | Superfile terminal file manager |
| `nymph` | Optional top-level system summary |

`bat` and `rg` retain their normal command names and behavior; this configuration
does not replace `cat` or `grep` with aliases.

## Installation

Solus reads `/etc/zsh/zshenv` before user startup files. Configure it to select
the XDG Zsh directory:

```zsh
if [[ -z "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
```

Clone the repository with its pinned plugins and Stow the package:

```bash
git clone --recurse-submodules git@github-vyrnexis:Vyrnexis/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh
```

For an existing checkout:

```bash
git submodule update --init --recursive
stow zsh
```

## PATH Behavior

Solus resets PATH from its global `zprofile` after `.zshenv` has run. Both
`.zshenv` and `.zprofile` source `path.zsh`, ensuring these directories remain
available in every startup mode:

```text
~/.local/bin
~/.local/bin/Apps
~/.cargo/bin
~/go/bin
~/.nimble/bin
~/.local/share/grabnim/current/bin
~/.opencode/bin
~/.steel/bin
```

If `~/Projects/Rust/helix/runtime` exists, `.zshenv` exports it as
`HELIX_RUNTIME` for the local Steel-enabled Helix build.

## Commands and Bindings

| Command or key | Action |
|----------------|--------|
| `sf` | Open Superfile and change to its last directory on exit |
| `zplugin-update` | Update the pinned plugin submodules |
| `dotfiles` | Run Git in `~/dotfiles` |
| `Ctrl-F` | Insert a non-hidden file selected through FZF |
| `Ctrl-T` | Use the standard FZF file widget |
| `Ctrl-Left` / `Ctrl-Right` | Move backward or forward one word |
| `Ctrl-\\` | Toggle autosuggestions |
| `Up` / `Down` | Search history by substring |

FZF results are shell-escaped before insertion, so filenames containing spaces
or shell metacharacters remain valid.

## Plugin Management

The plugin submodules are the source of truth. Shell startup never downloads or
updates code automatically.

Update them explicitly, inspect the changed revisions, and commit the resulting
submodule pointers:

```bash
zplugin-update
git diff --submodule
```

## Generated Caches

Zoxide and Starship initialization scripts are cached under
`$XDG_CACHE_HOME/zsh`. Each cache is rebuilt automatically when its executable
is newer than the generated script.

## History

History is stored at `$XDG_STATE_HOME/zsh/history`. Completed commands are
written immediately with timestamps and file locking, so closing or crashing a
terminal does not discard the rest of the session.

Commands beginning with a space are retained. Existing shells do not import new
entries from other open shells in real time; newly opened shells load everything
already written to the history file.

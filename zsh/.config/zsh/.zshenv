# ---------- ZSH Directory ----------

# ---------- XDG base directories ----------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

# ----------- Editor -----------
export EDITOR="hx"
export VISUAL="hx"

# ---------- Dotfiles ----------
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# ---------- Pager ----------
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
  export MANPAGER="batcat -l man -p"
fi

# ---------- GPG ----------
if [[ -t 0 ]]; then
  export GPG_TTY="$(tty)"
fi

# ---------- Starship ----------
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"

# ------------- Paths ---------
typeset -U PATH path # Ensure no duplicates in PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.local/bin/Apps"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/.nimble/bin"
  "$HOME/.local/share/grabnim/current/bin"
  "$HOME/.opencode/bin"
  "$HOME/.steel/bin"
  $path
)
export PATH

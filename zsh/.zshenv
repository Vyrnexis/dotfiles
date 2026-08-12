# ---------- ZSH Directory ----------
export ZDOTDIR="$HOME/.config/zsh"

# ---------- XDG base directories ----------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ----------- Editor -----------
export EDITOR="vim"
export VISUAL="kate"

# ---------- Pager ----------
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
  export MANPAGER="batcat -l man -p"
fi

# ---------- GPG ----------
export GPG_TTY=$(tty)

# ---------- Starship ----------
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"

# ------------- Paths ---------
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin/Apps:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/grabnim/current/bin:$PATH"
export PATH="$HOME/.nimble/bin:$PATH"

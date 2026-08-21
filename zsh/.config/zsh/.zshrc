# ----------- History -----------
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}" "$XDG_CACHE_HOME/zsh"

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# ------------- Shell -------------
setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

# -------------- Init Zoxide --------
if command -v zoxide >/dev/null 2>&1 && [[ ! -s "$XDG_CACHE_HOME/zsh/zoxide.zsh" ]]; then
  zoxide init zsh > "$XDG_CACHE_HOME/zsh/zoxide.zsh"
fi
[[ -r "$XDG_CACHE_HOME/zsh/zoxide.zsh" ]] && source "$XDG_CACHE_HOME/zsh/zoxide.zsh"

# ------------- Completion --------
autoload -Uz compinit
# Cache compinit: only run security checks if the dump file is older than 24 hours
if [[ -n $(find "$XDG_CACHE_HOME/zsh/zcomdump" -mtime +1 2>/dev/null) ]] || [[ ! -f "$XDG_CACHE_HOME/zsh/zcomdump" ]]; then
  compinit -d "$XDG_CACHE_HOME/zsh/zcomdump"
else
  compinit -C -d "$XDG_CACHE_HOME/zsh/zcomdump"
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ------------- Fuzzy Finder -------
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
fi

# ------- Fzf Config -------
source "$ZDOTDIR/fzf.zsh"

# ------- Alias ------
source "$ZDOTDIR/aliases.zsh"

# ------- Keybinds ------
source "$ZDOTDIR/bindings.zsh"

# ------- Plugins ------
source "$ZDOTDIR/plugins.zsh"

# -------- Prompt / Theme -------
source "$ZDOTDIR/prompt.zsh"


if command -v nymph >/dev/null 2>&1; then
  nymph
fi


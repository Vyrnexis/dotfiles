# ----------- History -----------
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}" "$XDG_CACHE_HOME/zsh"

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# ------------- Shell -------------
setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

# -------------- Init Zoxide --------
if (( $+commands[zoxide] )); then
  zoxide_cache="$XDG_CACHE_HOME/zsh/zoxide.zsh"
  if [[ ! -s "$zoxide_cache" || "$commands[zoxide]" -nt "$zoxide_cache" ]]; then
    zoxide_cache_temp="${zoxide_cache}.${ZSH_PID}"
    if zoxide init zsh >| "$zoxide_cache_temp"; then
      mv -f "$zoxide_cache_temp" "$zoxide_cache"
    else
      rm -f "$zoxide_cache_temp"
    fi
  fi
  [[ -r "$zoxide_cache" ]] && source "$zoxide_cache"
  unset zoxide_cache zoxide_cache_temp
fi

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
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
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

if (( SHLVL == 1 )) && [[ -t 1 ]] && (( $+commands[nymph] )); then
  nymph
fi

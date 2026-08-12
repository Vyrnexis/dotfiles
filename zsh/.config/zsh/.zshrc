# ----------- History -----------
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

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
eval "$(zoxide init zsh)"

# ------------- Completion --------
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcomdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ------------- Fuzzy Finder -------
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
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

nymph



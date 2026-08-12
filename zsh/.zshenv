# ---------- ZSH Directory ----------
# This loader ensures that on non-Solus distros, Zsh still finds the config
export ZDOTDIR="$HOME/.config/zsh"

if [[ -f "$ZDOTDIR/.zshenv" ]]; then
    source "$ZDOTDIR/.zshenv"
fi

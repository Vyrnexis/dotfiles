# ~/.config/zsh/prompt.zsh

# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

FUNCNEST=100

if command -v starship >/dev/null 2>&1 && [[ ! -s "$XDG_CACHE_HOME/zsh/starship.zsh" ]]; then
  starship init zsh > "$XDG_CACHE_HOME/zsh/starship.zsh"
fi
[[ -r "$XDG_CACHE_HOME/zsh/starship.zsh" ]] && source "$XDG_CACHE_HOME/zsh/starship.zsh"

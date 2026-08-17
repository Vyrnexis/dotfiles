# ~/.config/zsh/prompt.zsh

# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

FUNCNEST=100

if [[ ! -f "$XDG_CACHE_HOME/zsh/starship.zsh" ]]; then
  mkdir -p "$XDG_CACHE_HOME/zsh"
  starship init zsh > "$XDG_CACHE_HOME/zsh/starship.zsh"
fi
source "$XDG_CACHE_HOME/zsh/starship.zsh"

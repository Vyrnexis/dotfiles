# ~/.config/zsh/prompt.zsh

# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

if (( $+commands[starship] )); then
  starship_cache="$XDG_CACHE_HOME/zsh/starship.zsh"
  if [[ ! -s "$starship_cache" || "$commands[starship]" -nt "$starship_cache" ]]; then
    starship_cache_temp="${starship_cache}.${ZSH_PID}"
    if starship init zsh >| "$starship_cache_temp"; then
      mv -f "$starship_cache_temp" "$starship_cache"
    else
      rm -f "$starship_cache_temp"
    fi
  fi
  [[ -r "$starship_cache" ]] && source "$starship_cache"
  unset starship_cache starship_cache_temp
fi

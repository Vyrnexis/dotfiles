# =========================================================
# fzf
# =========================================================

if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --strip-cwd-prefix'
else
  export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/.git/*' -print"
fi

# Ctrl-T uses the selected discovery command.
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# UI
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'

export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 -- {}'
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

# Ctrl+F: file picker excluding hidden files
_fzf_file_no_hidden() {
  local result
  if (( $+commands[fd] )); then
    result="$(fd --type f --strip-cwd-prefix | fzf --preview "$_FZF_PREVIEW_CMD")"
  else
    result="$(find . -type f -not -path '*/.*' -print | fzf --preview "$_FZF_PREVIEW_CMD")"
  fi
  [[ -n "$result" ]] && LBUFFER+="${(q)result}"
  zle reset-prompt
}
zle -N _fzf_file_no_hidden

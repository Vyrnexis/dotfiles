# Keep user-installed tools ahead of system executables without duplicates.
typeset -U PATH path
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

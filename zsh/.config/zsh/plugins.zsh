# =========================================================
# Plugins
# =========================================================

ZPLUGINDIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins"

# Loads a plugin from its pinned Git submodule.
_zplugin_load() {
  local plugin_name="$1"
  local plugin_file="${ZPLUGINDIR}/${plugin_name}/${plugin_name}.plugin.zsh"
  if [[ ! -r "$plugin_file" ]]; then
    print -u2 "Missing Zsh plugin: ${plugin_name}"
    print -u2 "Run: git -C ${DOTFILES_DIR} submodule update --init --recursive"
    return 1
  fi
  source "$plugin_file"
}

# Updates pinned plugin submodules to their remote default branches.
zplugin-update() {
  git -C "$DOTFILES_DIR" submodule update --remote --merge --recursive -- \
    zsh/.config/zsh/plugins/fast-syntax-highlighting \
    zsh/.config/zsh/plugins/zsh-autosuggestions \
    zsh/.config/zsh/plugins/zsh-history-substring-search \
    zsh/.config/zsh/plugins/zsh-vi-mode
}

_zplugin_load zsh-autosuggestions
_zplugin_load zsh-history-substring-search
_zplugin_load zsh-vi-mode
_zplugin_load fast-syntax-highlighting

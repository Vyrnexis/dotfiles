#!/usr/bin/env bash
# kitty-cheatsheet — Quick reference for Kitty Terminal keybindings & features

set -euo pipefail

if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
  BOLD=$(tput bold); RESET=$(tput sgr0)
  C1=$(tput setaf 6); C2=$(tput setaf 2)
else
  BOLD=""; RESET=""; C1=""; C2=""
fi

# Opens less with color support and compact-screen behavior.
pager() {
  LESS=${LESS:-"-RFXS"}
  exec less -R
}

cat <<EOF | sed 's/^ *//' | pager

${BOLD}${C1}KITTY TERMINAL CHEATSHEET${RESET}
Tip: Press ${BOLD}/pattern${RESET} to search inside this sheet.

${BOLD}${C2}BASICS${RESET}
  New window (tab)        : ${BOLD}Ctrl+Shift+Enter${RESET}
  Close window            : ${BOLD}Ctrl+Shift+W${RESET}
  Quit Kitty              : ${BOLD}Ctrl+Shift+Q${RESET}
  New tab                 : ${BOLD}Ctrl+Shift+T${RESET}
  Close tab               : ${BOLD}Ctrl+Shift+Alt+W${RESET}
  Next / Previous tab     : ${BOLD}Ctrl+Shift+]${RESET} / ${BOLD}Ctrl+Shift+[${RESET}
  Rename tab              : ${BOLD}Ctrl+Shift+Alt+T${RESET}
  Go to tab (by number)   : ${BOLD}Ctrl+Shift+N${RESET}

${BOLD}${C2}WINDOW LAYOUT & NAVIGATION${RESET}
  Split horizontally      : ${BOLD}Ctrl+Shift+S${RESET}
  Split vertically        : ${BOLD}Ctrl+Shift+D${RESET}
  Move between splits     : ${BOLD}Ctrl+Shift+← ↑ ↓ →${RESET}
  Resize split            : ${BOLD}Ctrl+Shift+Alt+← ↑ ↓ →${RESET}
  Close active split      : ${BOLD}Ctrl+Shift+W${RESET}

${BOLD}${C2}TEXT & CLIPBOARD${RESET}
  Copy to clipboard       : ${BOLD}Ctrl+Shift+C${RESET}
  Paste from clipboard    : ${BOLD}Ctrl+Shift+V${RESET}
  Paste from selection    : ${BOLD}Ctrl+Shift+Ins${RESET}
  Search scrollback       : ${BOLD}Ctrl+Shift+F${RESET}
  Open URL under cursor   : ${BOLD}Ctrl+Shift+E${RESET}
  Copy command output     : ${BOLD}Ctrl+Shift+O${RESET}
  Clear scrollback buffer : ${BOLD}Ctrl+Shift+L${RESET}

${BOLD}${C2}SCROLLING${RESET}
  Scroll up / down        : ${BOLD}Shift+PageUp${RESET} / ${BOLD}Shift+PageDown${RESET}
  Half page up / down     : ${BOLD}Ctrl+Shift+PageUp${RESET} / ${BOLD}Ctrl+Shift+PageDown${RESET}
  Jump to top / bottom    : ${BOLD}Ctrl+Shift+Home${RESET} / ${BOLD}Ctrl+Shift+End${RESET}

${BOLD}${C2}FONT & ZOOM${RESET}
  Increase font size      : ${BOLD}Ctrl+Shift+=${RESET}
  Decrease font size      : ${BOLD}Ctrl+Shift+-${RESET}
  Reset font size         : ${BOLD}Ctrl+Shift+Backspace${RESET}

${BOLD}${C2}WINDOW ACTIONS${RESET}
  Detach window (tab)     : ${BOLD}Ctrl+Shift+Alt+D${RESET}
  Move window to new tab  : ${BOLD}Ctrl+Shift+M${RESET}
  Reorder windows/tabs    : ${BOLD}Ctrl+Shift+Alt+← →${RESET}

${BOLD}${C2}KITTENS (BUILT-IN TOOLS)${RESET}
  Image viewer            : ${BOLD}kitty +kitten icat${RESET}
  Unicode input picker    : ${BOLD}kitty +kitten unicode_input${RESET}
  Diff viewer             : ${BOLD}kitty +kitten diff${RESET}
  Clipboard manager       : ${BOLD}kitty +kitten clipboard${RESET}
  SSH kitten              : ${BOLD}kitty +kitten ssh user@host${RESET}
  Hyperlink hints         : ${BOLD}kitty +kitten hints${RESET}

${BOLD}${C2}THEMES & CONFIG${RESET}
  Edit config             : ${BOLD}kitty +edit-config${RESET}
  Reload config           : ${BOLD}Ctrl+Shift+F5${RESET}
  List themes             : ${BOLD}kitty +kitten themes${RESET}
  Apply theme             : ${BOLD}kitty +kitten themes --reload-in=all${RESET}

${BOLD}${C2}SESSION MANAGEMENT${RESET}
  Save session layout     : ${BOLD}kitty @ ls > session.json${RESET}
  Restore session         : ${BOLD}kitty --session session.json${RESET}

${BOLD}${C2}COMMAND MODE (REMOTE CONTROL)${RESET}
  List windows            : ${BOLD}kitty @ ls${RESET}
  Focus next tab          : ${BOLD}kitty @ focus-tab --match 1${RESET}
  Close window            : ${BOLD}kitty @ close-window${RESET}
  Send text to window     : ${BOLD}kitty @ send-text "ls -la\\n"${RESET}

${BOLD}${C2}TIPS${RESET}
  - Use ${BOLD}kitty @${RESET} commands to script or automate Kitty actions.
  - Customize shortcuts in ${BOLD}~/.config/kitty/kitty.conf${RESET}.
  - To make changes live, press ${BOLD}Ctrl+Shift+F5${RESET}.

EOF

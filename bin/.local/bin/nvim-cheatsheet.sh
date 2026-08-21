#!/usr/bin/env bash
# nvim-cheatsheet — quick Neovim keymap & commands

set -euo pipefail

if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
  BOLD="$(tput bold)"; DIM="$(tput dim)"; RESET="$(tput sgr0)"
  C1="$(tput setaf 6)"; C2="$(tput setaf 2)"
else
  BOLD=""; DIM=""; RESET=""; C1=""; C2=""
fi

# Opens less with color support and compact-screen behavior.
pager() {
  LESS=${LESS:-"-RFXS"}
  exec less -R
}

cat <<EOF | sed 's/^ *//' | pager

${BOLD}${C1}NEOVIM QUICK CHEATSHEET${RESET}
Tip: Use ${BOLD}/pattern${RESET} to search inside this cheatsheet, ${BOLD}n/N${RESET} to jump between matches.

${BOLD}${C2}CUSTOM LEADER BINDINGS${RESET}  ${DIM}(Leader = Space)${RESET}
  Save file            : ${BOLD}<leader>w${RESET}
  Quit Neovim          : ${BOLD}<leader>q${RESET}
  Toggle Explorer      : ${BOLD}<leader>e${RESET}  (Netrw)
  Fuzzy find files     : ${BOLD}<leader>f${RESET}
  Grep search          : ${BOLD}<leader>g${RESET}
  Show diagnostics     : ${BOLD}<leader>d${RESET}

${BOLD}${C2}CUSTOM NAVIGATION${RESET}
  Window Left          : ${BOLD}Ctrl+h${RESET}
  Window Down          : ${BOLD}Ctrl+j${RESET}
  Window Up            : ${BOLD}Ctrl+k${RESET}
  Window Right         : ${BOLD}Ctrl+l${RESET}
  Redo                 : ${BOLD}U${RESET} (capital U)

${BOLD}${C2}NETRW EXPLORER${RESET}
  Create new file      : ${BOLD}%${RESET} (Custom override)
  Create new dir       : ${BOLD}d${RESET}
  Rename file          : ${BOLD}R${RESET}
  Delete file          : ${BOLD}D${RESET}

${BOLD}${C2}VIM BASICS${RESET}
  Insert mode          : ${BOLD}i${RESET} (before), ${BOLD}a${RESET} (after), ${BOLD}o${RESET} (new line below)
  Normal mode          : ${BOLD}Esc${RESET}
  Undo                 : ${BOLD}u${RESET}
  Visual select        : ${BOLD}v${RESET} (char), ${BOLD}V${RESET} (line), ${BOLD}Ctrl+v${RESET} (block)
  Copy (Yank)          : ${BOLD}y${RESET} (selection), ${BOLD}yy${RESET} (line)
  Paste                : ${BOLD}p${RESET} (after), ${BOLD}P${RESET} (before)
  Delete               : ${BOLD}d${RESET} (selection), ${BOLD}dd${RESET} (line), ${BOLD}x${RESET} (char)

${BOLD}${C2}MOVEMENT${RESET}
  Char/Line            : ${BOLD}h j k l${RESET}
  Start/End line       : ${BOLD}0 ^ $${RESET}
  Words                : ${BOLD}w${RESET}(next), ${BOLD}b${RESET}(back), ${BOLD}e${RESET}(end)
  File start/end       : ${BOLD}gg${RESET} / ${BOLD}G${RESET}
  Page                 : ${BOLD}Ctrl-f${RESET} (down), ${BOLD}Ctrl-b${RESET} (up)

${BOLD}${C2}SEARCH & REPLACE${RESET}
  Search               : ${BOLD}/${RESET}${DIM}pattern${RESET}, ${BOLD}?${RESET}${DIM}pattern${RESET}
  Next / Prev match    : ${BOLD}n${RESET} / ${BOLD}N${RESET}
  Substitute (line)    : ${BOLD}:s/old/new/g${RESET}
  Substitute (global)  : ${BOLD}:%s/old/new/g${RESET}

EOF

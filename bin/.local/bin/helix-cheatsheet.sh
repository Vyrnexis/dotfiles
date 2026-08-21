#!/usr/bin/env bash
# helix-cheatsheet — quick Helix (hx) keymap & commands
# Shows a readable cheatsheet in less with colours, section headers, and search.

set -euo pipefail

# Basic terminal colours (fallback to plain if not a TTY)
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

${BOLD}${C1}HELIX (hx) QUICK CHEATSHEET${RESET}
Tip: Use ${BOLD}/pattern${RESET} to search inside this cheatsheet, ${BOLD}n/N${RESET} to jump between matches.

${BOLD}${C2}MODES${RESET}
  Normal (default)     — do things to text
  Insert               — type text        : ${BOLD}i${RESET} (before), ${BOLD}a${RESET} (after), ${BOLD}o/O${RESET} (new line below/above)
  Select               — operate on selections (often automatic in Helix)
  Leave insert         : ${BOLD}Esc${RESET}

${BOLD}${C2}BASICS${RESET}
  Open command line    : ${BOLD}:${RESET}
  Save / Quit          : ${BOLD}:w${RESET}, ${BOLD}:q${RESET}, ${BOLD}:wq${RESET}, ${BOLD}:q!${RESET}
  Help / Tutor         : ${BOLD}:help${RESET}, ${BOLD}:tutor${RESET}
  Open file            : ${BOLD}:open path${RESET}   (tab-complete)
  Buffers              : ${BOLD}:bnext${RESET}, ${BOLD}:bprev${RESET}, ${BOLD}:buffer NAME${RESET}
  Config / Theme       : ${BOLD}:config-open${RESET}, ${BOLD}:theme THEME${RESET}

${BOLD}${C2}MOVEMENT (NORMAL)${RESET}
  Char/Line            : ${BOLD}h j k l${RESET}
  Start/End line       : ${BOLD}0 ^ $${RESET}
  Words                : ${BOLD}w${RESET}(next), ${BOLD}b${RESET}(back), ${BOLD}e${RESET}(end)
  File start/end       : ${BOLD}gg${RESET}, ${BOLD}G${RESET}
  Page                 : ${BOLD}Ctrl-f${RESET} (down), ${BOLD}Ctrl-b${RESET} (up)
  Match pair           : ${BOLD}%${RESET}
  Find char            : ${BOLD}f${RESET}${DIM}{char}${RESET}, ${BOLD}t${RESET}${DIM}{char}${RESET}, repeat with ${BOLD};${RESET}

${BOLD}${C2}EDITING${RESET}
  Insert               : ${BOLD}i a o O${RESET}
  Delete               : ${BOLD}d${RESET} (selection/line), ${BOLD}x${RESET} (char)
  Change               : ${BOLD}c${RESET} (delete then insert)
  Yank / Paste         : ${BOLD}y${RESET} (copy), ${BOLD}p${RESET} (paste after), ${BOLD}P${RESET} (before)
  Indent / Outdent     : ${BOLD}>${RESET}, ${BOLD}<${RESET}
  Join lines           : ${BOLD}J${RESET}
  Undo / Redo          : ${BOLD}u${RESET} / ${BOLD}Ctrl-r${RESET}
  Comment toggle       : ${BOLD}gc${RESET}
  Format (LSP)         : ${BOLD}= ${RESET}  or  ${BOLD}:format${RESET}

${BOLD}${C2}SELECTIONS & MULTI-CURSORS${RESET}
  Line select          : ${BOLD}V${RESET}
  Expand by object     : ${BOLD}viw${RESET} (word), ${BOLD}vi(${RESET} (inside parens), ${BOLD}va(${RESET} (around)
  Add next match       : ${BOLD}n${RESET} (after a search, adds next)
  Select all matches   : ${BOLD}Alt-a${RESET}  (often ${DIM}Option-a${RESET} on macOS)
  Split/merge cursors  : ${BOLD}s${RESET} / ${BOLD}S${RESET}
  Rectangular block    : ${BOLD}Ctrl-v${RESET} (in many terminals)

${BOLD}${C2}SEARCH & REPLACE${RESET}
  Search forward/back  : ${BOLD}/${RESET}${DIM}pattern${RESET}, ${BOLD}?${RESET}${DIM}pattern${RESET}
  Next / Prev match    : ${BOLD}n${RESET} / ${BOLD}N${RESET}
  Substitute (command) : ${BOLD}:s/old/new/${RESET}     ${DIM} add g for all: ${RESET}${BOLD}:s/old/new/g${RESET}
  Global (buffer)      : ${BOLD}:%s/old/new/g${RESET}

${BOLD}${C2}WINDOWS & TABS${RESET}
  Split horizontal     : ${BOLD}:hsplit${RESET}
  Split vertical       : ${BOLD}:vsplit${RESET}
  Next/Prev window     : ${BOLD}Ctrl-w w${RESET}, ${BOLD}Ctrl-w W${RESET}
  Close window         : ${BOLD}:wclose${RESET}
  New tab / Next       : ${BOLD}:tab-new${RESET}, ${BOLD}:tab-next${RESET}

${BOLD}${C2}GIT (if repo)${RESET}
  Gutter hunk nav      : ${BOLD}]g${RESET} / ${BOLD}[g${RESET}
  Stage/Unstage hunk   : ${BOLD}:git stage-hunk${RESET} / ${BOLD}:git unstage-hunk${RESET}
  Blame                : ${BOLD}:git blame${RESET}
  Diff                 : ${BOLD}:git diff${RESET}

${BOLD}${C2}LSP (LANGUAGE FEATURES)${RESET}
  Hover docs           : ${BOLD}K${RESET}
  Go to definition     : ${BOLD}gd${RESET}
  References           : ${BOLD}gr${RESET}
  Implementation       : ${BOLD}gi${RESET}
  Type definition      : ${BOLD}gD${RESET}
  Rename symbol        : ${BOLD}rn${RESET}
  Code action          : ${BOLD}ca${RESET}
  Diagnostics          : ${BOLD}]d${RESET} / ${BOLD}[d${RESET} (next/prev)

${BOLD}${C2}FILE EXPLORER & MISC${RESET}
  File picker          : ${BOLD}:open${RESET}
  Tree (if enabled)    : ${BOLD}:toggle file-picker${RESET}  ${DIM}(varies by config)${RESET}
  Show keybindings     : ${BOLD}:help keys${RESET}
  Show commands        : ${BOLD}:commands${RESET}

${DIM}Notes:${RESET}
- Helix is modal and selection-oriented (Kakoune-style). Many edits operate on the current selection.
- Some bindings can vary by version/config; for authoritative docs use ${BOLD}:help${RESET}, ${BOLD}:help keys${RESET}, and ${BOLD}:tutor${RESET}.
- Searching this page: press ${BOLD}/${RESET} then type a keyword (e.g. ${BOLD}/LSP${RESET}).

EOF

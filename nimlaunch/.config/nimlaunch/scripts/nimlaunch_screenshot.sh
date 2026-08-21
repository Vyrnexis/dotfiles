#!/usr/bin/env bash
set -euo pipefail

GRIM_BIN="${GRIM_BIN:-grim}"
SLURP_BIN="${SLURP_BIN:-slurp}"
WL_COPY_BIN="${WL_COPY_BIN:-wl-copy}"

# Exits with an actionable message when a required command is unavailable.
require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'nimlaunch_screenshot: required command not found: %s\n' "$command_name" >&2
    exit 127
  fi
}

# Resolves and creates the directory used for saved screenshots.
screenshot_directory() {
  local pictures_directory

  if command -v xdg-user-dir >/dev/null 2>&1; then
    pictures_directory="$(xdg-user-dir PICTURES)"
  else
    pictures_directory="${XDG_PICTURES_DIR:-$HOME/Pictures}"
  fi
  [[ -n "$pictures_directory" ]] || pictures_directory="$HOME/Pictures"
  printf '%s/Screenshots' "$pictures_directory"
}

capture_mode="${1:-}"
output_mode="${2:-}"

case "$capture_mode" in
  area|full) ;;
  *) printf 'Usage: nimlaunch_screenshot.sh {area|full} {clipboard|save}\n' >&2; exit 2 ;;
esac
case "$output_mode" in
  clipboard|save) ;;
  *) printf 'Usage: nimlaunch_screenshot.sh {area|full} {clipboard|save}\n' >&2; exit 2 ;;
esac

require_command "$GRIM_BIN"
[[ "$capture_mode" == "area" ]] && require_command "$SLURP_BIN"
[[ "$output_mode" == "clipboard" ]] && require_command "$WL_COPY_BIN"

declare -a capture_arguments=()
if [[ "$capture_mode" == "area" ]]; then
  geometry="$("$SLURP_BIN")" || exit 0
  [[ -n "$geometry" ]] || exit 0
  capture_arguments=(-g "$geometry")
fi

if [[ "$output_mode" == "clipboard" ]]; then
  "$GRIM_BIN" "${capture_arguments[@]}" - | "$WL_COPY_BIN" --type image/png
  message="Screenshot copied to clipboard"
else
  output_directory="$(screenshot_directory)"
  mkdir -p "$output_directory"
  output_file="$output_directory/$(date '+%Y-%m-%d_%H-%M-%S').png"
  "$GRIM_BIN" "${capture_arguments[@]}" "$output_file"
  message="Screenshot saved to $output_file"
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "Screenshot" "$message" -i camera-photo || true
fi

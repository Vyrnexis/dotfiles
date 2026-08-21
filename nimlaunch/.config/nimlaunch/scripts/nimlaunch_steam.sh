#!/usr/bin/env bash
set -euo pipefail

NIMLAUNCH_BIN="${NIMLAUNCH_BIN:-nimlaunch}"
STEAM_BIN="${STEAM_BIN:-steam}"
STEAM_ROOT="${STEAM_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/Steam}"

# Exits with an actionable message when a required command is unavailable.
require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'nimlaunch_steam: required command not found: %s\n' "$command_name" >&2
    exit 127
  fi
}

# Adds application manifests from a valid Steam library directory.
add_library_manifests() {
  local library_path="$1"
  local manifest

  [[ -d "$library_path/steamapps" ]] || return 0
  for manifest in "$library_path"/steamapps/appmanifest_*.acf; do
    [[ -f "$manifest" ]] && manifest_files+=("$manifest")
  done
}

require_command "$NIMLAUNCH_BIN"
require_command "$STEAM_BIN"

[[ -d "$STEAM_ROOT" ]] || STEAM_ROOT="$HOME/.steam/root"
[[ -d "$STEAM_ROOT" ]] || {
  printf 'nimlaunch_steam: Steam installation directory not found\n' >&2
  exit 1
}

declare -a manifest_files=()
add_library_manifests "$STEAM_ROOT"

library_file="$STEAM_ROOT/steamapps/libraryfolders.vdf"
if [[ -f "$library_file" ]]; then
  while IFS= read -r library_path; do
    [[ -n "$library_path" ]] && add_library_manifests "$library_path"
  done < <(awk -F'"' '/"path"/ { print $4 }' "$library_file")
fi

((${#manifest_files[@]} > 0)) || {
  printf 'nimlaunch_steam: no Steam application manifests found\n' >&2
  exit 1
}

declare -a game_ids=()
declare -a game_names=()
declare -a game_labels=()

while IFS=$'\t' read -r app_id game_name; do
  [[ -n "$app_id" && -n "$game_name" ]] || continue
  case "$game_name" in
    Proton*|"Steam Linux Runtime"*|Steamworks*) continue ;;
  esac
  game_ids+=("$app_id")
  game_names+=("$game_name")
  game_labels+=("$game_name [$app_id]")
done < <(
  awk -F'"' '
    /"appid"/ { appid = $4 }
    /"name"/ && appid != "" { print appid "\t" $4; appid = "" }
  ' "${manifest_files[@]}" | sort -t $'\t' -k2,2f
)

((${#game_ids[@]} > 0)) || {
  printf 'nimlaunch_steam: no playable Steam games found\n' >&2
  exit 1
}

selection="$(
  for label in "${game_labels[@]}"; do
    printf '%s\0icon\x1f%s\n' "$label" "steam"
  done | "$NIMLAUNCH_BIN" --dmenu -p "Steam:"
)" || {
  selection_status=$?
  ((selection_status == 1)) && exit 0
  exit "$selection_status"
}
[[ -n "$selection" ]] || exit 0

for index in "${!game_labels[@]}"; do
  [[ "${game_labels[$index]}" == "$selection" ]] || continue
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Steam" "Launching ${game_names[$index]}" -i steam || true
  fi
  "$STEAM_BIN" "steam://rungameid/${game_ids[$index]}" >/dev/null 2>&1 &
  exit 0
done

printf 'nimlaunch_steam: selection did not match a Steam game\n' >&2
exit 1

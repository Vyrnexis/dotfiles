#!/usr/bin/env bash
set -euo pipefail

NIMLAUNCH_BIN="${NIMLAUNCH_BIN:-nimlaunch}"
HYPRCTL_BIN="${HYPRCTL_BIN:-hyprctl}"

# Exits with an actionable message when a required command is unavailable.
require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'nimlaunch_windows: required command not found: %s\n' "$command_name" >&2
    exit 127
  fi
}

# Decodes a base64-encoded JSON string without flattening embedded newlines.
decode_json_value() {
  local encoded_value="$1"

  printf '%s' "$encoded_value" | base64 --decode
}

require_command "$NIMLAUNCH_BIN"
require_command "$HYPRCTL_BIN"
require_command jq
require_command base64

declare -a window_records=()
declare -a window_addresses=()
declare -a window_labels=()

mapfile -t window_records < <(
  "$HYPRCTL_BIN" clients -j |
    jq -r '.[] | select(.mapped == true) | @base64'
)

for record in "${window_records[@]}"; do
  window_json="$(decode_json_value "$record")"
  address="$(jq -r '.address' <<<"$window_json")"
  title="$(jq -r '.title | gsub("[\\r\\n\\t]"; " ")' <<<"$window_json")"
  class="$(jq -r '.class | gsub("[\\r\\n\\t]"; " ")' <<<"$window_json")"
  [[ -n "$address" && "$address" != "null" ]] || continue
  [[ -n "$title" && "$title" != "null" ]] || title="Untitled window"
  [[ -n "$class" && "$class" != "null" ]] || class="unknown"
  window_addresses+=("$address")
  window_labels+=("$title [$class, $address]")
done

((${#window_addresses[@]} > 0)) || {
  printf 'nimlaunch_windows: no mapped Hyprland windows found\n' >&2
  exit 1
}

selection="$(
  for label in "${window_labels[@]}"; do
    printf '%s\0icon\x1f%s\n' "$label" "application-x-executable"
  done | "$NIMLAUNCH_BIN" --dmenu -p "Windows:"
)" || {
  selection_status=$?
  ((selection_status == 1)) && exit 0
  exit "$selection_status"
}
[[ -n "$selection" ]] || exit 0

for index in "${!window_labels[@]}"; do
  if [[ "${window_labels[$index]}" == "$selection" ]]; then
    "$HYPRCTL_BIN" dispatch focuswindow "address:${window_addresses[$index]}" >/dev/null
    exit 0
  fi
done

printf 'nimlaunch_windows: selection did not match a Hyprland window\n' >&2
exit 1

#!/usr/bin/env bash
set -euo pipefail

NIMLAUNCH_BIN="${NIMLAUNCH_BIN:-nimlaunch}"

# Exits with an actionable message when a required command is unavailable.
require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'nimlaunch_clipboard: required command not found: %s\n' "$command_name" >&2
    exit 127
  fi
}

# Converts clipboard content into a compact single-line selection preview.
preview_text() {
  local value="$1"

  value="${value//$'\r'/ }"
  value="${value//$'\n'/ }"
  value="${value//$'\t'/ }"
  value="${value//$'\0'/}"
  printf '%.100s' "$value"
}

# Decodes a base64 entry into clipboard_value while retaining trailing newlines.
decode_entry() {
  local encoded_value="$1"

  IFS= read -r -d '' clipboard_value < <(
    printf '%s' "$encoded_value" | base64 --decode
    printf '\0'
  ) || true
}

# Selects and restores an entry from the cliphist history backend.
run_cliphist() {
  local selection index preview
  declare -a entries=()
  declare -a labels=()

  mapfile -t entries < <(cliphist list)
  ((${#entries[@]} > 0)) || {
    printf 'nimlaunch_clipboard: cliphist history is empty\n' >&2
    return 1
  }

  for index in "${!entries[@]}"; do
    preview="$(preview_text "${entries[$index]}")"
    labels+=("$((index + 1)): $preview")
  done

  selection="$(
    for label in "${labels[@]}"; do
      printf '%s\0icon\x1f%s\n' "$label" "edit-paste"
    done | "$NIMLAUNCH_BIN" --dmenu -p "Clipboard:"
  )" || {
    selection_status=$?
    ((selection_status == 1)) && return 0
    return "$selection_status"
  }
  [[ -n "$selection" ]] || return 0

  for index in "${!labels[@]}"; do
    if [[ "${labels[$index]}" == "$selection" ]]; then
      printf '%s\n' "${entries[$index]}" | cliphist decode | wl-copy
      if command -v notify-send >/dev/null 2>&1; then
        notify-send "Clipboard" "Restored clipboard item" -i edit-paste || true
      fi
      return 0
    fi
  done

  printf 'nimlaunch_clipboard: selection did not match a cliphist entry\n' >&2
  return 1
}

# Selects and restores an exact entry from KDE Klipper over D-Bus.
run_klipper() {
  local history_json selection index preview
  declare -a encoded_entries=()
  declare -a labels=()

  history_json="$(
    busctl --user --json=short call \
      org.kde.klipper /klipper org.kde.klipper.klipper getClipboardHistoryMenu
  )"
  mapfile -t encoded_entries < <(jq -r '.data[0][] | @base64' <<<"$history_json")
  ((${#encoded_entries[@]} > 0)) || {
    printf 'nimlaunch_clipboard: Klipper history is empty\n' >&2
    return 1
  }

  for index in "${!encoded_entries[@]}"; do
    decode_entry "${encoded_entries[$index]}"
    preview="$(preview_text "$clipboard_value")"
    labels+=("$((index + 1)): $preview")
  done

  selection="$(
    for label in "${labels[@]}"; do
      printf '%s\0icon\x1f%s\n' "$label" "edit-paste"
    done | "$NIMLAUNCH_BIN" --dmenu -p "Clipboard:"
  )" || {
    selection_status=$?
    ((selection_status == 1)) && return 0
    return "$selection_status"
  }
  [[ -n "$selection" ]] || return 0

  for index in "${!labels[@]}"; do
    [[ "${labels[$index]}" == "$selection" ]] || continue
    decode_entry "${encoded_entries[$index]}"
    busctl --user call org.kde.klipper /klipper \
      org.kde.klipper.klipper setClipboardContents s "$clipboard_value" >/dev/null
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "Clipboard" "Restored clipboard item" -i edit-paste || true
    fi
    return 0
  done

  printf 'nimlaunch_clipboard: selection did not match a Klipper entry\n' >&2
  return 1
}

require_command "$NIMLAUNCH_BIN"

if command -v cliphist >/dev/null 2>&1 && command -v wl-copy >/dev/null 2>&1; then
  run_cliphist
elif command -v busctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  require_command base64
  run_klipper
else
  printf '%s\n' \
    'nimlaunch_clipboard: install cliphist and wl-copy, or run KDE Klipper with busctl and jq' >&2
  exit 127
fi

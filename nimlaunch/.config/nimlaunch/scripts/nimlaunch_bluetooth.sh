#!/usr/bin/env bash
set -euo pipefail

NIMLAUNCH_BIN="${NIMLAUNCH_BIN:-nimlaunch}"
BLUETOOTHCTL_BIN="${BLUETOOTHCTL_BIN:-bluetoothctl}"

# Exits with an actionable message when a required command is unavailable.
require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'nimlaunch_bluetooth: required command not found: %s\n' "$command_name" >&2
    exit 127
  fi
}

# Reports whether the specified Bluetooth device is currently connected.
is_connected() {
  local mac_address="$1"

  "$BLUETOOTHCTL_BIN" info "$mac_address" 2>/dev/null |
    awk -F': ' '$1 ~ /Connected$/ { found = 1; connected = ($2 == "yes") } END { exit (!found || !connected) }'
}

require_command "$NIMLAUNCH_BIN"
require_command "$BLUETOOTHCTL_BIN"

declare -a device_macs=()
declare -a device_names=()
declare -a device_labels=()

while read -r record_type mac_address device_name; do
  [[ "$record_type" == "Device" && -n "$mac_address" ]] || continue
  [[ -n "$device_name" ]] || device_name="Unnamed device"
  marker=""
  is_connected "$mac_address" && marker=" [connected]"
  device_macs+=("$mac_address")
  device_names+=("$device_name")
  device_labels+=("$device_name$marker [$mac_address]")
done < <("$BLUETOOTHCTL_BIN" devices Paired 2>/dev/null || "$BLUETOOTHCTL_BIN" devices)

((${#device_macs[@]} > 0)) || {
  printf 'nimlaunch_bluetooth: no paired Bluetooth devices found\n' >&2
  exit 1
}

selection="$(
  for label in "${device_labels[@]}"; do
    printf '%s\0icon\x1f%s\n' "$label" "bluetooth"
  done | "$NIMLAUNCH_BIN" --dmenu -p "Bluetooth:"
)" || {
  selection_status=$?
  ((selection_status == 1)) && exit 0
  exit "$selection_status"
}
[[ -n "$selection" ]] || exit 0

for index in "${!device_labels[@]}"; do
  [[ "${device_labels[$index]}" == "$selection" ]] || continue
  if is_connected "${device_macs[$index]}"; then
    "$BLUETOOTHCTL_BIN" disconnect "${device_macs[$index]}"
    action="Disconnected"
  else
    "$BLUETOOTHCTL_BIN" connect "${device_macs[$index]}"
    action="Connected"
  fi
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Bluetooth" "$action ${device_names[$index]}" -i bluetooth || true
  fi
  exit 0
done

printf 'nimlaunch_bluetooth: selection did not match a paired device\n' >&2
exit 1

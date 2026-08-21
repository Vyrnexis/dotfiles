#!/usr/bin/env bash
set -euo pipefail

NIMLAUNCH_BIN="${NIMLAUNCH_BIN:-nimlaunch}"
NMCLI_BIN="${NMCLI_BIN:-nmcli}"

# Exits with an actionable message when a required command is unavailable.
require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'nimlaunch_wifi: required command not found: %s\n' "$command_name" >&2
    exit 127
  fi
}

# Splits one escaped nmcli record into the global nmcli_fields array.
parse_nmcli_record() {
  local record="$1"
  local character field="" escaped=0 index
  nmcli_fields=()

  for ((index = 0; index < ${#record}; index++)); do
    character="${record:index:1}"
    if ((escaped)); then
      field+="$character"
      escaped=0
    elif [[ "$character" == "\\" ]]; then
      escaped=1
    elif [[ "$character" == ":" ]]; then
      nmcli_fields+=("$field")
      field=""
    else
      field+="$character"
    fi
  done
  ((escaped)) && field+="\\"
  nmcli_fields+=("$field")
}

# Prompts for a Wi-Fi password without displaying it in NimLaunch.
prompt_password() {
  local ssid="$1"

  if command -v zenity >/dev/null 2>&1; then
    zenity --password --title="Wi-Fi password" --text="Password for $ssid"
  elif command -v kdialog >/dev/null 2>&1; then
    kdialog --password "Password for $ssid"
  else
    printf 'nimlaunch_wifi: zenity or kdialog is required for secure password entry\n' >&2
    return 127
  fi
}

# Sends a desktop notification when notify-send is available.
notify_wifi() {
  local message="$1"

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Wi-Fi" "$message" -i network-wireless || true
  fi
}

require_command "$NIMLAUNCH_BIN"
require_command "$NMCLI_BIN"

declare -a wifi_ssids=()
declare -a wifi_security=()
declare -a wifi_labels=()
declare -a wifi_icons=()
declare -A seen_ssids=()
declare -a nmcli_fields=()

while IFS= read -r record; do
  parse_nmcli_record "$record"
  ((${#nmcli_fields[@]} >= 3)) || continue
  active="${nmcli_fields[0]}"
  security="${nmcli_fields[1]}"
  ssid="${nmcli_fields[2]}"
  [[ -n "$ssid" && -z "${seen_ssids[$ssid]+present}" ]] || continue
  seen_ssids["$ssid"]=1

  status=""
  [[ "$active" == "*" || "$active" == "yes" ]] && status=" [connected]"
  if [[ -z "$security" || "$security" == "--" ]]; then
    security_label="open"
    icon="network-wireless"
  else
    security_label="$security"
    icon="network-wireless-encrypted"
  fi

  wifi_ssids+=("$ssid")
  wifi_security+=("$security")
  wifi_labels+=("$ssid$status [$security_label]")
  wifi_icons+=("$icon")
done < <("$NMCLI_BIN" --terse --escape yes --fields IN-USE,SECURITY,SSID device wifi list)

((${#wifi_ssids[@]} > 0)) || {
  printf 'nimlaunch_wifi: no Wi-Fi networks found\n' >&2
  exit 1
}

selection="$(
  for index in "${!wifi_labels[@]}"; do
    printf '%s\0icon\x1f%s\n' "${wifi_labels[$index]}" "${wifi_icons[$index]}"
  done | "$NIMLAUNCH_BIN" --dmenu -p "Wi-Fi:"
)" || {
  selection_status=$?
  ((selection_status == 1)) && exit 0
  exit "$selection_status"
}
[[ -n "$selection" ]] || exit 0

selected_index=""
for index in "${!wifi_labels[@]}"; do
  if [[ "${wifi_labels[$index]}" == "$selection" ]]; then
    selected_index="$index"
    break
  fi
done
[[ -n "$selected_index" ]] || {
  printf 'nimlaunch_wifi: selection did not match a Wi-Fi network\n' >&2
  exit 1
}

ssid="${wifi_ssids[$selected_index]}"
security="${wifi_security[$selected_index]}"
notify_wifi "Connecting to $ssid"

if "$NMCLI_BIN" device wifi connect "$ssid" >/dev/null 2>&1; then
  notify_wifi "Connected to $ssid"
  exit 0
fi

if [[ -z "$security" || "$security" == "--" ]]; then
  printf 'nimlaunch_wifi: failed to connect to open network: %s\n' "$ssid" >&2
  exit 1
fi

if password="$(prompt_password "$ssid")"; then
  :
else
  prompt_status=$?
  ((prompt_status == 1)) && exit 0
  exit "$prompt_status"
fi
[[ -n "$password" ]] || exit 0

if "$NMCLI_BIN" device wifi connect "$ssid" password "$password" >/dev/null; then
  notify_wifi "Connected to $ssid"
else
  notify_wifi "Failed to connect to $ssid"
  exit 1
fi

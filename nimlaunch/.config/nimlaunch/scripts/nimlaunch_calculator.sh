#!/usr/bin/env bash
set -euo pipefail

BC_BIN="${BC_BIN:-bc}"
WL_COPY_BIN="${WL_COPY_BIN:-wl-copy}"
NOTIFY_SEND_BIN="${NOTIFY_SEND_BIN:-notify-send}"

# Exits with an actionable message when a required command is unavailable.
require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'nimlaunch_calculator: required command not found: %s\n' "$command_name" >&2
    exit 127
  fi
}

require_command "$BC_BIN"

expression="$*"
[[ -n "$expression" ]] || exit 0

if [[ ! "$expression" =~ ^[[:space:][:digit:]+*/%().^=-]+$ ]]; then
  printf 'nimlaunch_calculator: expression contains unsupported characters\n' >&2
  exit 2
fi

if ! result="$(printf '%s\n' "$expression" | "$BC_BIN" -l 2>/dev/null)"; then
  printf 'nimlaunch_calculator: invalid expression\n' >&2
  exit 2
fi
[[ -n "$result" ]] || {
  printf 'nimlaunch_calculator: expression produced no result\n' >&2
  exit 2
}

clipboard_status=""
if command -v "$WL_COPY_BIN" >/dev/null 2>&1; then
  printf '%s' "$result" | "$WL_COPY_BIN"
  clipboard_status=" and copied to the clipboard"
fi
if command -v "$NOTIFY_SEND_BIN" >/dev/null 2>&1; then
  "$NOTIFY_SEND_BIN" "Calculator" "Result: $result$clipboard_status" \
    -i accessories-calculator || true
else
  printf 'Result: %s\n' "$result"
fi

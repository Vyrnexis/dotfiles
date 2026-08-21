#!/usr/bin/env bash
set -euo pipefail

NIMLAUNCH_BIN="${NIMLAUNCH_BIN:-nimlaunch}"
WPCTL_BIN="${WPCTL_BIN:-wpctl}"
PIPEWIRE_DUMP_BIN="${PIPEWIRE_DUMP_BIN:-pw-dump}"

# Exits with an actionable message when a required command is unavailable.
require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'nimlaunch_audio: required command not found: %s\n' "$command_name" >&2
    exit 127
  fi
}

# Returns the numeric ID of the current default audio sink.
default_sink_id() {
  "$WPCTL_BIN" inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '
    /^id[[:space:]]+[0-9]+,/ {
      gsub(",", "", $2)
      print $2
      exit
    }
  '
}

# Emits each PipeWire audio sink as a tab-separated ID and display name.
sink_rows() {
  "$PIPEWIRE_DUMP_BIN" --raw 2>/dev/null | perl -MJSON::PP -e '
    local $/;
    my $data = eval { JSON::PP::decode_json(<STDIN>) };
    exit 1 if !$data || ref($data) ne "ARRAY";
    for my $obj (@$data) {
      next if ref($obj) ne "HASH";
      next if ($obj->{type} // "") ne "PipeWire:Interface:Node";
      my $props = $obj->{info}{props} // {};
      next if ($props->{"media.class"} // "") ne "Audio/Sink";
      my $id = $obj->{id};
      next if !defined $id;
      my $name = $props->{"node.description"}
        // $props->{"device.description"}
        // $props->{"node.nick"}
        // $props->{"node.name"}
        // "Sink $id";
      $name =~ s/[\r\n\t]+/ /g;
      print "$id\t$name\n";
    }
  '
}

require_command "$NIMLAUNCH_BIN"
require_command "$WPCTL_BIN"
require_command "$PIPEWIRE_DUMP_BIN"
require_command perl

if ! perl -MJSON::PP -e 'exit 0' >/dev/null 2>&1; then
  printf 'nimlaunch_audio: Perl module JSON::PP is required\n' >&2
  exit 127
fi

declare -a sink_ids=()
declare -a sink_labels=()
default_id="$(default_sink_id || true)"

while IFS=$'\t' read -r id name; do
  [[ -n "$id" ]] || continue
  marker=""
  [[ "$id" == "$default_id" ]] && marker=" [default]"
  sink_ids+=("$id")
  sink_labels+=("$name$marker [$id]")
done < <(sink_rows)

((${#sink_ids[@]} > 0)) || {
  printf 'nimlaunch_audio: no audio sinks found\n' >&2
  exit 1
}

selection="$(
  for label in "${sink_labels[@]}"; do
    printf '%s\0icon\x1f%s\n' "$label" "audio-speakers"
  done | "$NIMLAUNCH_BIN" --dmenu -p "Audio sink:"
)" || {
  selection_status=$?
  ((selection_status == 1)) && exit 0
  exit "$selection_status"
}
[[ -n "$selection" ]] || exit 0

for index in "${!sink_labels[@]}"; do
  if [[ "${sink_labels[$index]}" == "$selection" ]]; then
    "$WPCTL_BIN" set-default "${sink_ids[$index]}"
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "Audio sink" "Selected ${sink_labels[$index]}" -i audio-speakers || true
    fi
    exit 0
  fi
done

printf 'nimlaunch_audio: selection did not match an audio sink\n' >&2
exit 1

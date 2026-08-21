# NimLaunch Script Plugins

Script plugins are executable, self-contained commands launched from a
NimLaunch shortcut. A plugin can open its own dmenu picker, perform one focused
action, or accept arguments from a shortcut.

## Contract

- Use `#!/usr/bin/env bash` and `set -euo pipefail`.
- Resolve NimLaunch with `NIMLAUNCH_BIN="${NIMLAUNCH_BIN:-nimlaunch}"` so users
  can override the executable during development or testing.
- Check required commands before opening the picker. Exit `127` when a required
  command is missing.
- Treat an empty selection or a cancelled picker as a normal exit without an
  error notification.
- Keep action IDs separate from display labels. Never recover a MAC address,
  application ID, window address, or similar identifier by parsing a label.
- Quote command arguments and do not print passwords, tokens, or clipboard
  contents.
- Use exit `0` for success or cancellation, `1` for an operational failure, and
  `2` for invalid arguments.
- Keep the file self-contained when practical so it can be shared as one file.

NimLaunch accepts standard dmenu input. Add an icon to a displayed line with a
NUL byte, the word `icon`, a unit separator, and the icon name:

```bash
printf '%s\0icon\x1f%s\n' "$label" "$icon"
```

NimLaunch returns only the visible label. Use a unique display label or retain a
parallel label-to-ID array as shown in
[`plugin-template.sh.example`](plugin-template.sh.example).

## Install a Shared Plugin

Copy the plugin into this directory, review its commands, make it executable,
and add a shortcut to `nimlaunch.toml`:

```bash
chmod +x ~/.config/nimlaunch/scripts/nimlaunch_example.sh
```

```toml
[[shortcuts]]
group     = "scripts"
label     = "Example Plugin"
base      = "$HOME/.config/nimlaunch/scripts/nimlaunch_example.sh"
mode      = "shell"
run_mode  = "spawn"
stay_open = false
```

Use a `nimlaunch_` filename prefix to keep plugins recognizable. Environment
variables ending in `_BIN` are the preferred way to make external commands
replaceable in tests.

For a shell-mode shortcut that accepts `{query}`, leave the placeholder
unquoted. NimLaunch applies shell-safe quoting before it substitutes the value.

## Included Plugins

| Plugin | Purpose | Required commands |
|--------|---------|-------------------|
| `nimlaunch_audio.sh` | Select a PipeWire sink | `wpctl`, `pw-dump`, Perl `JSON::PP` |
| `nimlaunch_bluetooth.sh` | Connect or disconnect a paired device | `bluetoothctl` |
| `nimlaunch_calculator.sh` | Evaluate and optionally copy an expression | `bc`; optional `wl-copy` |
| `nimlaunch_clipboard.sh` | Restore clipboard history | `cliphist` and `wl-copy`, or `busctl` and `jq` |
| `nimlaunch_screenshot.sh` | Capture an area or full screen | `grim`; optional `slurp`, `wl-copy` by mode |
| `nimlaunch_steam.sh` | Launch an installed Steam game | `steam` |
| `nimlaunch_wifi.sh` | Connect to a visible Wi-Fi network | `nmcli`; `zenity` or `kdialog` for passwords |
| `nimlaunch_windows.sh` | Focus a mapped Hyprland window | `hyprctl`, `jq` |

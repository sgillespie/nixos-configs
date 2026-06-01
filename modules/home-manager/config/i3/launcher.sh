#!/usr/bin/env bash

# Curated rofi launcher; contains frequently-used apps

declare -A cmd
cmd[Brave]='brave --profile-directory=Default'
cmd["Brave (work)"]='brave --profile-directory=IOG'
cmd[Discord]='Discord'
cmd[Pass]='rofi-pass'
cmd[Slack]='slack'
cmd[Spotify]='spotify'
cmd[Thunderbird]='thunderbird'
cmd[Neovide]='neovide'
cmd[Telegram]='Telegram'

declare -A icon
icon[Brave]=brave-browser
icon["Brave (work)"]=brave-browser
icon[Discord]=discord
icon[Pass]=dialog-password
icon[Slack]=slack
icon[Spotify]=spotify
icon[Thunderbird]=thunderbird
icon[Telegram]=telegram
icon[Neovide]=nvim

order=(Neovide Brave "Brave (work)" Slack Thunderbird Pass Spotify Discord Signal Telegram)

if [[ -n "$@" ]]; then
  coproc ( ${cmd[$@]} > /dev/null 2>&1 )
  exit 0
fi

for name in "${order[@]}"; do
  printf '%s\0icon\x1f%s\n' "$name" "${icon[$name]}"
done

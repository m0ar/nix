#! /bin/env bash
#
# Control volume for the default sink like pactl, but prevent
# going over 100%, into the land of distortion and broken speakers

set -euo pipefail

DEFAULT_SINK=0

echoerr() { cat <<< "$@" 1>&2; }

assert_delta() {
  local delta=$1

  if ! echo "$delta" | grep -Eq '^[-]?[0-9]+$'; then
    echoerr "error: expected simple percentage delta, e.g. -10 or 5"
    exit 1
  fi
}

get_current_volume() {
  pactl get-sink-volume $DEFAULT_SINK \
    | grep -Eo '[0-9]+%' \
    | sed 's/%//' \
    | sort -n \
    | tail -1
}

cap_volume() {
  local volume=$1
  if [[ $volume -gt 100 ]]; then
    echo 100
  elif [[ $volume -lt 0 ]]; then
    echo 0
  else
    echo $volume
  fi
}

voldelta=$1

assert_delta "$voldelta"
current_volume=$(get_current_volume)
new_volume=$(( current_volume + voldelta ))
caped_volume=$(cap_volume $new_volume)
pactl set-sink-volume "$DEFAULT_SINK" "$caped_volume%"

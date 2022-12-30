#! /bin/env bash
#
# Create a pixelated background for i3lock. Overlays a picture on top of the
# background, the path to this is set with the LOCK_ICON environment variable.
#
# All arguments to this script is passed along to i3lock.

set -xeo pipefail

icon="$LOCK_ICON"
tmpbg='/tmp/lockscreen.png'

# Without overwrite, scrot will increment a number on the filename
scrot --overwrite "$tmpbg"
convert "$tmpbg" -scale 5% -scale 2000% "$tmpbg"
if [[ -n "$icon" ]]; then
  convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"
fi
i3lock -i "$tmpbg" "$@"


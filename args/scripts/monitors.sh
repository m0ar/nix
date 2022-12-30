#! /bin/env bash

set -e

readonly MON_LAPTOP=eDP-1
readonly MON_LEFT=DP-1-2
readonly MON_RIGHT=DP-1-3
alias xrandr='xrandr -d :0 --verbose'

function try_enable_dual_screens () {
  xrandr --output $MON_LAPTOP --off
  xrandr --output $MON_RIGHT \
    --auto \
    --right-of $MON_LAPTOP
  xrandr --output $MON_LEFT \
	  --primary \
    --auto \
    --rotate normal \
    --right-of $MON_RIGHT
}

function enable_laptop_screen () {
  xrandr --output $MON_LAPTOP \
	  --auto
  xrandr --output $MON_LEFT \
  	--off
  xrandr --output $MON_RIGHT \
	  --off
}

case $1 in
'office')
  echo 'Switching to office setup...'
  try_enable_dual_screens
  # Reset to us to nuke laptop mappings
  setxkbmap -layout us
  # Apply split layout
  xmodmap ~/.Xmodmap_split
  echo "Exit script within 15 seconds, otherwise I'll revert the changes :)"
  sleep 15
  # Call self with laptop settings
  $0 laptop
;;
'laptop')
  echo "Reverting to laptop mode..."
  enable_laptop_screen
  # Reset split mappings
  setxkbmap -layout us
  # Apply laptop mappings
  xmodmap ~/.Xmodmap
;;
*)
  echo "I only know about 'office' and 'laptop' modes, sorry"
  exit 1
;;
esac

#! /bin/env bash

set -e

readonly MON_LAPTOP=eDP-1
readonly MON_LEFT=DP-1-2
readonly MON_RIGHT=DP-1-3
readonly MON_BIG=DP-1
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

function try_enable_big_external () {
  xrandr --output $MON_LAPTOP --off
  xrandr --output $MON_BIG    --auto
}

function enable_laptop_screen () {
  xrandr --output $MON_LAPTOP --auto
  xrandr --output $MON_LEFT   --off
  xrandr --output $MON_RIGHT  --off
  xrandr --output $MON_BIG    --off
}

function setup_and_timeout () {
  # Reset to us to nuke laptop mappings
  setxkbmap -layout us
  # Apply split layout
  xmodmap ~/.Xmodmap_split
  echo "Exit script within 15 seconds, otherwise I'll revert the changes :)"
  sleep 15
  # Call self with laptop settings
  $0 laptop
}

case $1 in
'dual')
  echo 'Switching to dual office setup...'
  try_enable_dual_screens
  setup_and_timeout
;;

'single')
  echo 'Switching to single office setup...'
  try_enable_big_external
  setup_and_timeout
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
  echo "I only know about 'dual', 'single', and 'laptop' modes, sorry"
  exit 1
;;
esac

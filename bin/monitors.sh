#!/bin/bash

function listSecondaryDisplays {
  xrandr | grep -o '^[^ ]*' | grep -ve Screen -e eDP-1
}

function listConnectedDisplays {
  xrandr | grep ' connected' | grep -o '^[^ ]*'
}

function off {
  xrandr \
    --output eDP-1 --mode 2560x1440 \
    $(listSecondaryDisplays | sed -e 's/^/--output /' -e 's/$/ --off/' | tr "\n" ' ')

    setfontsize.sh 18
}

xrandr -q &> /dev/null

if [ "${1}" = "off" ] ; then
  off
elif [ "${1}" = 'tv' ] ; then
  xrandr \
    --output eDP-1 --mode 2560x1440 --pos 0x0 \
    --output VGA1 --mode 1360x768 --right-of eDP-1
elif [ "${1}" = 'pair' ] ; then
  xrandr \
    --output eDP-1 --mode 2560x1440 --pos 0x0 \
    --output DP-2-2 --mode 1680x1050 --right-of eDP-1 \
    --output DP-2-3 --mode 1680x1050 --same-as DP-2-2
elif (listConnectedDisplays | grep -q 'DP-2-3'); then
#  xrandr \
#    --output eDP-1 --mode 2560x1440 --pos 0x0 \
#    --output DP-2-2 --mode 1680x1050 --pos 1680x0
  xrandr \
    --output eDP-1 --mode 2560x1440 --pos 0x0 \
    --output DP-2-2 --mode 1680x1050 --pos 2560x0 \
    --output DP-2-3 --mode 1680x1050 --pos 4240x0
    setfontsize.sh 8
elif [ $(listConnectedDisplays | wc -l) -gt 1 ]; then
  secondary=$(listConnectedDisplays | grep -v eDP-1 | head -n1)
  mode=$(xrandr | grep -A1 "^${secondary}" | tail -n1 | awk '{ print $1 }')
  xrandr \
    --output eDP-1 --mode 2560x1440 --pos 0x0 \
    --output "${secondary}" --mode "${mode}" --right-of eDP-1
else #if it's not connected
  off
fi


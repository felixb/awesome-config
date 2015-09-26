#!/bin/sh

xrandr -q &> /dev/null

if [ "${1}" = 'tv' ] ; then
  xrandr \
    --output eDP1 --mode 1366x768 --pos 0x0 \
    --output VGA1 --mode 1360x768 --right-of LVDS1
elif $(xrandr --prop | grep -q "DP2-2 connected"); then
  xrandr \
    --output eDP1 --mode 1366x768 --pos 0x0 \
    --output DP2-2 --mode 1680x1050 --pos 1680x0 \
    --output DP2-3 --mode 1680x1050 --pos 3360x0 \
    --output HDMI2 --off \
    --output VIRTUAL1 --off \
    --output DP1 --off \
    --output DP2 --off \
    --output DP2-1 --off \
    --output HDMI1 --off \
    --output VGA1 --off
else #if it's not connected
  xrandr \
    --output eDP1 --mode 1366x768 --pos 0x0 \
    --output DP2-2 --off \
    --output DP2-3 --off \
    --output HDMI2 --off \
    --output VIRTUAL1 --off \
    --output DP1 --off \
    --output DP2 --off \
    --output DP2-1 --off \
    --output HDMI1 --off \
    --output VGA1 --off
fi

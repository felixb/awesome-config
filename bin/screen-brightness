#! /bin/bash

if [ $# -ne 1 ]; then
  echo "usage ${0} [+-]x"
  exit 1
fi

display='eDP-1'

if (echo ${1} | grep -q '^[+-][0-9]'); then
  current=$(xrandr --verbose | grep Brightness: | head -n1 | cut -d: -f2)
  target=$(echo "${current} ${1}" | bc)
else
  target=${1}
fi

echo "setting brightness for display ${display} to ${target}"
exec xrandr --output ${display} --brightness ${target}

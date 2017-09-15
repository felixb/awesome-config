#! /bin/sh

SINK=$(pactl list short sinks | grep analog | cut -f1 | head -n1)
SINK=${SINK:-0}

if [ "${1}" = 'toggle' ] ; then
  exec pactl set-sink-mute ${SINK} toggle
else
  exec pactl set-sink-volume ${SINK} ${1:-100%}
fi

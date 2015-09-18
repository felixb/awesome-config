#! /bin/sh

SINK=$(pactl list short sinks | grep analog | cut -f1 | head -n1)
SINK=${SINK:-0}

if [ "${1}" = 'toggle' ] ; then
  pactl set-sink-mute ${SINK} toggle
else
  pactl set-sink-volume ${SINK} ${1:-100%}
fi

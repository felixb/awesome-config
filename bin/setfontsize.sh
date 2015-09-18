#!/bin/bash

if [ "${TERM}" = 'xrvt' ] ; then
  printf '\33]50;%s\007' "xft:terminus-font:size=${1:-10}"
else
  sed -i ~/.config/xfce4/terminal/terminalrc -e "/FontName=/s/[0-9]*\$/${1:-9}/"
fi

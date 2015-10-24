#! /bin/sh

for applet in light-locker blueman-applet nm-applet ; do
  pkill -f "${applet}"
  ${applet} &
done

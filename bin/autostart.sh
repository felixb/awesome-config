#! /bin/sh

for applet in light-locker blueman-applet nm-applet ; do
  if (! pgrep -x "${applet}") ; then
    ${applet} &
  fi
done

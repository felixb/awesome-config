#! /bin/sh

for applet in blueman-applet nm-applet ; do
  pgrep -x "${applet}" || "${applet}"
done

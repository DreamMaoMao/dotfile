#!/usr/bin/bash

startd=$(pgrep lavalauncher)

if [ -n "$startd" ]; then
  ps aux | grep "lavalauncher -c /home/wrq/.config/labwc/lavalauncher/lavalauncher.conf" | grep -v hide | grep -v grep | awk '{print $2}' | xargs kill -9
else
	lavalauncher -c ~/.config/labwc/lavalauncher/lavalauncher.conf
fi

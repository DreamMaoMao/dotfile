#!/usr/bin/bash

startd=$(pgrep lavalauncher)

if [ -n "$startd" ]; then
  ps aux | grep "lavalauncher -c /home/wrq/.config/maomao/lavalauncher/lavalauncher.conf" | grep -v hide | grep -v grep | awk '{print $2}' | xargs kill -9
else
	lavalauncher -c ~/.config/maomao/lavalauncher/lavalauncher.conf
fi

#!/usr/bin/bash

startd=$(pgrep waybar)

if [ -n "$startd" ]; then
	sudo pkill waybar
else
	waybar -c ~/.config/sway/waybar.conf -s ~/.config/sway/waybar.css &
fi

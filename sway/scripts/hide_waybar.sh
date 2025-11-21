#!/usr/bin/bash

startd=$(pgrep waybar)

if [ -n "$startd" ]; then
	sudo pkill waybar
else
	waybar -c ~/.config/sway/waybar/config -s ~/.config/sway/waybar/style.css &
fi

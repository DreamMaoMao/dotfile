#!/usr/bin/bash

startd=$(pgrep waybar)

if [ -n "$startd" ]; then
	sudo pkill waybar
else
	waybar -c ~/.config/labwc/waybar/config -s ~/.config/labwc/waybar/style.css
fi

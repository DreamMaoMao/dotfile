#!/usr/bin/bash

startd=$(pgrep waybar)

if [ -n "$startd" ]; then
	sudo pkill waybar
else
	waybar -c ~/.config/maomao/waybar/config -s ~/.config/maomao/waybar/style.css
fi

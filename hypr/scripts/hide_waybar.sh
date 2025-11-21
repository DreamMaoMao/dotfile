#!/usr/bin/bash

startd=$(pgrep waybar)

if [ -n "$startd" ]; then
	pkill waybar
else
	waybar -c ~/.config/hypr/waybar/config.jsonc -s ~/.config/hypr/waybar/style.css
fi

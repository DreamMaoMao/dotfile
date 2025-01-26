#!/usr/bin/bash

startd=$(pgrep waybar)

if [ -n "$startd" ]; then
	sudo pkill waybar
else
	~/.config/hypr/scripts/launch_waybar 
fi

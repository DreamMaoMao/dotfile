#!/usr/bin/bash

#swayidle -w \
#	timeout 1800 'swaylock -f -c 000000' \
#	timeout 1800 'hyprctl dispatch dpms off' \
#		resume 'hyprctl dispatch dpms on && ~/.config/hypr/scripts/restart_wlsunset.sh' \
#	timeout 300 'bash $HOME/.config/hypr/scripts/lightresume.sh dark' \
#		resume 'bash $HOME/.config/hypr/scripts/lightresume.sh resume' \
#	timeout 3600 'systemctl suspend'

swayidle -w \
	timeout 1800 'hyprctl dispatch dpms off' \
	resume 'hyprctl dispatch dpms on && ~/.config/hypr/scripts/restart_wlsunset.sh' \
	timeout 300 'bash $HOME/.config/hypr/scripts/lightresume.sh dark' \
	resume 'bash $HOME/.config/hypr/scripts/lightresume.sh resume'

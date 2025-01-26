#!/usr/bin/bash

eww daemon &
eww open notifications_popup
sudo pkill dunst
~/.config/eww/scripts/myshell/./myshell --eww --file

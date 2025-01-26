#!/usr/bin/bash

clients_num=$(hyprctl clients | grep OVERVIEW | wc -l)

if [[ $clients_num == 1 ]]; then
    hyprctl dispatch submap reset 
    hyprctl dispatch killactive
else
    hyprctl dispatch killactive
fi
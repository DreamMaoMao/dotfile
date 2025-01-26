#!/usr/bin/bash

version=$(hyprctl version | grep Tag | awk '{print $2}'   | awk -F "-" '{print $1}' | awk -F "." '{print $2}')

if [[ $version < 31 ]];then
    hyprctl keyword source ~/.config/hypr/oldconfig.conf
fi

if [[ $version > 35 ]];then
    hyprctl keyword source ~/.config/hypr/newconfig.conf
fi
#!/usr/bin/bash

case $1 in
dark)
    light=$(brightnessctl get)
    echo "$light" > $HOME/.cache/lightresume
    brightnessctl set 0
	;;
resume)
    light=$(cat $HOME/.cache/lightresume)    
    brightnessctl set $light
	;;
esac
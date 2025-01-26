#!/usr/bin/bash

startd=$(pgrep wofi)

if [ -n $startd ]; then
	wofi --show drun -o DP-3
fi

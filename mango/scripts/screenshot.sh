#!/usr/bin/bash

grim -g "$(slurp -b '#2E2A1E55' -c '#fb751bff')" -t ppm - | satty -f -
# QT_WAYLAND_FORCE_DPI=96 flameshot gui

#!/usr/bin/bash

set +e

rofi -global-kb  -show window -show-icons \
                           -kb-accept-entry 'Alt-Tab,Return,MousePrimary' \
                           -kb-row-down 'Alt+Down,Down' \
                           -kb-row-up 'Alt+Up,Up'

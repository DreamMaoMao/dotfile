#!/usr/bin/bash

set +e

rofi -global-kb  -show window -show-icons \
                           -kb-accept-entry '!Super-Tab,Super-grave,Return,MousePrimary' \
                           -kb-row-down 'Super+Tab,Down'

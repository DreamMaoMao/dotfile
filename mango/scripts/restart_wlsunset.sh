#!/usr/bin/bash

set +e

ps aux | grep wlsunset | grep -v swayidle | grep -v restart | grep -v grep | awk '{print $2}' | xargs sudo kill 

nohup wlsunset -T 3001 -t 3000 >> /dev/null 2<&1 &

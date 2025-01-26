#!/usr/bin/bash

ps aux | grep wlsunset | grep -v swayidle | grep -v grep | awk '{print $2}' | xargs kill 

nohup wlsunset -T 3501 -t 3500 >> /dev/null 2<&1 &
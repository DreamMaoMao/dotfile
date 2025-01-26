#!/usr/bin/bash

# DEVICE=$(ls /sys/class/net | grep ^w)


while true
do
    # net_text=$( sar -n DEV 1 1 | grep $DEVICE |grep -E "Average|平均时间" | awk 'BEGIN{c=" "}{print  $5""c""$6 }' )
    # upload_speed=$(echo $net_text | cut -d " " -f 2 | cut -d "." -f 1)
    # download_speed=$(echo $net_text | cut -d " " -f 1 | cut -d "." -f 1)
    # cpu_usage=$(sar -u 1 1 |grep -E "Average|平均时间" | awk '{print $3}' | cut -d "." -f 1)
    # echo $upload_speed
    # echo $download_speed
    # echo $cpu_usage
    # if (( $download_speed > 100 ||  $cpu_usage > 40 || $upload_speed > 100 ));then
    #     wayland-idleinhibit
    # fi
    wayland-idleinhibit
    sleep 10s
done


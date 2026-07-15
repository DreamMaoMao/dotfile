#!/usr/bin/bash

# 将 swaymsg 替换为 i3-msg，其余逻辑保持不变
current_ws=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .num')

case $1 in
    viewleft)
        i3-msg workspace $(( $current_ws - 1 ))
        ;;
    viewright)
        i3-msg workspace $(( $current_ws + 1 ))
        ;;
    moveleft)
        i3-msg move container to workspace number $(( $current_ws - 1 ))
        i3-msg workspace $(( $current_ws - 1 ))
        ;;
    moveright)
        i3-msg move container to workspace number $(( $current_ws + 1 ))
        i3-msg workspace $(( $current_ws + 1 ))
        ;;
    move0)
        i3-msg move container to workspace number 0
        i3-msg workspace 0
        ;;
    move1)
        i3-msg move container to workspace number 1
        i3-msg workspace 1
        ;;
    move2)
        i3-msg move container to workspace number 2
        i3-msg workspace 2
        ;;
    move3)
        i3-msg move container to workspace number 3
        i3-msg workspace 3
        ;;
    move4)
        i3-msg move container to workspace number 4
        i3-msg workspace 4
        ;;
    move5)
        i3-msg move container to workspace number 5
        i3-msg workspace 5
        ;;
    move6)
        i3-msg move container to workspace number 6
        i3-msg workspace 6
        ;;
    move7)
        i3-msg move container to workspace number 7
        i3-msg workspace 7
        ;;
    move8)
        i3-msg move container to workspace number 8
        i3-msg workspace 8
        ;;
    move9)
        i3-msg move container to workspace number 9
        i3-msg workspace 9
        ;;
    *)
        echo "miss arg"
        exit 1
esac
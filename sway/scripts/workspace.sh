#!/usr/bin/bash

current_ws=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true) | .num')
case $1 in
    viewleft)
        swaymsg workspace $(( $current_ws - 1 ))
        ;;
    viewright)
        swaymsg workspace $(( $current_ws + 1 ))
        ;;
    moveleft)
        swaymsg move container to workspace number $(( $current_ws - 1 ))
        swaymsg workspace $(( $current_ws - 1 ))
        ;;
    moveright)
        swaymsg move container to workspace number $(( $current_ws + 1 ))
        swaymsg workspace $(( $current_ws + 1 ))
        ;;
    move0)
        swaymsg move container to workspace number 0
        swaymsg workspace 0
        ;;
    move1)
        swaymsg move container to workspace number 1
        swaymsg workspace 1
        ;;
    move2)
        swaymsg move container to workspace number 2
        swaymsg workspace 2
        ;;
    move3)
        swaymsg move container to workspace number 3
        swaymsg workspace 3
        ;;
    move4)
        swaymsg move container to workspace number 4
        swaymsg workspace 4
        ;;
    move5)
        swaymsg move container to workspace number 5
        swaymsg workspace 5
        ;;
    move6)
        swaymsg move container to workspace number 6
        swaymsg workspace 6
        ;;
    move7)
        swaymsg move container to workspace number 7
        swaymsg workspace 7
        ;;
    move8)
        swaymsg move container to workspace number 8
        swaymsg workspace 8
        ;;
    move9)
        swaymsg move container to workspace number 9
        swaymsg workspace 9
        ;;
    *)
        echo "miss arg"
esac
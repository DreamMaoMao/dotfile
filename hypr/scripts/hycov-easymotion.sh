#!/bin/bash

# handle() {
#   case $1 in
#     renameworkspace*)
#       workspace_name=$(hyprctl -j activeworkspace | jq -r '.name')
#       if [ "$workspace_name" != "OVERVIEW" ]; then
#         hyprctl dispatch easymotionexit
#         exit 0
#       fi
#       ;;
#   esac
# }

workspace_name=$(hyprctl -j activeworkspace | jq -r '.name')

if [ "$workspace_name" = "OVERVIEW" ]; then
    hyprctl dispatch hycov:leaveoverview
else
    hyprctl dispatch hycov:enteroverview
    hyprctl dispatch 'easymotion action:hyprctl --batch "dispatch hycov:leaveoverview"'
fi

# socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
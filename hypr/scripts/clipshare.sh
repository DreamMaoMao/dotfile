#!/bin/bash

# yay -S clipnotify xclip

while clipnotify; do
  selection="$(xclip -o -selection clipboard 2>/dev/null)"
  if [ $? -eq 0 ]; then
    printf "%s" "$selection" | wl-copy
  else
    wl-paste | xclip -i
  fi
done
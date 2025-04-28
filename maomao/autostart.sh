#! /bin/bash
# 自启动脚本 仅作参考

set +e

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

/usr/lib/xdg-desktop-portal-wlr &

swaync &
wlsunset -T 3501 -t 3500 &
swaybg -i ~/.config/maomao/wallpaper/room.png &
waybar -c ~/.config/maomao/waybar/config -s ~/.config/maomao/waybar/style.css &

wl-clip-persist --clipboard regular --reconnect-tries 0 &
wl-paste --type text --watch cliphist store & 

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &


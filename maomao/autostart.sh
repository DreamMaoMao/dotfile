#! /bin/bash
# 自启动脚本 仅作参考

set +e

# obs record
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
/usr/lib/xdg-desktop-portal-wlr &

# clipboard
wl-clip-persist --clipboard regular &
wl-paste --type text --watch cliphist store & 

# notify mananer
dunst &

# night light
wlsunset -T 3501 -t 3500 &

# wayllpaper
swaybg -i ~/.config/maomao/wallpaper/room.png &

# status bar
waybar -c ~/.config/maomao/waybar/config -s ~/.config/maomao/waybar/style.css &

# dpi setting
# echo "Xft.dpi: 140" | xrdb -merge #dpi缩放
# xrdb merge ~/.Xresources

# im input support
fcitx5 --replace -d &

# network tray
nm-applet &

# Authentication tool
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &


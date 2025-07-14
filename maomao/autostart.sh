#!/bin/bash
# 自启动脚本 仅作参考

set +e

# obs
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null 2>&1
/usr/lib/xdg-desktop-portal-wlr >/dev/null 2>&1 &

# notify
swaync -c ~/.config/maomao/swaync/config.json -s ~/.config/maomao/swaync/style.css >/dev/null 2>&1 &

# night light
wlsunset -T 3501 -t 3500 >/dev/null 2>&1 &

# wallpaper
swaybg -i ~/.config/maomao/wallpaper/czd.png >/dev/null 2>&1 &

# top bar
waybar -c ~/.config/maomao/waybar/config -s ~/.config/maomao/waybar/style.css >/dev/null 2>&1 &

# dock
lavalauncher -c ~/.config/maomao/lavalauncher/lavalauncher.conf >/dev/null 2>&1 &

# xwayland dpi scale
echo "Xft.dpi: 140" | xrdb -merge #dpi缩放
# xrdb merge ~/.Xresources >/dev/null 2>&1

# ime input
fcitx5 --replace -d >/dev/null 2>&1 &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &

# clipboard content manager
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &

# bluetooth 
blueman-applet >/dev/null 2>&1 &

# network
nm-applet >/dev/null 2>&1 &

# Permission authentication
/usr/lib/xfce-polkit/xfce-polkit >/dev/null 2>&1 &

# inhibit by audio
sway-audio-idle-inhibit >/dev/null 2>&1 &

# change light value and volume value by swayosd-client in keybind
swayosd-server >/dev/null 2>&1 &

#! /bin/bash
# 自启动脚本 仅作参考

set +e

# obs
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
/usr/lib/xdg-desktop-portal-wlr &

# notify
swaync &

# night light
wlsunset -T 3501 -t 3500 &

# wallpaper
swaybg -i ~/.config/maomao/wallpaper/czd.png &

# top bar
waybar -c ~/.config/maomao/waybar/config -s ~/.config/maomao/waybar/style.css &

# dock
lavalauncher -c ~/.config/maomao/lavalauncher/lavalauncher.conf &

# xwayland dpi scale
# echo "Xft.dpi: 140" | xrdb -merge #dpi缩放
xrdb merge ~/.Xresources

# ime input
fcitx5 --replace -d 2> /dev/null &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 &

# clipboard content manager
wl-paste --type text --watch cliphist store & 

# bluetooth 
blueman-applet &

# network
nm-applet &

# Permission authentication
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# for private use not for you
[ -e /dev/sda4 ] && udisksctl mount -t ext4 -b /dev/sda4

# idle to lightdown and shutdown screen
~/.config/maomao/scripts/idle.sh &

# inhibit by audio
sway-audio-idle-inhibit &

# change light value and volume value by swayosd-client in keybind
swayosd-server &


#! /bin/bash
# 自启动脚本 仅作参考

set +e


# systemctl --user unmask xdg-desktop-portal-hyprland
# systemctl --user mask xdg-desktop-portal-gnome

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

# /usr/lib/xdg-desktop-portal-hyprland &

swaync &
wlsunset -T 3501 -t 3500 &
swaybg -i ~/.config/maomao/wallpaper/room.png &
waybar -c ~/.config/maomao/waybar/config -s ~/.config/maomao/waybar/style.css &
echo "Xft.dpi: 140" | xrdb -merge #dpi缩放
# 开启输入法
fcitx5 --replace -d &

wl-clip-persist --clipboard regular &
wl-paste --type text --watch cliphist store & 
blueman-applet &
nm-applet &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
[ -e /dev/sda4 ] && udisksctl mount -t ext4 -b /dev/sda4
cp ~/.config/eww/System-Menu/eww.yuck.hyprland  ~/.config/eww/System-Menu/eww.yuck
eww daemon &

~/.config/hypr/scripts/idle.sh &
sway-audio-idle-inhibit &
swayosd-server &


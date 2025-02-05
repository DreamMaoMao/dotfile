#! /bin/bash
# DWL自启动脚本 仅作参考

set +e

pkill xdg
pkill clash

systemctl --user unmask xdg-desktop-portal-hyprland
systemctl --user mask xdg-desktop-portal-gnome

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

# /usr/lib/xdg-desktop-portal-wlr &
/usr/lib/xdg-desktop-portal-hyprland &

#mako &
# dunst -config ~/.config/dunst/dwl_dunstrc &
swaync &
wlsunset -T 3501 -t 3500 &
swaybg -i ~/Images/Fantasy-Medieval_Travern.png &
waybar -c ~/.config/plume/waybar/config -s ~/.config/plume/waybar/style.css &
echo "Xft.dpi: 140" | xrdb -merge #dpi缩放
# cp ~/.config/zellij/configwayland.kdl ~/.config/zellij/config.kdl
# cp ~/.config/fcitx/dwm_profile ~/.config/fcitx/profile -f
# 开启输入法
fcitx5 &
systemctl --user mask xdg-desktop-portal-gnome
systemctl --user mask xdg-desktop-portal-hyprland
# /usr/libexec/xdg-desktop-portal &

# mako & # 开启通知server

wl-clip-persist --clipboard regular &
# wl-paste -t text --watch clipman store --no-persist &
wl-paste --type text --watch cliphist store & 
blueman-applet &
nm-applet &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# numlockx on
[ -e /dev/sda4 ] && udisksctl mount -t ext4 -b /dev/sda4
python3 ~/tool/sign.py &
cp ~/.config/eww/System-Menu/eww.yuck.hyprland  ~/.config/eww/System-Menu/eww.yuck
eww daemon &

~/.config/hypr/scripts/idle.sh &
sway-audio-idle-inhibit &
swayosd-server &


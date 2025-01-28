#!/bin/bash
set +e
/usr/sbin/xwayland-satellite &


dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway &
waybar -c ~/.config/niri/waybar/config -s ~/.config/niri/waybar/style.css  &
swaybg -i ~/Images/Fantasy-Medieval_Travern.png  &
#init xdg portal
pkill xdg
pkill clash

# systemctl --user unmask xdg-desktop-portal-hyprland
# systemctl --user mask xdg-desktop-portal-gnome

/usr/lib/xdg-desktop-portal-hyprland &

# sets x11 dpi
xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1


#eww
cp ~/.config/eww/System-Menu/eww.yuck.hyprland  ~/.config/eww/System-Menu/eww.yuck
eww daemon &
#~/.config/hypr/scripts/start_noti.sh

#clipboard
wl-clip-persist --clipboard regular &
wl-paste --type text --watch cliphist store & 

# wl-paste -t text --watch clipman store --no-persist

#anther tool
#cp /home/wrq/.config/fcitx/hyprland_profile  /home/wrq/.config/fcitx/profile -f
fcitx5  &
wlsunset -T 3501 -t 3500 &
# fcitx
# hyprpaper &
# swaybg -i ~/Images/caoyuan.jpg &
#~/.config/hypr/scripts/wall ~/.config/hypr/wallpapers/1.jpg &
# dunst -config ~/.config/dunst/hypr_dunstrc &
swaync &
blueman-applet &
# waybar -c ~/.config/hypr/component/waybar/config -s ~/.config/hypr/component/waybar/style.css &
nm-applet &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

#auto mount disk
udisksctl mount -b /dev/sda4 &

# /bin/bash -c "sleep 3; /usr/bin/flameshot &"
#auto loockscreen and shutdown screen
~/.config/hypr/scripts/idle.sh &
# audio or keyboard mouse idle-inhibit
sway-audio-idle-inhibit &
# ~/tool/net_idleinhibit.sh

#light and volume panel
swayosd-server &

sleep 1s && echo "Xft.dpi: 140" | xrdb -merge

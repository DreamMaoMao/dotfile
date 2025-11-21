#!/bin/bash
set +e

# start xwayland
/usr/sbin/xwayland-satellite :12 &

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway &
waybar -c ~/.config/niri/waybar/config -s ~/.config/niri/waybar/style.css  &
swaybg -i ~/Images/room.png &
#init xdg portal
pkill xdg
pkill clash

systemctl --user unmask xdg-desktop-portal-hyprland
systemctl --user mask xdg-desktop-portal-gnome

/usr/lib/xdg-desktop-portal-hyprland &

#eww
cp ~/.config/eww/System-Menu/eww.yuck.hyprland  ~/.config/eww/System-Menu/eww.yuck
eww daemon &

#clipboard
wl-clip-persist --clipboard regular --reconnect-tries 0 &
wl-paste --type text --watch cliphist store & 

#anther tool
wlsunset -T 3501 -t 3500 &
swaync &
blueman-applet &
nm-applet &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

#auto mount disk
udisksctl mount -b /dev/sda4 &

#auto loockscreen and shutdown screen
~/.config/hypr/scripts/idle.sh &
# audio or keyboard mouse idle-inhibit
sway-audio-idle-inhibit &

#light and volume panel
swayosd-server &


# The following applications require some registration actions after xwayland launches

sleep 1s 
echo "Xft.dpi: 140" | xrdb -merge && xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1
fcitx5 --replace -d  &

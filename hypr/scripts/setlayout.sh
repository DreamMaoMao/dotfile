
current_ws=$(hyprctl activeworkspace | grep workspace |  awk '{print $3}')

hyprctl keyword workspace ${current_ws},layout:$1
#!/bin/bash

# --- 配置区域 ---
# 请将这里的路径替换为你真实的壁纸文件路径
DAY_WALLPAPER="$HOME/Images/snow.jpeg"
NIGHT_WALLPAPER="$HOME/Images/room.jpeg"

# 检查 swww 守护进程是否运行，没运行则启动
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.5 # 等待初始化
fi

CURRENT_HOUR=$(date +%H)

# 判断：如果是 06:00 到 17:59 之间为白天，否则（18:00之后或凌晨）为夜晚
if [ "$CURRENT_HOUR" -ge 6 ] && [ "$CURRENT_HOUR" -lt 18 ]; then
    echo "当前时间 $CURRENT_HOUR 点，正在切换至白天壁纸..."
    awww img "$DAY_WALLPAPER" --transition-type grow --transition-pos center
else
    echo "当前时间 $CURRENT_HOUR 点，正在切换至夜晚壁纸..."
    awww img "$NIGHT_WALLPAPER" --transition-type outer --transition-pos center
fi

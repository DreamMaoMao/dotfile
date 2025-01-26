#!/usr/bin/bash

# 1. 获取hyprctl workspaces的输出，并用grep和cut提取monitor后面的数字
numbers=$(hyprctl workspaces | grep monitor | cut -d " " -f 3)
# 2. 将数字存入一个数组，并用sort命令从小到大排序
array=($numbers)
sorted=($(printf "%s\n" "${array[@]}" | sort -n))
# 3. 获取hyprctl activeworkspace的输出，并用grep和cut提取monitor后面的数字
target=$(hyprctl activeworkspace | grep monitor | cut -d " " -f 3)
# 4. 在已排序的数字列表中查找目标数字，并返回下一个数字

#数组的长度
length=${#sorted[@]}
last=$(($length - 1))

for i in "${!sorted[@]}"; do
	if [ "${sorted[i]}" == "$target" ]; then
		if [[ "$i" == "$last" ]]; then
			next=0
			hyprctl dispatch workspace ${sorted[next]}
		else
			next=$((i + 1))
			hyprctl dispatch workspace ${sorted[next]}
		fi
		break
	fi
done

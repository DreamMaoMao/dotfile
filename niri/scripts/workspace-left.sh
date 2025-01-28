#!/bin/bash

# 获取当前工作区ID
current_workspace=$(niri msg workspaces | grep \* | awk '{print$2}')

no_empty_workspace=$(niri msg windows | grep Workspace | awk '{print$3}')

# 定义工作区总数
total_workspaces=10

# 初始化目标工作区ID
target_workspace=$current_workspace

# 向左遍历寻找非空工作区
for (( i=1; i<=$total_workspaces; i++ )); do
    # 计算上一个工作区ID
    prev_workspace=$((($current_workspace - $i +$total_workspaces) % $total_workspaces))
    if [ $prev_workspace -eq 0 ]; then
        prev_workspace=$total_workspaces
    fi
    
    # 检查上一个工作区是否有窗口
    if echo $no_empty_workspace | grep -w $prev_workspace; then
        target_workspace=$prev_workspace
        break
    fi
done

# 切换到找到的目标工作区
if [ "$target_workspace" != "$current_workspace" ]; then
    niri msg action focus-workspace $target_workspace
    echo "Switched to workspace: $target_workspace"
fi

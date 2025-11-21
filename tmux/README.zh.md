## 配置介绍:
有两种模式,宽松模式(默认),严格模式
严格模式只能使用一些通用快捷键,一般进入vim这种tui应用后可以切到严格模式避免快捷键冲突
宽松模式可以额外的一些Ctrl 和 Alt绑定的快捷键

## 通用快捷键
### 前缀按键(prefix-key)
Alt-u

### 严格模式和宽松模式切换 
Ctrl z

### window
|  表头   | 表头  |
|  ----  | ----  |
|创建win             |prefix-key+ m
|销毁win             |prefix-key+ n
|聚焦前一个win       |prefix-key+ y
|聚焦后一个win       |prefix-key+ u
|切换到win1          |prefix-key+ 1 
|切换到win2          |prefix-key+ 2 
|切换到win3          |prefix-key+ 3 
|切换到win4          |prefix-key+ 4 
|切换到win5          |prefix-key+ 5 
|切换到win6          |prefix-key+ 6 
|切换到win7          |prefix-key+ 7 
|切换到win8          |prefix-key+ 8 
|切换到win9          |prefix-key+ 9 
|重命名win           |prefix-key+ ,
|移动win到特定位置   |prefix-key+ .

### pane
|  表头   | 表头  |
|  ----  | ----  |
|pane移动到窗口1                     |prefix-key+ shift-1 
|pane移动到窗口2                     |prefix-key+ shift-2 
|pane移动到窗口3                     |prefix-key+ shift-3 
|pane移动到窗口4                     |prefix-key+ shift-4 
|pane移动到窗口5                     |prefix-key+ shift-5 
|pane移动到窗口6                     |prefix-key+ shift-6 
|pane移动到窗口7                     |prefix-key+ shift-7 
|pane移动到窗口8                     |prefix-key+ shift-8 
|pane移动到窗口9                     |prefix-key+ shift-9 
|向右分割pane                        |prefix-key+ p
|向下分割pane                        |prefix-key+ o
|聚焦左边pane                        |prefix-key+ h
|聚焦右边pane                        |prefix-key+ l
|聚焦上边pane                        |prefix-key+ k
|聚焦下边pane                        |prefix-key+ j
|全屏pane                            |prefix-key+ a
|删除pane                            |prefix-key+ i
|pane同步输入                        |prefix-key+ s
|全局选择一个pane放在当前pane右边    |prefix-key+ P
|全局选择一个pane放在当前pane下边    |prefix-key+ o
|把pane放到新窗口                    |prefix-key+ b
|跳转到特定数字pane                  |prefix-key+ q

### 定位
|  表头   | 表头  |
|  ----  | ----  |
|模糊名查找pane          |prefix-key+ f
|全局预览选择pane        |prefix-key+ w

### 配置
|  表头   | 表头  |
|  ----  | ----  |
|重载配置                |prefix-key+ r
|挂起session             |prefix-key+ d

### 复制粘贴
|  表头   | 表头  |
|  ----  | ----  |
|prefix-key+ [               |进入复制模式 
|方向按键/hjkl/HJKL      |移动光标 
|space                   |切入选中模式 
|方向按键/hjkl/HJKL      |移动选中 
|enter                   |确认选中 
|prefix-key+ ]/Ctrl + p      |粘贴
`提示:按住shift键就可以用鼠标进行常规的复制粘贴`

### 把整个终端的文本用$EDITOR编辑
这个功能允许你使用任何tui编辑器去编辑复制当前终端上的内容,比如nvim.
编辑器由`$EDITOR`环境变量确定
|  表头   | 表头  |
|  ----  | ----  |
|进入 | prefix-key e 

## 宽松模式可以使用的快捷键

### pane 
|  表头   | 表头  |
|  ----  | ----  |
|alt + h/j/k/l   |切换pane聚焦
|  表头   | 表头  |
|  ----  | ----  |
|alt + p         |水平分割pane
|alt + o         |垂直分割pane
|alt + i         |关闭pane
|C-x             |切换布局
|alt + ;         |顺时针交换窗口
|alt + '         |逆时针交换窗口

## pane大小调整
|  表头   | 表头  |
|  ----  | ----  |
|上         |C-k
|下         |C-j
|左         |C-t
|右         |C-r
|最大化     |C-f
`鼠标拖动也可以调整`

### window
|  表头   | 表头  |
|  ----  | ----  |
|alt + n         |创建新窗口
|alt + m         |关闭窗口
|ctlr + h        |切换到左边窗口
|ctrl + l        |切换到右边窗口
|Alt + =         |窗口向右移动         
|Alt + -         |窗口向左移动         


## tmux 常用命令
|  表头   | 表头  |
|  ----  | ----  |
|tmux                                           |创建新session
|tmux new -s <session-name>                     |创建指定名字的session
|tmux ls                                        |查看所有session
|tmux at                                        |连接到最新的session
|tmux rename-session <new-name>                 |重命名最近session
|tmux attach -t <session-name>                  |连接到指定名字session
|tmux rename-session -t <old-name> <new-name>   |重命名指定session
|tmux kill-session -t <session-name>            |杀死指定session
|tmux switch -t <session-name>                  |切换到指定session
|tmux kill-server                               |干掉所有,重新启动

### 在tmux命令输入框输入命令
prefix-key + :    (tab键可以打开命令提示)

## buffer
每次复制模式复制的东西都会存在一个单独的buffer里
打开编辑器
列出全部buffer `prefix-key + =`
选中按下enter就可以粘贴进去
清理buffer `prefix-key + -`

## session 保存与恢复
prefix-key + C-s    保存
prefix-key + C-r    恢复

## 非lock模式
### pane
删除pane alt i
向右拆分pane alt p
向下拆分pane alt o
切换pane alt h/j/k/l

### tab
新增tab alt n
删除tab alt m
左右切换tab ctrl h/l

## 通用模式
### pane
 p 是向右拆分
 o 是向下拆分
 i 是删除
 a 最大化

### tab
 n 是新增
 m 是关闭
 s tab同步输入
 [ 把pane移动到左边的tab
 ] 把pane移动到右边的tab
 b 把pane放到一个新的tab

### scrool
 j/k 移动一行
 J/K 移动半页
 alt j/k 移动一页
 s 搜索模式
 e 编辑模式,可以把终端内容放到编辑器中操作(复制终端内容)


## lock 模式
 lock 模式可以避免zellij的快捷键对tui应用快捷键的冲突,从而专注于内部的tui应用

## tab 同步输入
想要同时在窗格 A、B 和 C 中执行相同的命令，那么您就可以开启同步输入。这样您在窗格 A 中输入的内容会自动复制到窗格 B 和 C 中，然后一起执行。这样您就可以一次性操作多个窗格，而不用重复输入相同的命令。
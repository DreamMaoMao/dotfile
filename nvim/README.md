
# 杂项
n模式 ctrl +w 打开窗口管理操作选择
n模式 space是leader键 按下打开自定义的插件操作选项
n模式 文件管理器 是spacce e
n模式 文件浏览器按下s是分割
n模式 ctrl+ w  c  关闭分割的窗口
n模式 终端是ctrl+/
n模式 文件管理器光标处按? 打开文件管理操作帮助
i模式 jj 相当于esc
n模式 ; 先当于:
n模式 u 是撤回
n模式 ctrl + r 是redo
ctrl + s 保存文件
n 模式 space + a 保存文件
ctrl + c 查看16进制颜色值的颜色
n模式 space + v 等同于ctrl +v 进入视图模式
v 模式space + k 等于按下esc 
n 模式 /   打开文本搜索输入框,输入后回车按n下一个 N上一个 


# 终端
n模式 space t t打开,后面通过ctrl +\ 打开和关闭
t模式 连续按两下esc esc键退出t模式
n模式 退出t模式按下数字再按下ctrl+\ 打开特定的数字终端
t模式 ctrl + h 或者l移动终端焦点 
n模式 更多操作 请按下space t
n模式 可以space w d关闭窗口终端,因为他也是个窗口
n模式 space it 打开一个浮动对话终端,关闭不会更改上下文


# 窗口操作
n模式 space wd 关闭一个窗口
n模式 space | 垂直分割一个窗口
n模式 space - 水平分割一个窗口
ctrl +h/l 左右移动窗口的焦点
ctrl +j/k 上下移动窗口的焦点

# 注释
n模式 gcip 注释和取消注释块
n模式 gcc 注释和取消注释行
v模式 gc  注销和取消注销选中的块

# 标签操作
n模式 ctrl + hl 切换文本区和文件浏览器
n模式 alt 加和hl 移动标签焦点
n模式 space ft 跳转选择标签 
n模式 space bd 关闭标签
n模式 更多操作 请按下 space b

# 查找
整个文件夹中查找字符串
space fg

查找文件
space ff

当前文本查找
:/

# 移动
n 模式按下s 光标跳转
space + j 启动跳转视图,这个焦点不在编辑区也能用
n模式S 代码块选中区域选择

上下左右方向键移动
hjkl 移动

i 模式下 ctrl + h/l  字母移动
n v 模式shift + h/l  单词移动
n v 模式shift+ j/k  上下移动5行
alt + j/k  翻页
v 模式';'键 移动光标到一下个';'处

# 文件操作
space gj 打开joshuto
space gy 打开yazi

# 差异对比
space df  显示项目所有文件按照commit组织的更改历史
space dm  显示项目跟主分支的文件差异
space dc  关闭diffview
space de  显示当前文件的历史提交差异
space dr  刷新diffview
键盘滚动是可以同步滚动的,

鼠标需要分别点击一下第一个再点击一下第二个窗口,再进行滚动(鼠标放在中间的行号上)
[c  跳到上一个差异的地方
]c  跳到下一个差异的地方
tab选择下一个差异文件

# 全局查找替换
n模式 space + rc  只替换当前文件(自动选中word)
n模式 space + re  只替换当前文件(搜索粘贴板上的字符串)
n模式 space + rt 全局文件夹(触发面板弹出)
v模式 space + rs 全局文件夹(搜索选中的字符串)
?触发选项查看
dd 确定那些不用替换
space ri 触发大小写敏感切换
space rw 切换是否只是匹配word
space rh 切换是否搜索隐藏文件
space ra 替换全部
space ro 查看选项
space rv 切换替换后的预览视图

# 代码跳转
<!-- ctrl + ] 跳转到定义 -->
<!-- ctrl + t 跳转回来 -->
space is 查看定义
space id 跳转定义
space ig 跳转返回
space ih 查看文档
space if 查看refer
space ss 查看当前文件的所有符号
space sS 查看当前工作区的所有符号


# 打标签
space + mt  查看标签/退出查看
space + ma  打标签
space + md  删除标签(文件页面标签行)


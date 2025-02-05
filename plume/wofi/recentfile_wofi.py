#!/usr/bin/env python
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib
from urllib.parse import unquote # 导入 unquote 函数
import os
import json
import subprocess
import sys
import wofi

os.environ["WAYLAND_DISPLAY"] = "wayland-1"
os.environ["GDK_BACKEND"] = "wayland"
# 创建一个 Wofi 对象
w = wofi.Wofi()

recent=[]

# 创建一个 RecentManager 对象
manager = Gtk.RecentManager.get_default()

# 获取最近使用的文件列表
items = manager.get_items()

# 打印每个文件的 URI 和 MIME 类型
for item in items:
    uri = item.get_uri() # 获取 URI
    filename = unquote(uri).replace("file://","") # 解码 URI
    if item.get_mime_type() != 'inode/directory' and os.path.exists(filename):
        recent.append(filename)


if len(recent) < 1:
    recent.append("浏览器已经占用历史记录数据库")
else:
    # 用 Wofi 来显示列表，并返回用户选择的索引
    index, key = w.select('RecentFIle', recent)

    # 如果用户没有取消，打印出选择的条目
    if index != -1:
        subprocess.Popen("xdg-open  '{0}'".format(recent[index]), shell=True)
    else:
        print("你没有选择任何东西")




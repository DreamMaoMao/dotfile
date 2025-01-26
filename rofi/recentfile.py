#!/usr/bin/env python
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib
from urllib.parse import unquote # 导入 unquote 函数
import os
import json
import subprocess
import sys

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

# 设置与rofi-block通信格式
data_format = r"""
{
    "input action":"send",
	"prompt":"󰄛 RecentFile",
	"event format":""
}
"""
if len(recent) < 1:
    recent.append("浏览器已经占用历史记录数据库")
jt = json.loads(data_format)
jt["lines"]=recent
jt["event format"] = r"{{name_enum}}--{{value}}"
print(json.dumps(jt), flush=True)

# 阻塞读取rofi的标注输入
for rofi_input_date in sys.stdin:
    rofi_input_date = rofi_input_date.rstrip("\n")
    rofi_input_date_list = rofi_input_date.split("--")  # 分离事件和输入
    rofi_input_date_event = rofi_input_date_list[0]  # 事件
    rofi_input_date_value = rofi_input_date_list[1]  # 输入
    if rofi_input_date_event == "INPUT_CHANGE":  # 输入改变
        result = []
        for r in recent:
            if rofi_input_date_value in r:
                result.append(r)
        output_rofi_date = {'lines': result}
        print(json.dumps(output_rofi_date), flush=True)
    elif rofi_input_date_event == "SELECT_ENTRY":
        subprocess.Popen("xdg-open  '{0}'".format(rofi_input_date_value), shell=True)
        break

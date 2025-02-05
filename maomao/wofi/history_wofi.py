#!/usr/bin/env python

import sys
import json
import subprocess
from sqlite3 import Connection
import os
import wofi

os.environ["WAYLAND_DISPLAY"] = "wayland-1"
os.environ["GDK_BACKEND"] = "wayland"
# 创建一个 Wofi 对象
w = wofi.Wofi()

# 数据库路径
database_path = "{0}/.config/google-chrome/Default/History".format(
    os.environ['HOME'])

history = []


try:
    # 创建数据库连接并创建光标
    conn = Connection(database_path)
    cursor = conn.cursor()
    # 执行查询语句
    urls = cursor.execute(
        "select title,url,last_visit_time  from urls order by last_visit_time desc").fetchall()
    for i in urls:
        history.append("{0}~~~{1}".format(i[0], i[1]))
except Exception as e:
    # 关闭连接和光标
    cursor.close()
    conn.close()



if len(history) < 1:
    history.append("浏览器已经占用历史记录数据库")
else:
    # 用 Wofi 来显示列表，并返回用户选择的索引
    index, key = w.select('History', history[0:100])

    # 如果用户没有取消，打印出选择的条目
    if index != -1:
        url = history[index].split("~~~")[1]
        subprocess.Popen("google-chrome  '{0}'".format(url), shell=True)
    else:
        print("你没有选择任何东西")



# subprocess.Popen("google-chrome  '{0}'".format(url), shell=True)


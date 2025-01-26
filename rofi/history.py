#!/usr/bin/env python

import sys
import json
import subprocess
from sqlite3 import Connection
import os
import shutil

# 数据库路径
database_path = "{0}/.config/google-chrome/Default/History-temp".format(
    os.environ['HOME'])

shutil.copyfile("{0}/.config/google-chrome/Default/History".format(
    os.environ['HOME'])
, database_path)


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


# 设置与rofi-block通信格式
data_format = r"""
{
    "input action":"send",
	"prompt":"󰄛 History",
	"event format":""
}
"""
if len(history) < 1:
    history.append("浏览器已经占用历史记录数据库")
jt = json.loads(data_format)
jt["lines"] = history
jt["event format"] = r"{{name_enum}}-##-{{value}}"
print(json.dumps(jt), flush=True)


# 阻塞读取rofi的标注输入
for rofi_input_date in sys.stdin:
    rofi_input_date = rofi_input_date.rstrip("\n")
    rofi_input_date_list = rofi_input_date.split("-##-")  # 分离事件和输入
    rofi_input_date_event = rofi_input_date_list[0]  # 事件
    rofi_input_date_value = rofi_input_date_list[1]  # 输入
    if rofi_input_date_event == "INPUT_CHANGE":  # 输入改变
        result = []
        for h in history:
            if rofi_input_date_value in h:
                result.append(h)
        output_rofi_date = {'lines': result}
        print(json.dumps(output_rofi_date), flush=True)
    elif rofi_input_date_event == "SELECT_ENTRY":
        # 关闭连接和光标
        cursor.close()
        conn.close()
        url = rofi_input_date_value.split("~~~")[1]  # 分离输入中的key和value
        subprocess.Popen("google-chrome  '{0}'".format(url), shell=True)
        break

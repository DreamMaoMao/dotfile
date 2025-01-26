#!/usr/bin/env python

import json
import sys
import re
import requests
import subprocess
from bs4 import BeautifulSoup
# import pyperclip

# 导入线程模块和时间模块
import threading
import time

# 看门狗的食物,共享变量,5表示五次
#0.1 毫秒喂一次狗,五次不喂,狗就叫
dog_food = 3

suggest_key = ""
suggest_value = ""

start = False

google_header = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Encoding': 'gzip, deflate',
    'Accept-Language': 'zh-CN,zh;q=0.9',
    'Host': 'suggestqueries.google.com',
    'Proxy-Connection': 'keep-alive',
    'Upgrade-Insecure-Requests': '1',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36'
}

bing_header = {
    'Accept-Ch': 'Sec-CH-UA-Bitness, Sec-CH-UA-Arch, Sec-CH-UA-Full-Version, Sec-CH-UA-Mobile, Sec-CH-UA-Model, Sec-CH-UA-Platform-Version, Sec-CH-UA-Full-Version-List, Sec-CH-UA-Platform, Sec-CH-UA, UA-Bitness, UA-Arch, UA-Full-Version, UA-Mobile, UA-Model, UA-Platform-Version, UA-Platform, UA',
    'Content-Type': 'text/html; charset=utf-8',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.43'
}

bilibili_header = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'zh-CN,zh;q=0.9',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.43'
}

db_header = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Encoding': 'gzip, deflate',
    'Accept-Language': 'zh-CN,zh;q=0.9',
    'Cookie':'bid=3dwHg3v0bd4; __utmz=30149280.1699686065.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ll="118289"; _pk_id.100001.4cf6=3d915d59986c2438.1699688121.; _vwo_uuid_v2=D2B5305D3FEE0F9D52B862E2D82892CAD|897ff446647f231bbfd8b8fe5874c6e7; push_noty_num=0; push_doumail_num=0; __utmv=30149280.22867; __yadk_uid=x6GzT2W9Si2OLCoSxOjG0faBBhzKUQOT; __utma=30149280.1131843939.1699686065.1702121686.1702184969.20; __utma=223695111.1554346841.1699688121.1702034470.1702184971.12; __utmz=223695111.1702184971.12.5.utmcsr=search.douban.com|utmccn=(referral)|utmcmd=referral|utmcct=/movie/subject_search; _pk_ref.100001.4cf6=%5B%22%22%2C%22%22%2C1702279076%2C%22https%3A%2F%2Fsearch.douban.com%2Fmovie%2Fsubject_search%3Fsearch_text%3D%E4%B8%80%E5%BF%B5%E5%85%B3%E5%B1%B1%26cat%3D1002%22%5D; douban-fav-remind=1; dbcl2="228674867:JzeP/1LlaW0"; ck=P1rG',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.43'
}

bd_header = {
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'zh-CN,zh;q=0.9',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.43'
}

dg_header = {
    'Accept':'*/*',
    'Accept-Encoding':'gzip',
    'Accept-Language':'zh-CN,zh;q=0.9',
    'Referer':'https://duckduckgo.com/',
    'User-Agent':'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
}

search_source = {
    "go": r"https://www.google.com/search?q={q}",
    "bi": r"https://www.bing.com/search?q={q}",
    "bl": r"https://search.bilibili.com/all?keyword={q}",
    "db": r"https://search.douban.com/movie/subject_search?search_text={q}&cat=1002",
    "bd": r"https://www.baidu.com/#ie=UTF-8&wd={q}",
    "dg": r"https://duckduckgo.com/?t=h_&q={q}"
}

suggest_source = {
    "go": r"http://suggestqueries.google.com/complete/search?client=chrome&hl=$lang&gl=us&q={q}",
    "bi": r"https://www.bing.com/AS/Suggestions?pt=page.home&mkt=zh-cn&qry={q}&cp=3&css=1&msbqf=false&cvid=4D5CE9FE7C7C46E8AD6F74F3B9779E76",
    "bl": r"https://s.search.bilibili.com/main/suggest?func=suggest&suggest_type=accurate&sub_type=tag&main_ver=v1&highlight=&userid=&bangumi_acc_num=1&special_acc_num=1&topic_acc_num=1&upuser_acc_num=3&tag_num=10&special_num=10&bangumi_num=10&upuser_num=3&term={q}&rnd=0.7823559084946734&buvid=EC634950-D7D1-97F4-4D39-FDF868B5E7B705610infoc&spmid=333.1007",
    "db": r"https://movie.douban.com/j/subject_suggest?q={q}",
    "bd": r"http://www.baidu.com/sugrec?pre=1&p=3&ie=utf-8&json=1&prod=pc&from=pc_web&sugsid=31726,1468,31672,21112,31111,31591,31605,31464,30823&wd={q}&csor=4&pwd=isn",
    "dg": r"https://duckduckgo.com/ac/?q={q}&kl=wt-wt"
}


proxies = {
    "http": "http://127.0.0.1:7890",
    "https": "http://127.0.0.1:7890",
}


valid_key = ["go","bi","bl","db","bd","dg"]

def search(value):
    url = search_source[key].replace(r"{q}", value)
    subprocess.Popen(
        "google-chrome  '{0}'".format(url), shell=True)


def suggest(key, value):
    if key == "go":
        result = []
        url = suggest_source[key].replace(r"{q}", value)
        try:
            res = requests.get(url=url, headers=google_header, proxies=proxies)
            result = json.loads(res.text)[1]
        except:
            result.append("网络异常,请检查是否已经开启了代理")
        return result
    elif key == "dg":
        result = []
        url = suggest_source[key].replace(r"{q}", value)
        try:
            res = requests.get(url=url, headers=dg_header, proxies=proxies)
            res_list = json.loads(res.text)
            for it in res_list:
                result.append(it["phrase"])
        except:
            result.append("网络异常,请检查是否已经开启了代理")
        return result
    elif key == "bi" and value:
        result = []
        url = suggest_source[key].replace(r"{q}", value)
        res = requests.get(url=url, headers=bing_header)
        bs = BeautifulSoup(res.text, "html.parser")
        try:
            uls = bs.find_all("ul", class_="sa_drw")
            lilist = uls[0].find_all("li")
            for li in lilist:
                query = li.get('query')
                result.append(query)
        except:
            result.append("bi请求异常")
        return result
    elif key == "bl" and value:
        result = []
        url = suggest_source[key].replace(r"{q}", value)
        res = requests.get(url=url, headers=bilibili_header)
        try:
            res_dict = json.loads(res.text)
            for su in res_dict['result']['tag']:
                result.append(su['value'])
        except:
            result.append("bl请求异常")
        return result
    elif key == "db" and value:
        result = []
        url = suggest_source[key].replace(r"{q}", value)
        try:
            res = requests.get(url=url, headers=db_header)
            res_dict = json.loads(res.text)
            for su in res_dict:
                result.append(su['title'])
        except Exception as e:
            result.append(str(e))
        return result
    elif key == "bd" and value:
        result = []
        url = suggest_source[key].replace(r"{q}", value)
        res = requests.get(url=url, headers=bd_header)
        try:
            res_dict = json.loads(res.text)
            for su in res_dict['g']:
                result.append(su['q'])
        except:
            result.append("bd请求异常")
        return result


# 设置与rofi-block通信格式
data_format = r"""
{
    "input action":"send",
	"prompt":"󰄛 WebSearch",
	"event format":""
}
"""
jt = json.loads(data_format)
jt["event format"] = r"{{name_enum}}--{{value}}"
print(json.dumps(jt), flush=True)


# 看门狗子线程函数
def wathch_dog():
    # 使用全局变量
    global dog_food
    # 循环执行
    while True:
        # 每隔一毫秒,狗食减一
        time.sleep(0.1)
        # 判断还有没有狗食
        if dog_food > 0:
            dog_food = dog_food - 1
        elif dog_food == 0:
            suggest_items = suggest(suggest_key, suggest_value)  # 查找建议
            if suggest_items:
                suggest_items.insert(0, suggest_value)  # 将原始输入的value作为item第一条
                output_rofi_date = {'lines': suggest_items}
            else:
                suggest_items = []
                suggest_items.append(suggest_value)
                output_rofi_date = {'lines': suggest_items}
            print(json.dumps(output_rofi_date), flush=True)
            dog_food = dog_food - 1
        else:
            pass

# 创建看门狗子线程对象
dog = threading.Thread(target=wathch_dog)
# 主线程作为守护
dog.setDaemon(True)

# 阻塞读取rofi的标注输入
for rofi_input_date in sys.stdin:
    rofi_input_date = rofi_input_date.rstrip("\n")
    rofi_input_date_list = rofi_input_date.split("--")  # 分离事件和输入
    rofi_input_date_event = rofi_input_date_list[0]  # 事件
    rofi_input_date_value = rofi_input_date_list[1]  # 输入
    rofi_input_date_value_list = re.sub(
        " +", " ", rofi_input_date_value).split(" ")  # 分离输入中的key和value
    if rofi_input_date_event == "INPUT_CHANGE":  # 输入改变
        key = rofi_input_date_value_list[0]
        value = " ".join(rofi_input_date_value_list[1:])
        suggest_value = value
        suggest_key = key

        if key in valid_key and value:
            source_value = []
            source_value.append(value)
            output_rofi_date = {'lines': source_value}
            print(json.dumps(output_rofi_date), flush=True)
            if start == False:
                start = True
                dog.start()
            # 狗的食物恢复到五个
            dog_food = 3
    elif rofi_input_date_event == "SELECT_ENTRY":
        search(rofi_input_date_value)  # 跳到浏览器中相应的搜索引擎搜索选中的item
        break

#!/usr/bin/env lua

local sqlite3 = require("lsqlite3")
local json = require("dkjson")

-- 配置路径
local home = os.getenv("HOME")
local history_db = home .. "/.config/google-chrome/Default/History"
local temp_db = home .. "/.config/google-chrome/Default/History-temp"

-- 复制数据库避免锁定
os.execute("cp -f '" .. history_db .. "' '" .. temp_db .. "'")

local history = {}

-- 读取历史记录
local db = sqlite3.open(temp_db)
if db then
    local stmt = db:prepare("SELECT title, url, last_visit_time FROM urls ORDER BY last_visit_time DESC")
    if stmt then
        for row in stmt:nrows() do
            table.insert(history, row.title .. "~~~" .. row.url)
        end
        stmt:finalize()
    else
        table.insert(history, "查询失败")
    end
    db:close()
else
    table.insert(history, "无法打开浏览器历史数据库")
end

-- 初始化 rofi 数据格式
local rofi_data = {
    ["input action"] = "send",
    prompt = "󰄛 History",
    ["event format"] = "{{name_enum}}-##-{{value}}",
    lines = history
}

-- 输出初始数据
print(json.encode(rofi_data, { indent = false }))
io.flush()

-- 匹配函数
local function matches(item, keyword)
    -- 将关键词按空格分割成多个字段
    local keywords = {}
    for word in keyword:gmatch("%S+") do
        table.insert(keywords, word:lower())
    end

    -- 如果只有一个字段，则匹配该字段即可
    if #keywords == 1 then
        return item:lower():find(keywords[1], 1, true) ~= nil
    end

    -- 如果有多个字段，则需要同时匹配所有字段
    for _, word in ipairs(keywords) do
        if not item:lower():find(word, 1, true) then
            return false
        end
    end
    return true
end

-- 事件处理循环
for line in io.lines() do
    local event, value = line:match("^(.-)%-%#%#%-(.*)$")
    if event == "INPUT_CHANGE" then
        local results = {}
        for _, item in ipairs(history) do
            if matches(item, value) then
                table.insert(results, item)
            end
        end
        print(json.encode({ lines = results }, { indent = false }))
        io.flush()
        
    elseif event == "SELECT_ENTRY" then
        local url = select(2, value:match("^(.-)~~~(.*)$"))
        os.execute("google-chrome '" .. url:gsub("'", "'\\''") .. "' &")
        break
    end
end
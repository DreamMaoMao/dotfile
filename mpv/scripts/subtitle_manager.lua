local utils = require 'mp.utils'

-- 参数设置
local subtitlesPerPage = 10
local closeAfterLoad = true
local rate = 1.5

-- 全局变量和实用函数
local styleOn = mp.get_property("osd-ass-cc/0")
local subtitles = {}
local currentSlot = 1
local currentPage = 1
local maxPage = 1
local active = false

-- 控制列表
local subtitleControls = {
  ESC = function() abort("") end,
  e = function() abort("") end,
  DOWN = function() jumpSlot(1) end,
  UP = function() jumpSlot(-1) end,
  j = function() jumpSlot(1) end,
  k = function() jumpSlot(-1) end,
  RIGHT = function() jumpPage(1) end,
  LEFT = function() jumpPage(-1) end,
  ENTER = function() loadSubtitle(currentSlot) end,
  KP_ENTER = function() loadSubtitle(currentSlot) end
}

local subtitleFlags = {
  DOWN = {repeatable = true},
  UP = {repeatable = true},
  RIGHT = {repeatable = true},
  LEFT = {repeatable = true}
}

-- 激活自定义控件
function activateControls(name, controls, flags)
  for key, func in pairs(controls) do
    mp.add_forced_key_binding(key, name..key, func, flags[key])
  end
end

-- 取消激活自定义控件
function deactivateControls(name, controls)
  for key, _ in pairs(controls) do
    mp.remove_key_binding(name..key)
  end
end

-- 实用函数
function fileExists(path)
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- 加载字幕列表
function listSubtitles()
  subtitles = {}
  local tracks = mp.get_property_native("track-list")
  for _, track in ipairs(tracks) do
    if track.type == "sub" then
      table.insert(subtitles, track)
    end
  end
  calcPages()
end

-- 计算当前页和总页数
function calcPages()
  currentPage = math.floor((currentSlot - 1) / subtitlesPerPage) + 1
  if currentPage == 0 then currentPage = 1 end
  maxPage = math.floor((#subtitles - 1) / subtitlesPerPage) + 1
  if maxPage == 0 then maxPage = 1 end
end

-- 获取指定页的字幕数量
function getAmountSubtitlesOnPage(page)
  local n = subtitlesPerPage
  if page == maxPage then n = #subtitles % subtitlesPerPage end
  if n == 0 then n = subtitlesPerPage end
  if #subtitles == 0 then n = 0 end
  return n
end

-- 获取指定页的第一个字幕索引
function getFirstSlotOnPage(page)
  return (page - 1) * subtitlesPerPage + 1
end

-- 获取指定页的最后一个字幕索引
function getLastSlotOnPage(page)
  local endSlot = getFirstSlotOnPage(page) + getAmountSubtitlesOnPage(page) - 1
  if endSlot > #subtitles then endSlot = #subtitles end
  return endSlot
end

-- 跳到指定数量的字幕前或后
function jumpSlot(i)
  currentSlot = currentSlot + i
  local startSlot = getFirstSlotOnPage(currentPage)
  local endSlot = getLastSlotOnPage(currentPage)

  if currentSlot < startSlot then currentSlot = endSlot end
  if currentSlot > endSlot then currentSlot = startSlot end

  displaySubtitles()
end

-- 跳到指定数量的页前或后
function jumpPage(i)
  local oldPos = currentSlot - getFirstSlotOnPage(currentPage) + 1
  currentPage = currentPage + i
  if currentPage < 1 then currentPage = maxPage + currentPage end
  if currentPage > maxPage then currentPage = currentPage - maxPage end

  local subtitlesOnPage = getAmountSubtitlesOnPage(currentPage)
  if oldPos > subtitlesOnPage then oldPos = subtitlesOnPage end
  currentSlot = getFirstSlotOnPage(currentPage) + oldPos - 1

  displaySubtitles()
end

-- 显示当前页的字幕
function displaySubtitles()
  -- 确定当前页的第一个和最后一个字幕索引
  local startSlot = getFirstSlotOnPage(currentPage)
  local endSlot = getLastSlotOnPage(currentPage)

  -- 准备显示的文本并显示
  local display = styleOn .. "{\\b1}Subtitles page " .. currentPage .. "/" .. maxPage .. ":{\\b0}"
  for i = startSlot, endSlot do
    local sub = subtitles[i]
    local selection = ""
    if i == currentSlot then
      selection = "{\\b1}{\\c&H00FFFF&}>"
    end
    display = display .. "\n" .. selection .. i .. ": " .. (sub.title or sub.lang or sub.src) .. "{\\r}"
  end
  mp.osd_message(display, rate)
end

-- 加载指定的字幕
function loadSubtitle(slot)
  if slot >= 1 and slot <= #subtitles then
    local sub = subtitles[slot]
    mp.set_property_native("sid", sub.id)
    mp.osd_message(string.format("Loaded subtitle: %s", sub.title or sub.lang or sub.src), 2)
    if closeAfterLoad then
      abort(styleOn.."{\\c&H00FF00&}{\\b1}Successfully loaded subtitle:{\\r}\n"..(sub.title or sub.lang or sub.src))
    end
  else
    abort(styleOn.."{\\c&H0000FF&}{\\b1}Can't find the subtitle at slot " .. slot)
  end
end

-- 定时器
local timer = mp.add_periodic_timer(rate * 0.95, displaySubtitles)
timer:kill()


-- 终止程序
function abort(message)
  mode = "none"
  deactivateControls("subtitle", subtitleControls)
  timer:kill()
  mp.osd_message(message)
  active = false
end

-- 处理字幕菜单的状态
function handler()
  if active then
    abort("")
  else
    activateControls("subtitle", subtitleControls, subtitleFlags)
    listSubtitles()
    displaySubtitles()
    timer:resume()
    active = true
  end
end

-- 注册脚本消息
mp.register_script_message("subtitle-menu", handler)
local utils = require 'mp.utils'

-- 参数设置
local audioTracksPerPage = 10
local closeAfterLoad = true
local rate = 1.5

-- 全局变量和实用函数
local styleOn = mp.get_property("osd-ass-cc/0")
local audioTracks = {}
local currentSlot = 1
local currentPage = 1
local maxPage = 1
local active = false

-- 控制列表
local audioTrackControls = {
  ESC = function() abort("") end,
  e = function() abort("") end,
  DOWN = function() jumpSlot(1) end,
  UP = function() jumpSlot(-1) end,
  j = function() jumpSlot(1) end,
  k = function() jumpSlot(-1) end,
  RIGHT = function() jumpPage(1) end,
  LEFT = function() jumpPage(-1) end,
  ENTER = function() loadAudioTrack(currentSlot) end,
  KP_ENTER = function() loadAudioTrack(currentSlot) end
}

local audioTrackFlags = {
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

-- 加载音轨列表
function listAudioTracks()
  audioTracks = {}
  local tracks = mp.get_property_native("track-list")
  for _, track in ipairs(tracks) do
    if track.type == "audio" then
      table.insert(audioTracks, track)
    end
  end
  calcPages()
end

-- 计算当前页和总页数
function calcPages()
  currentPage = math.floor((currentSlot - 1) / audioTracksPerPage) + 1
  if currentPage == 0 then currentPage = 1 end
  maxPage = math.floor((#audioTracks - 1) / audioTracksPerPage) + 1
  if maxPage == 0 then maxPage = 1 end
end

-- 获取指定页的音轨数量
function getAmountAudioTracksOnPage(page)
  local n = audioTracksPerPage
  if page == maxPage then n = #audioTracks % audioTracksPerPage end
  if n == 0 then n = audioTracksPerPage end
  if #audioTracks == 0 then n = 0 end
  return n
end

-- 获取指定页的第一个音轨索引
function getFirstSlotOnPage(page)
  return (page - 1) * audioTracksPerPage + 1
end

-- 获取指定页的最后一个音轨索引
function getLastSlotOnPage(page)
  local endSlot = getFirstSlotOnPage(page) + getAmountAudioTracksOnPage(page) - 1
  if endSlot > #audioTracks then endSlot = #audioTracks end
  return endSlot
end

-- 跳到指定数量的音轨前或后
function jumpSlot(i)
  currentSlot = currentSlot + i
  local startSlot = getFirstSlotOnPage(currentPage)
  local endSlot = getLastSlotOnPage(currentPage)

  if currentSlot < startSlot then currentSlot = endSlot end
  if currentSlot > endSlot then currentSlot = startSlot end

  displayAudioTracks()
end

-- 跳到指定数量的页前或后
function jumpPage(i)
  local oldPos = currentSlot - getFirstSlotOnPage(currentPage) + 1
  currentPage = currentPage + i
  if currentPage < 1 then currentPage = maxPage + currentPage end
  if currentPage > maxPage then currentPage = currentPage - maxPage end

  local audioTracksOnPage = getAmountAudioTracksOnPage(currentPage)
  if oldPos > audioTracksOnPage then oldPos = audioTracksOnPage end
  currentSlot = getFirstSlotOnPage(currentPage) + oldPos - 1

  displayAudioTracks()
end

-- 显示当前页的音轨
function displayAudioTracks()
  -- 确定当前页的第一个和最后一个音轨索引
  local startSlot = getFirstSlotOnPage(currentPage)
  local endSlot = getLastSlotOnPage(currentPage)

  -- 准备显示的文本并显示
  local display = styleOn .. "{\\b1}Audio Tracks page " .. currentPage .. "/" .. maxPage .. ":{\\b0}"
  for i = startSlot, endSlot do
    local track = audioTracks[i]
    if (track.title or track.lang or track.src) == nil then
      goto nextSlot
    end
    local selection = ""
    if i == currentSlot then
      selection = "{\\b1}{\\c&H00FFFF&}>"
    end
    display = display .. "\n" .. selection .. i .. ": " .. (track.title or track.lang or track.src) .. "{\\r}"
    ::nextSlot::
  end
  mp.osd_message(display, rate)
end

-- 加载指定的音轨
function loadAudioTrack(slot)
  if slot >= 1 and slot <= #audioTracks then
    local track = audioTracks[slot]
    if (track.title or track.lang or track.src) == nil then
      abort(styleOn.."{\\c&H0000FF&}{\\b1}Can't find the audio track at slot " .. slot)
      return
    end
    mp.set_property_native("aid", track.id)
    mp.osd_message(string.format("Loaded audio track: %s", track.title or track.lang or track.src), 2)
    if closeAfterLoad then
      abort(styleOn.."{\\c&H00FF00&}{\\b1}Successfully loaded audio track:{\\r}\n"..(track.title or track.lang or track.src))
    end
  else
    abort(styleOn.."{\\c&H0000FF&}{\\b1}Can't find the audio track at slot " .. slot)
  end
end

-- 定时器
local timer = mp.add_periodic_timer(rate * 0.95, displayAudioTracks)
timer:kill()

-- 终止程序
function abort(message)
  mode = "none"
  deactivateControls("audio", audioTrackControls)
  timer:kill()
  mp.osd_message(message)
  active = false
end

-- 处理音轨菜单的状态
function handler()
  if active then
    abort("")
  else
    activateControls("audio", audioTrackControls, audioTrackFlags)
    listAudioTracks()
    displayAudioTracks()
    timer:resume()
    active = true
  end
end

-- 注册脚本消息
mp.register_script_message("audio-menu", handler)
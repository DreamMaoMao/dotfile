-- stylua: ignore

local INPUT_KEY = {
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
	"X", "Y", "Z",

	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
	"o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2"
, "3", "4", "5", "6", "7", "8", "9", "-", "_", ".", "<Esc>", "<Space>", "<Enter>", "<Backspace>"
}

local INPUT_CANDS = {
	{ on = "A" }, { on = "B" }, { on = "C" }, { on = "D" }, { on = "E" },
	{ on = "F" }, { on = "G" }, { on = "H" }, { on = "I" }, { on = "J" },
	{ on = "K" }, { on = "L" }, { on = "M" }, { on = "N" }, { on = "O" },
	{ on = "P" }, { on = "Q" }, { on = "R" }, { on = "S" }, { on = "T" },
	{ on = "U" }, { on = "V" }, { on = "W" }, { on = "X" }, { on = "Y" },
	{ on = "Z" },

	{ on = "a" }, { on = "b" }, { on = "c" }, { on = "d" }, { on = "e" },
	{ on = "f" }, { on = "g" }, { on = "h" }, { on = "i" }, { on = "j" },
	{ on = "k" }, { on = "l" }, { on = "m" }, { on = "n" }, { on = "o" },
	{ on = "p" }, { on = "q" }, { on = "r" }, { on = "s" }, { on = "t" },
	{ on = "u" }, { on = "v" }, { on = "w" }, { on = "x" }, { on = "y" },
	{ on = "z" }, { on = "0" }, { on = "1" }, { on = "2" }, { on = "3" },
	{ on = "4" }, { on = "5" }, { on = "6" }, { on = "7" }, { on = "8" },
	{ on = "9" }, { on = "-" }, { on = "_" }, { on = "." }, { on = "<Esc>" },
	{ on = "<Space>" }, { on = "<Enter>" }, { on = "<Backspace>" }
}


local check_is_match_char = function(target_char, extend_char_list)
	for i = 1, #extend_char_list do
		if target_char == extend_char_list[i] then
			return true
		end
	end
	return false
end

local function utf8_char_byte_length(char)
	local code = utf8.codepoint(char)

	if code <= 0x007F then
		return 1
	elseif code <= 0x07FF then
		return 2
	elseif code <= 0xFFFF then
		return 3
	else
		return 4
	end
end

local function get_match_position(state, name, find_str)
    -- 空字符串检查
    if find_str == nil or find_str == "" then
        return nil, nil
    end

    -- 初始化变量
    local start_positions = {}
    local end_positions = {}
    local name_lower = string.lower(name)
    local pattern_lower = string.lower(find_str)
    
    -- 将字符串分割为UTF-8字符数组
    local utf8_chars = {}
    for utf8_char in string.gmatch(name_lower, "[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(utf8_chars, utf8_char)
    end
    
    -- 匹配状态变量
    local pattern_index = 1  -- 当前匹配的模式字符索引
    local byte_index = 1     -- 当前在原始字符串中的字节位置
    local match_start_byte = 0
    local match_start_char_index = 0
    local match_end_byte = 0
    
    -- 遍历所有UTF-8字符
    for char_index = 1, #utf8_chars do
        local current_char = utf8_chars[char_index]
        local char_byte_length = utf8_char_byte_length(current_char)
        local char_maps = state.mapdata[current_char]
        
        -- 检查当前字符是否匹配
        local is_char_match
        if char_maps then
            local pattern_char = pattern_lower:sub(pattern_index, pattern_index)
            is_char_match = check_is_match_char(pattern_char, char_maps)
        else
            local pattern_char = pattern_lower:sub(pattern_index, pattern_index)
            is_char_match = (pattern_char == current_char)
        end
        
        -- 处理匹配开始
        if match_start_byte == 0 and is_char_match then
            match_start_byte = byte_index
            match_start_char_index = char_index
        end
        
        -- 处理匹配过程
        if match_start_byte ~= 0 then
            if is_char_match then
                -- 如果匹配到模式的最后一个字符
                if pattern_index == #pattern_lower then
                    match_end_byte = byte_index + (char_byte_length - 1)
                    table.insert(start_positions, match_start_byte)
                    table.insert(end_positions, match_end_byte)
                    
                    -- 重置匹配状态以查找下一个匹配
                    pattern_index = 1
                    match_start_char_index = 0
                    match_end_byte = 0
                    match_start_byte = 0
                else
                    -- 继续匹配下一个模式字符
                    pattern_index = pattern_index + 1
                end
                
                byte_index = byte_index + char_byte_length
            else
                -- 匹配失败，重置到第一个匹配字符的下一个位置
                pattern_index = 1
                char_index = match_start_char_index
                
                -- 计算下一个字节位置
                local first_match_char = utf8_chars[match_start_char_index]
                local is_wide_char = (first_match_char:byte() > 127)
                byte_index = match_start_byte + (is_wide_char and 3 or 1)
                
                -- 重置匹配状态
                match_start_byte = 0
                match_start_char_index = 0
            end
        else
            -- 没有在进行中的匹配，正常前进
            byte_index = byte_index + char_byte_length
        end
    end
    
    -- 返回结果
    if #start_positions > 0 then
        return start_positions, end_positions
    else
        return nil, nil
    end
end

local get_first_match_file = ya.sync(function(state)
	if state.match == nil then
		return nil
	end

	local sort_match = {}
	for url, _ in pairs(state.match) do
		table.insert(sort_match, url)
	end

	-- 按字母顺序排序，确保遍历顺序一致
	table.sort(sort_match)

	state.sort_match = sort_match
	state.match_total = #sort_match

	return sort_match[1]
end)

local function get_match_file(state, direction)
	if state.match == nil then
		return nil
	end

	-- 初始化索引（如果不存在）
	if state.match_index == nil then
		state.match_index = 1
	end

	local total = state.match_total

	if total == 0 then
		return nil
	end

	-- 根据方向计算索引
	if direction == "next" then
		state.match_index = (state.match_index % total) + 1
	elseif direction == "prev" then
		state.match_index = state.match_index - 1
		if state.match_index < 1 then
			state.match_index = total
		end
	end

	return state.sort_match[state.match_index]
end

local get_next_match_file = ya.sync(function(state)
	return get_match_file(state, "next")
end)

local get_prev_match_file = ya.sync(function(state)
	return get_match_file(state, "prev")
end)


-- apply search result to show
local set_match_label = ya.sync(function(state, url, name, file)
	local span = {}
	local i = 1
	local startPos = state.match[url].startPos
	local endPos = state.match[url].endPos

	if file.is_hovered then
		table.insert(span, ui.Span(name:sub(1, startPos[1] - 1)))
	else
		table.insert(span, ui.Span(name:sub(1, startPos[1] - 1)))
	end

	while i <= #startPos do
		table.insert(span,
			ui.Span(name:sub(startPos[i], endPos[i])):fg(state.opt_match_str_fg):bg(state.opt_match_str_bg))
		if i + 1 <= #startPos then
			if file.is_hovered then
				table.insert(span, ui.Span(name:sub(endPos[i] + 1, startPos[i + 1] - 1)))
			else
				table.insert(span, ui.Span(name:sub(endPos[i] + 1, startPos[i + 1] - 1)))
			end
		end
		i = i + 1
	end

	if file.is_hovered then
		table.insert(span, ui.Span(name:sub(endPos[i - 1] + 1, #name)))
	else
		table.insert(span, ui.Span(name:sub(endPos[i - 1] + 1, #name)))
	end
	return span
end)

-- update the match data after input a str
local update_match_table = ya.sync(function(state, pane, folder, convert_pattern)
	if not folder then
		return
	end

	local i

	for i, file in ipairs(folder.files) do
		local name = file.name:gsub("\r", "?", 1)
		local url = tostring(file.url)
		local startPos, endPos = get_match_position(state, name, convert_pattern)
		if startPos then
			-- record match file data
			state.match[url] = {
				key = {},
				startPos = startPos,
				endPos = endPos,
				isdir = file.cha.is_dir,
				pane = pane,
				cursorPos = i,
			}
		end
	end
end)

local record_match_file = ya.sync(function(state, patterns)
	local exist_match = false

	if state.match == nil then
		state.match = {}
	end

	for _, pattern in ipairs(patterns) do
		update_match_table("current", cx.active.current, pattern)
	end

	ya.render()

	return exist_match
end)

local toggle_ui = ya.sync(function(st)
	if st.highlights or st.header_fc_id then
		Header:children_remove(st.header_fc_id)
		Entity.highlights, st.highlights, st.header_fc_id = st.highlights, nil, nil
		ya.render()
		return
	end

	st.highlights = Entity.highlights

	Entity.highlights = function(self)
		local file = self._file
		local spans = {}
		local name = file.name:gsub("\r", "?", 1)

		local url = tostring(file.url)

		if st.match and st.match[url] then
			spans = set_match_label(url, name, file)
		elseif file.is_hovered then
			spans = { ui.Span(name) }
		else
			spans = { ui.Span(name) }
		end

		return ui.Line(spans)
	end

	local function header_fc(self)
		local match_pattern = st.match_pattern and st.match_pattern or ""
		if st.match_total and st.match_total > 0 and st.match_index then
			return ui.Line {
				ui.Span(" " .. "(find:" .. match_pattern .. ")" .. "[" .. st.match_index .. "/" .. st.match_total .. "]"):fg(st.header_color):bold(),

			}
		else
			return ui.Line {
				ui.Span(" " .. "(find:" .. match_pattern .. ")"):fg(st.header_color):bold(),
			}
		end
	end
	st.header_fc_id = Header:children_add(header_fc, 1005, Header.LEFT)
end)


local set_target_str = ya.sync(function(state, patterns)
	-- clears the previously calculated data when input change
	state.match = nil

	-- calculate match data
	local exist_match = record_match_file(patterns)

	-- apply match data to render
	ya.render()
end)

local clear_state_str = ya.sync(function(state)
	state.match = nil
	state.match_pattern = nil
	state.match_total = nil
	state.match_index = nil
	state.sort_match = nil
	ya.render()
end)


local flush_input_key_in_headerbar = ya.sync(function(state, input_str)
	state.match_pattern = input_str
	ya.render()
end)

return {
	setup = function(state, opts)
		-- Save the user configuration to the plugin's state
		state.mapdata = opts.mapdata and opts.mapdata or nil
		state.opt_match_str_fg = opts.match_str_fg and opts.match_str_fg or "#000000"
		state.opt_match_str_bg = opts.match_str_bg and opts.match_str_bg or "#73AC3A"
		state.header_color = opts.header_color and opts.header_color or "#EB6D59"
	end,

	entry = function(_, _)
		toggle_ui()

		local input_str = ""
		local patterns = {}
		local isinputing = true

		local popupinput = ya.input {
			title = "find str",
			position = { "top-center", y = 3, w = 40 },
			realtime = true,
		}

		while true do
			if isinputing then
				local istr, event = popupinput:recv()
				if event == 1 and istr ~= nil and istr ~= "" then
					input_str = string.lower(istr)
					patterns = { input_str }
					isinputing = false
				elseif event == 2 then
					break
				elseif event == 3 then
					input_str = string.lower(istr)
					patterns = { input_str }
					isinputing = true
				else
					break
				end
			else
				local cand = ya.which { cands = INPUT_CANDS, silent = true }
				if cand == nil then
					goto continue
				end

				if INPUT_KEY[cand] == "<Esc>" then
					break
				end

				if INPUT_KEY[cand] == "<Enter>" then
					local ok, _ = pcall(require, "lastopen")
					if ok then
						ya.mgr_emit("plugin", { "lastopen", ya.quote("open")})
					else
						ya.mgr_emit("open", {})
					end
					break
				elseif INPUT_KEY[cand] == "n" then
					url = get_next_match_file()
					if url then
						ya.mgr_emit("reveal", { url })
					end
					goto continue
				elseif INPUT_KEY[cand] == "N" then
					url = get_prev_match_file()
					if url then
						ya.mgr_emit("reveal", { url })
					end
					goto continue
				elseif INPUT_KEY[cand] == "f" then
					isinputing = true
					popupinput = ya.input {
								title = "find str",
								position = { "top-center", y = 3, w = 40 },
								realtime = true,
							}
					goto continue
				else
					goto continue
				end
			end

			flush_input_key_in_headerbar(input_str)

			set_target_str(patterns)

			url = get_first_match_file()
			if url then
				ya.mgr_emit("reveal", { url })
			end

			::continue::
		end

		clear_state_str()
		toggle_ui()
	end
}

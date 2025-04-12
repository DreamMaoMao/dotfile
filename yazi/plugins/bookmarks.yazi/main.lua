-- stylua: ignore
local SUPPORTED_KEYS = {
	"a","s","d","j","k","l","p", "b", "e", "t",  "o", "i", "n", "r", "h","c",
	"u", "m", "f", "g", "w", "v", "x", "z", "y", "q"
}

local LINUX_BASE_PATH = "/.config/yazi/plugins/bookmarks.yazi/bookmarkcache"
local WINDOWS_BASE_PATH = "\\yazi\\config\\plugins\\bookmarks.yazi\\bookmarkcache"

local SERIALIZE_PATH = ya.target_family() == "windows" and os.getenv("APPDATA") .. WINDOWS_BASE_PATH or os.getenv("HOME") .. LINUX_BASE_PATH

local function string_split(input,delimiter)

	local result = {}

	for match in (input..delimiter):gmatch("(.-)"..delimiter) do
	        table.insert(result, match)
	end
	return result
end

local function delete_lines_by_content(file_path, pattern)
    local lines = {}
    local file = io.open(file_path, "r")

    -- Read all lines and store those that do not match the pattern
    for line in file:lines() do
        if not line:find(pattern) then
            table.insert(lines, line)
        end
    end
    file:close()

    -- Write back the lines that don't match the pattern
    file = io.open(file_path, "w")
    for i, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()
end

-- save table to file
local save_to_file = ya.sync(function(state,filename)
    local file = io.open(filename, "w+")
	for i, f in ipairs(state.bookmarks) do
		file:write(string.format("%s###%s###%s###%s",f.on,f.file_url,f.desc,f.isdir), "\n")
	end
    file:close()
end)

-- load from file to state
local load_file_to_state = ya.sync(function(state,filename)

	if state.bookmarks == nil then 
		state.bookmarks = {}
	else
		return
	end

    local file = io.open(filename, "r")
	if file == nil then 
		return
	end

	for line in file:lines() do
		line = line:gsub("[\r\n]", "")
		local bookmark = string_split(line,"###")
		if bookmark == nil or #bookmark < 4 then
			goto nextline
		end
		state.bookmarks[#state.bookmarks + 1] = {
			on = bookmark[1],
			file_url = bookmark[2],
			desc = bookmark[3],
			isdir = bookmark[4],
		}

		::nextline::
	end
    file:close()
end)



local save_bookmark = ya.sync(function(state,message,key)

	local under_cursor_file = cx.active.current.hovered

	-- avoid add exists url
	for y, cand in ipairs(state.bookmarks) do
		if tostring(under_cursor_file.url) == cand.desc then
			return 
		end
	end

	-- if input message is empty,set message to file url
	if message == "" then
		message = under_cursor_file.url
	end

	state.bookmarks[#state.bookmarks + 1] = {
		on = key,
		file_url = tostring(under_cursor_file.url),
		desc = tostring(message),
		isdir = tostring(under_cursor_file.cha.is_dir),
	}

	ya.notify {
		title = "Bookmark",
		content = "Bookmark:<"..message.."> saved",
		timeout = 2,
		level = "info",
	}

	save_to_file(SERIALIZE_PATH)
end)

local all_bookmarks = ya.sync(function(state) return state.bookmarks or {} end)

local delete_bookmark = ya.sync(function(state,idx) 
	ya.notify {
		title = "Bookmark",
		content = "Bookmark:<"..state.bookmarks[idx].desc .."> deleted",
		timeout = 2,
		level = "info",
	}
	table.remove(state.bookmarks, idx) 
  save_to_file(SERIALIZE_PATH)
end)

local modify_bookmark = ya.sync(function(state,key) 

	local under_cursor_file = cx.active.current.hovered

	for i, f in ipairs(state.bookmarks) do
		if f.on == key then
			f.file_url = tostring(under_cursor_file.url)
			f.isdir = tostring(under_cursor_file.cha.is_dir)
			ya.notify {
				title = "Bookmark",
				content = "change key <" .. key .."> bind to current",
				timeout = 2,
				level = "info",
			}
      save_to_file(SERIALIZE_PATH)
			return
		end
	end
	ya.notify {
		title = "Bookmark",
		content = "key not exists",
		timeout = 2,
		level = "info",
	}

end)

local delete_all_bookmarks = ya.sync(function(state)
	ya.notify {
		title = "Bookmark",
		content = "Bookmark:all bookmarks has been deleted",
		timeout = 2,
		level = "info",
	}
	state.bookmarks = nil
	delete_lines_by_content(SERIALIZE_PATH,".*")
end)


local function keyset_notify(str)
	ya.notify {
		title = "keyset",
		content = str,
		timeout = 2,
		level = "info",
	}	
end

local auto_generate_key = ya.sync(function(state)
	-- if input_key is empty,auto find a key to bind from begin SUPPORTED_KEYS
	local find = false
	local auto_assign_key
	for i, key in ipairs(SUPPORTED_KEYS) do
		if find then
			break
		end

		for y, cand in ipairs(state.bookmarks) do
			if key == cand.on then
				goto continue				
			end
		end
		
		auto_assign_key = key
		find = true

		::continue::
	end	

	if find then
		return auto_assign_key
	else
		keyset_notify("assign fail,all key has been assign")
		return nil
	end
end)

local assign_key =ya.sync(function(state,input_key)

	if string.len(input_key) > 1 then
		keyset_notify("assign fail,key too long")
		return nil 
	end

	for y, cand in ipairs(state.bookmarks) do
		if input_key == cand.on then
			keyset_notify("assign fail,key has been used")
			return nil 				
		end
	end		
	return input_key
end)

local function get_bind_key()
	local key_set, event = ya.input({
		realtime = false,
		title = "set your bind key(one key):",
		position = { "top-center", y = 3, w = 40 },
	})
	if event == 1 and key_set ~= "" then
		local key_set = assign_key(key_set)
		if key_set == nil then
			return get_bind_key()
		else
			return key_set
		end
	elseif event == 1 and key_set == "" then
		local generate_key = auto_generate_key()
		return generate_key
	else
		return nil
	end
end

return {
	entry = function(_,job)
		local args = job.args
		local action = args[1]
		if not action then
			return
		end

		load_file_to_state(SERIALIZE_PATH)

		if action == "save" then
			local value, event = ya.input({
				realtime = false,
				title = "set bookmark message:",
				position = { "top-center", y = 3, w = 40 },
			})
			if event == 1 then
				local key = get_bind_key()
				if key == nil then
					return
				end
				save_bookmark(value,key)
			end
			return
		end

		if action == "modify" then
			local value, event = ya.input({
				realtime = false,
				title = "input change key:",
				position = { "top-center", y = 3, w = 40 },
			})
			if event == 1 then
				modify_bookmark(value)
			end
			return
		end

		if action == "delete_all" then
			return delete_all_bookmarks()
		end


		if action == "jump" then
			local bookmarks = all_bookmarks()
			
			if #bookmarks == 0 then
				return
			end

			local selected = ya.which { cands = bookmarks }

			if selected == nil then
				return
			end

			ya.mgr_emit(bookmarks[selected].isdir == "true" and "cd" or "reveal", { bookmarks[selected].file_url })

			return
		elseif action == "delete" then
			local bookmarks = all_bookmarks()

			if #bookmarks == 0 then
				return
			end

			local selected = ya.which { cands = bookmarks }
			
			if selected == nil then
				return
			end
			
			delete_bookmark(selected)
			return
		end
	end,
}

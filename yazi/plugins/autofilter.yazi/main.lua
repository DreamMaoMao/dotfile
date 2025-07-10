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
    for _, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()
end

-- load from file to state
local get_autofilter_data = ya.sync(function(state)

	return state.autofilter

end)

-- save table to file
local function save_to_file(filename)
	local data = get_autofilter_data()
    local file = io.open(filename, "w+")
	for path, f in pairs(data) do
		file:write(string.format("%s###%s",path,f.word), "\n")
	end
    file:close()
end

local function file_exists(name)
	local command
	if ya.target_family() == "windows" then
    	command = "IF EXIST " .. name .. " (echo 1) ELSE (echo 0)"
	else
		command = 'test -e ' ..'"'.. name ..'"'.. ' && echo 1 || echo 0'
	end
    local output = io.popen(command):read("*a")
    output = output:gsub("%s+", "")
    return output == "1"
end

-- load from file to state
local load_file_to_state = ya.sync(function(state,data)

	if state.autofilter == nil then 
		state.autofilter = {}
	else
		return
	end

	local status, mime_preview_module = pcall(require, "mime-preview")
	if status then 	-- mime-preview module exists
		state.ext_mime_map = mime_preview_module:get_mime_data() 
	else
		state.ext_mime_map = {}
	end

	state.autofilter = data

	state.force_fluse_header = true

end)


local get_unmatch_ext_urls = ya.sync(function(state)
	return state.unmatch_ext_urls
end)


local save_autofilter = ya.sync(function(state,word)

	-- avoid add exists path
	for path, _ in pairs(state.autofilter) do
		if tostring(cx.active.current.cwd) == path then
			return 
		end
	end

	state.autofilter[tostring(cx.active.current.cwd)] = {
		word = tostring(word),
	}

	ya.notify {
		title = "autofilter",
		content = "autofilter:<"..word.."> saved",
		timeout = 2,
		level = "info",
	}
	ya.mgr_emit("filter_do", { word, smart = true })
	state.force_fluse_header = true
	state.force_fluse_mime = true
	ya.mgr_emit("plugin",{"autofilter","resave"})
end)

local delete_autofilter = ya.sync(function(state)

	local key = tostring(cx.active.current.cwd)

	if state.autofilter[key] == nil then
		return
	end

	ya.notify {
		title = "autofilter",
		content = "autofilter:<"..state.autofilter[key].word .."> deleted",
		timeout = 2,
		level = "info",
	}
	state.autofilter[key] = nil
	ya.mgr_emit("filter_do", { "", smart = true })
	state.force_fluse_header = true
	state.force_fluse_mime = true
	ya.mgr_emit("plugin",{"autofilter","resave"})
end)

local delete_all_autofilter = ya.sync(function(state)
	ya.notify {
		title = "autofilter",
		content = "autofilter:all autofilter has been deleted",
		timeout = 2,
		level = "info",
	}
	state.autofilter = nil
	ya.mgr_emit("filter_do", { "", smart = true })
	state.force_fluse_header = true
	state.force_fluse_mime = true
	delete_lines_by_content(state.cache_path,".*")
end)

local SUPPORTED_TYPES = "application/audio/biosig/chemical/font/image/inode/message/model/rinex/text/vector/video/x-epoc/"

local function match_mimetype(s)
	local type, sub = s:match("([-a-z]+/)([+-.a-zA-Z0-9]+)%s*$")
	if type and sub and string.find(SUPPORTED_TYPES, type, 1, true) then
		return type .. sub
	end
end

local flush_mime_by_ext = ya.sync(function(state)
	local files =  cx.active.current.window

	local mimes = {}
	state.unmatch_ext_urls = {}

	for _, file in ipairs(files) do
	  local url = tostring(file.url)

	  local ext = tostring(file.name):match("^.+%.(.+)$")
	  if ext then
		ext = ext:lower()
		local ext_mime = state.ext_mime_map[ext]
		if ext_mime then
		  mimes[url] = ext_mime
		  goto continue
		end
	  end
	  state.unmatch_ext_urls[#state.unmatch_ext_urls + 1] = url
	  ::continue::
	end


	if #mimes then
		ya.mgr_emit("update_mimes", { updates = mimes })
		ya.mgr_emit("update_mimetype", { updates = mimes })
	end
	
	if #state.unmatch_ext_urls then
		ya.mgr_emit("plugin",{"autofilter","flush_mime_by_file_cmd"})
	end

end)

local get_cache_path = ya.sync(function(state)
	return state.cache_path
end)

return {
	setup = function(st,opts)
		
		local LINUX_BASE_PATH = "/.config/yazi/plugins/autofilter.yazi/filtercache"
		local WINDOWS_BASE_PATH = "\\yazi\\config\\plugins\\autofilter.yazi\\filtercache"
		
		local SERIALIZE_PATH = ya.target_family() == "windows" and os.getenv("APPDATA") .. WINDOWS_BASE_PATH or os.getenv("HOME") .. LINUX_BASE_PATH
		
		local color = opts and opts.color and opts.color or "#CE91A0"
		st.cache_path = opts and opts.cache_path and opts.cache_path or SERIALIZE_PATH
		ya.err(opts.cache_path)
		-- add a nil module to header to detect cwd change
		local function cwd_change_detect(self)
			local cwd = cx.active.current.cwd
			if st.cwd ~= cwd or st.force_fluse_header then
				st.force_fluse_header = false
				st.cwd = cwd
				if st.autofilter and st.autofilter[tostring(cwd)] then
					st.is_auto_filter_cwd = true
					ya.mgr_emit("filter_do", { st.autofilter[tostring(cwd)].word, smart = true })
					st.need_flush_mime = true
					st.url =  tostring(cx.active.current.hovered.url)
				else
					st.is_auto_filter_cwd = false
				end
			end
			return st.is_auto_filter_cwd and ui.Line { ui.Span(" [AF]"):fg(color):bold() } or ui.Line{}
		end

		Header:children_add(cwd_change_detect,8000,Header.LEFT)

		local function Status_mime(self)
			local window = cx.active.current.window
			local url = cx.active.current.hovered and tostring(cx.active.current.hovered.url) or ""
			if (st.need_flush_mime and url ~= st.url and window and #window > 0) or st.force_fluse_mime then
				st.force_fluse_mime = false
				ya.mgr_emit("plugin",{"autofilter","flush_mime_by_ext"})
				st.need_flush_mime = false
				st.url = url
			end

			return ui.Line {}
		end
	
		Status:children_add(Status_mime,100000,Status.LEFT)

		-- Async load data, avoid block yazi start
		ya.mgr_emit("plugin",{"autofilter","init"})
	end,

	entry = function(_,job)
		local args = job.args
		local action = args[1]
		if not action then
			return
		end

		local cache_path = get_cache_path()

		if action == "resave" then
			save_to_file(cache_path)
		end

		if action == "init" then
			local data = {}
			local file = io.open(cache_path, "r")
			if file then 
		
				for line in file:lines() do
					line = line:gsub("[\r\n]", "")
					local autofilter = string_split(line,"###")
					if autofilter == nil or #autofilter < 2 then
						goto nextline
					end
					if file_exists(autofilter[1]) then
						data[autofilter[1]] = {
							word = autofilter[2],
						}
					end
				
					::nextline::
				end
				file:close()
			end
			--auto clean no-exists-path line
			load_file_to_state(data)
			save_to_file(cache_path)
		end

		if action == "flush_mime_by_ext" then
			flush_mime_by_ext()
		end

		if action == "flush_mime_by_file_cmd" then
			local mimes = {}
			local unmatch_ext_urls = get_unmatch_ext_urls()
			local file_one_path = os.getenv("YAZI_FILE_ONE") or "file"
	  		local command = Command(file_one_path):arg("--mime-type"):stdout(Command.PIPED):stderr(Command.PIPED)
	  		if ya.target_family() == "windows" then
				command:arg("-b")
	  		else
				command:arg("-bL")
	  		end
		
	  		local i = 1
	  		local mime
	  		local output = command:arg(unmatch_ext_urls):output()
	  		for line in output.stdout:gmatch("[^\r\n]+") do
				if i > #unmatch_ext_urls then
				  break
				end
			
				mime = match_mimetype(line)
			
				if mime and string.find(line, mime, 1, true) ~= 1 then
					goto continue
				elseif mime then
					mimes[unmatch_ext_urls[i]] = mime
				i = i + 1
				end
				::continue::
	  		end

			if #mimes then
				ya.mgr_emit("update_mimes", { updates = mimes })
				ya.mgr_emit("update_mimetype", { updates = mimes })
			end
		
		end

		if action == "save" then
			local value, event = ya.input({
				realtime = false,
				title = "set autofilter word:",
				position = { "top-center", y = 3, w = 40 },
			})
			if event == 1 then
				save_autofilter(value)
			end
			return
		end

		if action == "delete_all" then
			return delete_all_autofilter()
		end

		if action == "delete" then
			delete_autofilter()
			return
		end
	end,
}

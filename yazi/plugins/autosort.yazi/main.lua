local LINUX_BASE_PATH = "/.config/yazi/plugins/autosort.yazi/sortcache"
local WINDOWS_BASE_PATH = "\\yazi\\config\\plugins\\autosort.yazi\\sortcache"

local sort_mode_select = {
	"alphabetical" ,
	"btime" ,
	"mtime" ,
	"natural" ,
	"size" ,
	"extension" ,	
}
local sort_mode_select_cand = {
	{ on = {"a"}, desc = "alphabetical" },
	{ on = {"b"}, desc = "btime" },
	{ on = {"m"}, desc = "mtime" },
	{ on = {"n"}, desc = "natural" },
	{ on = {"s"}, desc = "size" },
	{ on = {"e"}, desc = "extension" },
}

local reverse_select = {
	"reverse",
}

local reverse_select_cand = {
	{ on = {"y"}, desc = "reverse" },
	{ on = {"n"}, desc = "no reverse" },
}

local dir_first_select = {
	"dir_first",
}

local dir_first_select_cand = {
	{ on = {"y"}, desc = "dir first" },
	{ on = {"n"}, desc = "no dir first" },
}

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
    for _, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()
end

local get_autosort_data = ya.sync(function(state)

	return state.autosort

end)

-- save table to file
local function save_to_file (filename)
	local data = get_autosort_data()
    local file = io.open(filename, "w+")
	for path, f in pairs(data) do
		file:write(string.format("%s###%s###%s###%s",path,f.word,f.reverse,f.dir_first), "\n")
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
	if state.autosort == nil then 
		state.autosort = {}
	else
		return
	end

	state.autosort = data
	state.force_fluse_header = true
end)

local save_autosort = ya.sync(function(state,word,reverse,dir_first)
	local set_reverse = false
	local set_dir_first = false
	-- avoid add exists path
	for path, _ in pairs(state.autosort) do
		if tostring(cx.active.current.cwd) == path then
			return 
		end
	end

	state.autosort[tostring(cx.active.current.cwd)] = {
		word = tostring(word),
		reverse = tostring(reverse),
		dir_first = tostring(dir_first),
	}

	ya.notify {
		title = "autosort",
		content = "autosort:<"..word.."> saved",
		timeout = 2,
		level = "info",
	}
	if reverse == "reverse" then
		set_reverse = true
	end
	if dir_first == "dir_first" then
		set_dir_first = true
	end
	ya.manager_emit("sort", { word, reverse = set_reverse, dir_first = set_dir_first })
	state.force_fluse_header = true
	state.force_fluse_mime = true
	ya.manager_emit("plugin",{"autosort",args="resave"})
end)

local delete_autosort = ya.sync(function(state)

	local key = tostring(cx.active.current.cwd)

	if state.autosort[key] == nil then
		return
	end

	ya.notify {
		title = "autosort",
		content = "autosort:<"..state.autosort[key].word .."> deleted",
		timeout = 2,
		level = "info",
	}
	state.autosort[key] = nil
	ya.manager_emit("sort", { state.sort_by, reverse = state.sort_reverse, dir_first = state.sort_dir_first })
	state.force_fluse_header = true
	state.force_fluse_mime = true
	ya.manager_emit("plugin",{"autosort",args="resave"})
end)

local delete_all_autosort = ya.sync(function(state)
	ya.notify {
		title = "autosort",
		content = "autosort:all autosort has been deleted",
		timeout = 2,
		level = "info",
	}
	state.autosort = nil
	ya.manager_emit("sort", { state.sort_by, reverse = state.sort_reverse, dir_first = state.sort_dir_first })
	state.force_fluse_header = true
	state.force_fluse_mime = true
	delete_lines_by_content(SERIALIZE_PATH,".*")
end)

local backup_state = ya.sync(function(state)

	state.sort_by = cx.active.pref.sort_by
	state.sort_reverse = cx.active.pref.sort_reverse
	state.sort_dir_first = cx.active.pref.sort_dir_first
	state.has_exit_autosort_folder = true

end)


return {
	setup = function(st,opts)
		
		local color = opts and opts.color and config.color or "#CE91A0"

		-- add a nil module to header to detect cwd change
		local function cwd_change_detect(self)
			local cwd = cx.active.current.cwd
			local set_reverse = false
			local set_dir_first = false
			if st.cwd ~= cwd or st.force_fluse_header then
				st.force_fluse_header = false
				st.cwd = cwd
				if st.autosort and st.autosort[tostring(cwd)] then
					st.is_auto_sort_cwd = true
					st.has_exit_autosort_folder = false
					if st.autosort[tostring(cwd)].reverse == "reverse" then
						set_reverse = true
					end
					if st.autosort[tostring(cwd)].dir_first == "dir_first" then
						set_dir_first = true
					end
					ya.manager_emit("sort", { st.autosort[tostring(cwd)].word, reverse = set_reverse, dir_first = set_dir_first })
					st.need_flush_mime = true
					st.url =  cx.active.current.hovered and tostring(cx.active.current.hovered.url) or ""
				else
					st.is_auto_sort_cwd = false
				end
			end
			if st.is_auto_sort_cwd then
				return ui.Line { ui.Span(" [AS:"..st.autosort[tostring(cwd)].word..":"..st.autosort[tostring(cwd)].reverse..":"..st.autosort[tostring(cwd)].dir_first.."]"):fg(color):bold() }
			elseif st.has_exit_autosort_folder or st.has_exit_autosort_folder == nil  then
				return ui.Line{}
			else
				st.has_exit_autosort_folder = true
				ya.manager_emit("sort", { st.sort_by, reverse = st.sort_reverse, dir_first = st.sort_dir_first })
				return ui.Line{}
			end
		end

		Header:children_add(cwd_change_detect,8000,Header.LEFT)


		-- Async load data, avoid block yazi start
		ya.manager_emit("plugin",{"autosort",args="init"})
	end,

	entry = function(_,job)
		local cand
		local word
		local reverse
		local dir_first
		local args = job.args
		local action = args[1]
		if not action then
			return
		end

		if action == "resave" then
			save_to_file(SERIALIZE_PATH)
		end

		if action == "init" then
			local data = {}
			backup_state()

			local file = io.open(SERIALIZE_PATH, "r")
			if file then 
				for line in file:lines() do
					line = line:gsub("[\r\n]", "")
					local autosort = string_split(line,"###")
					if autosort == nil or #autosort < 4 then
						goto nextline
					end
					if file_exists(autosort[1]) then
						data[autosort[1]] = {
							word = autosort[2],
							reverse = autosort[3],
							dir_first = autosort[4]
						}
					end
				
					::nextline::
				end
				file:close()
			end
			--auto clean no-exists-path line
			load_file_to_state(data)
			save_to_file(SERIALIZE_PATH)
		end

		if action == "save" then
			cand = ya.which { cands = sort_mode_select_cand, silent = false }
			if cand == nil then
				return
			else
				word = sort_mode_select[cand]
			end
			local cand = ya.which { cands = reverse_select_cand, silent = false }
			if cand ~= nil then
				reverse = reverse_select[cand]
			end
			local cand = ya.which { cands = dir_first_select_cand, silent = false }
			if cand ~= nil then
				dir_first = dir_first_select[cand]
			end

			save_autosort(word,reverse,dir_first)

			return
		end

		if action == "delete_all" then
			return delete_all_autosort()
		end

		if action == "delete" then
			delete_autosort()
			return
		end
	end,
}

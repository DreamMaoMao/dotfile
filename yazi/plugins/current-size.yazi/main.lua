local function string_split(input,delimiter)

	local result = {}

	for match in (input..delimiter):gmatch("(.-)"..delimiter) do
	        table.insert(result, match)
	end
	return result
end

local save = ya.sync(function(st, cwd,folder_size)
	if cx.active.current.cwd == Url(cwd) then
		st.folder_size = folder_size
		ya.render()
	end
end)

local clear_state = ya.sync(function(st)
	st.folder_size = ""
	ya.render()
end)

local flush_empty_folder_status = ya.sync(function(st)
	local cwd = cx.active.current.cwd
	local folder = cx.active.current
	if #folder.window == 0 then
		ya.manager_emit("plugin", { "current-size", args = ya.quote(tostring(cwd))})	
	end
end)

local set_opts_default = ya.sync(function(state)
	if (state.opt_folder_size_ignore == nil) then
		state.opt_folder_size_ignore = {}
	end
end)

local update_current_size = ya.sync(function(st)
	local cwd = cx.active.current.cwd

	for _, value in ipairs(st.opt_folder_size_ignore) do
		if value:sub(1,1) == "~" then
			value = os.getenv("HOME")..value:sub(2,value:len())
		end
		if value == tostring(cwd) then
			return
		elseif value.."/" == tostring(cwd) then
			return
		end
	end
	ya.manager_emit("plugin", { "current-size", args = ya.quote(tostring(cwd))})	
end)

local M = {
	setup = function(st,opts)

		set_opts_default()

		if (opts ~= nil and opts.folder_size_ignore ~= nil ) then
			st.opt_folder_size_ignore  = opts.folder_size_ignore
		end
		
		local function header_size(self)
			local cwd = cx.active.current.cwd
			if st.cwd ~= cwd then
				st.cwd = cwd
				local ignore_caculate_size = false
				for _, value in ipairs(st.opt_folder_size_ignore) do
					if value:sub(1,1) == "~" then
						value = os.getenv("HOME")..value:sub(2,value:len())
					end
					if value == tostring(cwd) then
						ignore_caculate_size = true
					elseif value.."/" == tostring(cwd) then
						ignore_caculate_size = true
					end
				end
				clear_state()
				if not ignore_caculate_size then
					ya.manager_emit("plugin", { "current-size", args = ya.quote(tostring(cwd))})			
				end
			end
			local folder_size_span = (st.folder_size ~= nil and st.folder_size ~= "") and ui.Span(" [".. st.folder_size  .."]"):fg("#ced333")  or ui.Line{}
			return folder_size_span
		end

		Header:children_add(header_size,1500,Header.LEFT)

		ps.sub("delete",flush_empty_folder_status)
		ps.sub("trash",flush_empty_folder_status)
	end,

	entry = function(_, job)
		local output

		local args = job.args
		local folder_size = ""
		output = Command("du"):args({"-sh",args[1].."/"}):output()

		if output then
			local split_output = string_split(output.stdout,"\t")
			folder_size = split_output[1]
		end		

		save(args[1],folder_size)
	end,
}

function M:fetch()
	update_current_size()	
	return 3	
end

return M
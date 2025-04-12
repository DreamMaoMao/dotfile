local function string_split(input,delimiter)

	local result = {}

	for match in (input..delimiter):gmatch("(.-)"..delimiter) do
	        table.insert(result, match)
	end
	return result
end

local get_cwd = ya.sync(function(state, _)
	return tostring(cx.active.current.cwd);
end)

return {
	entry = function()
		local cwd = get_cwd();
		local out, err = Command("sxiv"):args({"-t",cwd}):output()
		if out.status.success == false or err ~= nil then
			ya.dbg(err, out.stdout)
			return
		end

		local selected = {}
		local line_seq
		for i in string.gmatch(out.stdout, "([%S ]+)\n") do
			selected[#selected + 1] = i
		end
		if #selected == 0 then
			return
		end
		for _, value in ipairs(selected) do
			line_seq = string_split(value,"###")
			if line_seq[1] == "jump" then
				ya.mgr_emit("reveal", { line_seq[2] })
				return
			elseif line_seq[1] == "select" then
				-- this is a test, can't to select multi files
				ya.mgr_emit("toggle", { Url(line_seq[2]), state = "on" })
			end			
		end
		ya.mgr_emit("reveal", { line_seq[2] })
	end,
}

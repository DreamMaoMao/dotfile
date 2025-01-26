-- stylua: ignore

local LINUX_BASE_PATH = "/.config/yazi/plugins/lastopen.yazi/lastopen"
local WINDOWS_BASE_PATH = "\\yazi\\config\\plugins\\lastopen.yazi\\lastopen"

local SERIALIZE_PATH = ya.target_family() == "windows" and os.getenv("APPDATA") .. WINDOWS_BASE_PATH or os.getenv("HOME") .. LINUX_BASE_PATH

local save_and_open = ya.sync(function(state)
	local h = cx.active.current.hovered
	ya.manager_emit("open",{h.url})
    local file = io.open(SERIALIZE_PATH, "w+")
	file:write(string.format("%s",h.url))
    file:close()
end)

local read_lastpath = ya.sync(function(state)

	local lastpath = nil
    local file = io.open(SERIALIZE_PATH, "r")
	if file == nil then 
		return
	end

	for line in file:lines() do
		line = line:gsub("[\r\n]", "")
		lastpath = line
	end
    file:close()
	return lastpath
end)

return {
	entry = function(_,job)
		local args = job.args
		local action = args[1]
		if not action then
			return
		end

		if action == "jump" then
			local lastpath = read_lastpath()

			if lastpath then
				ya.manager_emit("reveal",{lastpath})
			else
				ya.notify {
					title = "lastopen",
					content = "no path is stored",
					timeout = 2,
					level = "info",
				}
			end
			return
		end

		if action == "open" then
			save_and_open()
			return
		end
	end,
}

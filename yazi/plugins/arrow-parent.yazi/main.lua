--- @sync entry
local function entry(_, job)
	local args = job.args
	local parent = cx.active.parent
	if not parent then return end

	local target = parent.files[parent.cursor + 1 + args[1]]
	if target and target.cha.is_dir then
		ya.mgr_emit("cd", { target.url })
	end
end

return { entry = entry }

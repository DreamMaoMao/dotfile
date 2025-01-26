local function setup(state,config)
	local color = config.color and config.color or "#D4BB91"


    local function status_mtime(self)
    	local h = cx.active.current.hovered
    	if h == nil or ya.target_family() ~= "unix" then
    		return ui.Line {}
    	end

		local style_mtime = ui:Style()
		style_mtime:fg(color)
		style_mtime:bold(true)
		local time = (h.cha.mtime or 0) // 1
		if time == 0 then
			return ui.Line("")
		elseif os.date("%Y", time) == os.date("%Y") then
			return ui.Line(os.date(" %m/%d-%H:%M ", time)):style(style_mtime)
		else
			return ui.Line(os.date(" %m/%d->%Y ", time)):style(style_mtime)
		end

    end

	Status:children_add(status_mtime,998,Status.RIGHT)
end

return { setup = setup }

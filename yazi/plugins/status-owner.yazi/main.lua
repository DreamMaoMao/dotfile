local function setup(state,config)
	local color = config.color and config.color or "#D4BB91"


    local function status_owner(self)
    	local h = cx.active.current.hovered
    	if h == nil or ya.target_family() ~= "unix" then
    		return ui.Line {}
    	end

    	return ui.Line {
    		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg(color):bold(),
    		ui.Span(":"),
    		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg(color):bold(),
    		ui.Span(" "),
    	}
    end

	Status:children_add(status_owner,999,Status.RIGHT)
end

return { setup = setup }
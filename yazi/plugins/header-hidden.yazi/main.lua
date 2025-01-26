local function setup(state,config)

	local color = config.color and config.color or "#88c2f4"

    local function header_hidden(self)
		local hidden = cx.active.pref.show_hidden
		return hidden and ui.Line { ui.Span(" [H]"):fg(color):bold() } or ui.Line{}
	end

	Header:children_add(header_hidden,8000,Header.LEFT)
end

return { setup = setup }
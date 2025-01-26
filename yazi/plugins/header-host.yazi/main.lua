local function setup(state,config)

	local color = config.color and config.color or "#8bca4b"

	local function Header_host(self)
			if ya.target_family() ~= "unix" then
				return ui.Line {}
			end
			return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg(color)
	end

	Header:children_add(Header_host,1,Header.LEFT)
end

return { setup = setup }

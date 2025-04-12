local M = {
	setup = function(st,opts)
		ps.sub("cd",function ()
			st.last = st.now
			st.now = cx.active.current.cwd
		end)
	end
}

local cd_last = ya.sync(function (st)
	if st.last then
		ya.mgr_emit("cd", { st.last })
	end
end)

function M:entry()
	cd_last()
end

return M

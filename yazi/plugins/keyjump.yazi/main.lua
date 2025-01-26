-- stylua: ignore
local SPECIAL_KEYS = {
	"<Space>", "<Esc>", "<Enter>",
	"<Left>", "<Right>", "<Up>", "<Down>",
	"h", "j", "k", "l",
	"J", "K",
	"<A-j>", "<A-k>",
	"z",
	"<C-j>", "<C-k>",
	"y", "p",
}

-- stylua: ignore
local SINGLE_KEYS = {
	"p", "b", "e", "t", "a", "o", "i", "n", "s", "r", "h", "l", "d", "c",
	"u", "m", "f", "g", "w", "v", "k", "j", "x", "y", "q"
}

-- stylua: ignore
local NORMAL_DOUBLE_KEYS = {
	"au", "ai", "ao", "ah", "aj", "ak", "al", "an", "su", "si", "so", "sh",
	"sj", "sk", "sl", "sn", "du", "di", "do", "dh", "dj", "dk", "dl", "dn",
	"fu", "fi", "fo", "fh", "fj", "fk", "fl", "fn", "eu", "ei", "eo", "eh",
	"ej", "ek", "el", "en", "ru", "ri", "ro", "rh", "rj", "rk", "rl", "rn",
	"cu",

	"ci", "co", "ch", "cj", "ck", "cl", "cn", "wu", "wi", "wo", "wh", "wj",
	"wk", "wl", "wn", "tu", "ti", "to", "th", "tj", "tk", "tl", "tn", "vu",
	"vi", "vo", "vh", "vj", "vk", "vl", "vn", "xu", "xi", "xo", "xh", "xj",
	"xk", "xl", "xn", "bu", "bi", "bo", "bh", "bj", "bk", "bl", "qp", "qy",
	"qm",

	"bn", "qu", "qi", "qo", "qh", "qj", "qk", "ql", "qn", "ap", "ay", "am",
	"fp", "fy", "fm", "ep", "ey", "em", "sp", "sy", "sm", "dp", "dy", "dm",
	"rp", "ry", "rm", "cp", "cy", "cm", "wp", "wy", "wm",
	"xp", "xy", "xm", "tp", "ty", "tm", "vp", "vy", "vm", "bp", "by", "bm",

}

-- stylua: ignore
local GLOBAL_CURRENT_DOUBLE_KEYS = {
	"au", "ai", "ao", "ah", "aj", "ak", "al", "an", "su", "si", "so", "sh",
	"sj", "sk", "sl", "sn", "du", "di", "do", "dh", "dj", "dk", "dl", "dn",
	"fu", "fi", "fo", "fh", "fj", "fk", "fl", "fn", "eu", "ei", "eo", "eh",
	"ej", "ek", "el", "en", "ru", "ri", "ro", "rh", "rj", "rk", "rl", "rn",
	"cu",

	-- left hand double key
	"aq", "aw", "ae",
	"qw", "qe", "qr",
	"we", "wr", "wt",
	"er", "et", "es",
	"rt", "rs", "rd",
	"ts", "td", "tf",
	"sd", "sf", "sz",
	"ar", "at", "as",
	"qt", "qs", "qd",
	"ws", "wd", "wf",
	"ed", "ef", "ez",
	"rf", "rz", "rx",
	"tz", "tx", "tc",
	"sx", "sc", "sv",
	"ad", "af", "az",
	"qf", "qz", "qx",
	"wz", "wx", "wc",
	"ex", "ec", "ev",
	"rc", "rv", "rb",
	"tv", "tb", "fz",

}

-- stylua: ignore
local GLOBAL_PREVIEW_DOUBLE_KEYS = {
	"ci", "co", "ch", "cj", "ck", "cl", "cn", "wu", "wi", "wo", "wh", "wj",
	"wk", "wl", "wn", "tu", "ti", "to", "th", "tj", "tk", "tl", "tn", "vu",
	"vi", "vo", "vh", "vj", "vk", "vl", "vn", "xu", "xi", "xo", "xh", "xj",
	"xk", "xl", "xn", "bu", "bi", "bo", "bh", "bj", "bk", "bl", "qp", "qy",
	"qm",

	-- left hand double key
	"sb", "df", "dz",
	"ax", "ac", "av",
	"qc", "qv", "qb",
	"wv", "wb", "cv",
	"eb", "xc", "xv",
	"zx", "zc", "zv",
	"fx", "fc", "fv",
	"dx", "dc", "dv",
	"ab", "ba", "cb",
	"xb", "zb", "fb",
	"db", "vb", "qa",
	"wq", "ew", "re",
	"tr", "fd", "cx",
	"st", "zf", "vc",
	"ds", "xz", "bv",
	"wa", "vx", "cf",
	"eq", "bc", "vz",
	"rw", "ea", "bx",
	"te", "rq", "ra",
	"sr", "tw", "tq",
}

-- stylua: ignore
local GLOBAL_PARENT_DOUBLE_KEYS = {
	"bn", "qu", "qi", "qo", "qh", "qj", "qk", "ql", "qn", "ap", "ay", "am",
	"fp", "fy", "fm", "ep", "ey", "em", "sp", "sy", "sm", "dp", "dy", "dm",
	"rp", "ry", "rm", "cp", "cy", "cm", "wp", "wy", "wm", "xp", "xy", "xm", 
	"tp", "ty", "tm", "vp", "vy", "vm", "bp", "by", "bm",

	-- left hand double key
	"dt","se","sw",
	"fs","dr","de",
	"zd","ft","fr",
	"xf","zs","zt",
	"cz","xd","xs",
	"cd","cd","da",
	"vf","vf","fq",
	"bz","bz","zw",
	"ta","ta","xe",
	"sq","sq","cr",
	"dw","dw","vt",
	"fe","fe","bs",
	"zr","zr","fa",
	"xt","xt","zq",
	"cs","cs","xw",
	"ce","cw","vw",
	"vr","ve","be",
	"bt","br","ca",
	"za","xa","vq",
	"xq","cq","bw",

}

local INPUT_CANDS = {
	{ on = "a" }, { on = "b" }, { on = "c" }, { on = "d" }, { on = "e" },
	{ on = "f" }, { on = "g" }, { on = "h" }, { on = "i" }, { on = "j" },
	{ on = "k" }, { on = "l" }, { on = "m" }, { on = "n" }, { on = "o" },
	{ on = "p" }, { on = "q" }, { on = "r" }, { on = "s" }, { on = "t" },
	{ on = "u" }, { on = "v" }, { on = "w" }, { on = "x" }, { on = "y" },
	{ on = "z" }, { on = "<Esc>" },{ on = "<Backspace>" },{ on = "<Space>" },
	{ on = "<Enter>" },
	{ on = "<Left>" }, { on = "<Right>" }, { on = "<Up>" }, { on = "<Down>" },
	{ on = "<A-j>" }, { on = "<A-k>" },
	{ on = "<C-j>" }, { on = "<C-k>" },
	{ on = "J" }, { on = "K" },

}

local INPUT_KEY = {
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
	"o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "<Esc>","<Backspace>","<Space>",
	"<Enter>",
	"<Left>", "<Right>" , "<Up>" , "<Down>" ,
	"<A-j>", "<A-k>" ,
	"<C-j>", "<C-k>" ,
	"J", "K",
}


local GO_MENU_KEYS = {
	"g",
}


-- TODO: the async jump is too fast, the current folder may cannot be found


-- FIXME: refactor this to avoid the loop
local function rel_position(file, view)
	local folder

	folder = cx.active.current
	if folder then
		for i, f in ipairs(folder.window) do
			if f.url == file.url then
				return i, "current"
			end
		end
	end

	if view == "current" then
		return nil, nil
	end

	folder = cx.active.parent
	if folder then
		for i, f in ipairs(folder.window) do
			if f.url == file.url then
				return i, "parent"
			end
		end
	end

	folder = cx.active.preview.folder
	if folder then
		for i, f in ipairs(folder.window) do
			if f.url == file.url then
				return i, "preview"
			end
		end
	end

	return nil, nil
end

-- FIXME: find a better way to do this
local function count_files(url, max)
	local cmd
	if ya.target_family() == "windows" then
		cmd = cx.active.pref.show_hidden and "dir /b /a " or "dir /b "
		cmd = cmd .. tostring(url)
		ya.err(cmd)
	else
		local target_cwd = '"'..tostring(url)..'"'
		cmd = cx.active.pref.show_hidden and "ls -A  " or "ls "
		cmd = 'test -r ' .. target_cwd .. ' && ' .. cmd .. target_cwd .. ' | wc -l'
	end

	if ya.target_family() == "windows" then
		local i, handle = 0, io.popen(cmd)
		for _ in handle:lines() do
			i = i + 1
			if i == max then
				break
			end
		end
		handle:close()
		return i
	else
		local f = io.popen(cmd)
		local output = f:read("*all")
		local num = tonumber(output:sub(1,-2))
		f:close()
		if num == nil then
			return 0
		end

		if num > max then
			return max
		else
			return num
		end
	end
end

local toggle_ui = ya.sync(function(st)

	if st.keep_hook then
		ya.render()
		return
	end

	if st.icon or st.mode then
		Entity.icon, Status.mode, st.icon, st.mode = st.icon, st.mode, nil, nil
		ya.manager_emit("peek", { force = true })
		ya.render()
		return
	end

	st.icon, st.mode = Entity.icon, Status.mode

	Entity.icon = function(self)
		local file = self._file
		local icon = file:icon()
		local span_icon_before = file:is_hovered() and ui.Span(file:icon().text .. " ") or ui.Span(file:icon().text .. " "):style(icon.style)
		
		if st.type == "global" then
			local pos, view = rel_position(file, "all")
			if pos == nil then
				return st.icon(self, file)
			elseif view == "current" then
				if st.double_first_key ~= nil and GLOBAL_CURRENT_DOUBLE_KEYS[pos]:sub(1,1) == st.double_first_key then
					return ui.Line {span_icon_before, ui.Span(GLOBAL_CURRENT_DOUBLE_KEYS[pos]:sub(1,1)):fg(st.opt_first_key_fg),ui.Span(GLOBAL_CURRENT_DOUBLE_KEYS[pos]:sub(2,2) .. " "):fg(st.opt_icon_fg)}
				else
					return ui.Line {span_icon_before, ui.Span(GLOBAL_CURRENT_DOUBLE_KEYS[pos].." "):fg(st.opt_icon_fg)}
				end
			elseif view == "parent" then
				if st.double_first_key ~= nil and GLOBAL_PARENT_DOUBLE_KEYS[pos]:sub(1,1) == st.double_first_key then
					return ui.Line {span_icon_before, ui.Span(GLOBAL_PARENT_DOUBLE_KEYS[pos]:sub(1,1)):fg(st.opt_first_key_fg),ui.Span(GLOBAL_PARENT_DOUBLE_KEYS[pos]:sub(2,2) .. " "):fg(st.opt_icon_fg)}
				else
					return ui.Line {span_icon_before, ui.Span(GLOBAL_PARENT_DOUBLE_KEYS[pos].." "):fg(st.opt_icon_fg)}
				end
			elseif view == "preview" then
				if st.double_first_key ~= nil and GLOBAL_PREVIEW_DOUBLE_KEYS[pos]:sub(1,1) == st.double_first_key then
					return ui.Line {span_icon_before, ui.Span(GLOBAL_PREVIEW_DOUBLE_KEYS[pos]:sub(1,1)):fg(st.opt_first_key_fg),ui.Span(GLOBAL_PREVIEW_DOUBLE_KEYS[pos]:sub(2,2) .. " "):fg(st.opt_icon_fg)}
				else
					return ui.Line {span_icon_before, ui.Span(GLOBAL_PREVIEW_DOUBLE_KEYS[pos].." "):fg(st.opt_icon_fg)}
				end
			end
		else
			local pos = rel_position(file, "current")
			if not pos then
				return st.icon(self, file)
			elseif st.current_num > #SINGLE_KEYS then
				if st.double_first_key ~= nil and NORMAL_DOUBLE_KEYS[pos]:sub(1,1) == st.double_first_key then
					return ui.Line {span_icon_before, ui.Span(NORMAL_DOUBLE_KEYS[pos]:sub(1,1)):fg(st.opt_first_key_fg),ui.Span(NORMAL_DOUBLE_KEYS[pos]:sub(2,2) .. " "):fg(st.opt_icon_fg)}
				else
					return ui.Line {span_icon_before, ui.Span(NORMAL_DOUBLE_KEYS[pos].." "):fg(st.opt_icon_fg)}
				end
			else
				return ui.Line {span_icon_before,ui.Span(SINGLE_KEYS[pos].." "):fg(st.opt_icon_fg)}
			end
		end
	end

	Status.mode = function(self)
		local style = self:style()
		return ui.Line {
			ui.Span(" KJ-" .. tostring(cx.active.mode):upper() .. " "):style(style.main),
		}
	end

	ya.manager_emit("peek", { force = true })
	ya.render()
end)


local function split_yazi_cmd_arg(cmd)
	local cmd_table = {}
	for word in string.gmatch(cmd, "%S+") do
		table.insert(cmd_table, word)
	end
	return cmd_table
end

local function count_preview_files(st)
	local h = cx.active.current.hovered
	-- TODO:under_cursor_file maybe nil,because aync task,floder may not ready
	if h and h.cha.is_dir then
		st.preview_num = count_files(tostring(h.url), #GLOBAL_PARENT_DOUBLE_KEYS)
	else
		st.preview_num = 0
	end
end

local apply = ya.sync(function(state, arg_cand, arg_current_num, arg_parent_num, arg_preview_num)

	local cand = tonumber(arg_cand)
	local current_entry_num = tonumber(arg_current_num)
	local parent_entry_num = tonumber(arg_parent_num)
	local preview_entry_num = tonumber(arg_preview_num)
	local go_num = state.type == "global" and #GO_MENU_KEYS or 0
	local folder = cx.active.current

	-- hit specail key
	if cand > (current_entry_num + parent_entry_num + preview_entry_num + go_num) then
		local special_key_str = SPECIAL_KEYS[cand - current_entry_num - parent_entry_num - preview_entry_num - go_num]
		if special_key_str == "<Esc>" then
			return true
		elseif special_key_str == "z" then
			return true
		elseif special_key_str == "<Enter>" then
			ya.manager_emit("open", {})
			return true
		elseif special_key_str == "<Left>" then
			ya.manager_emit("leave", {})
			return false
		elseif special_key_str == "<Right>" then
			ya.manager_emit("enter", {})
			return false
		elseif special_key_str == "<Up>" then
			ya.manager_emit("arrow", { "-1" })
			return false
		elseif special_key_str == "<Down>" then
			ya.manager_emit("arrow", { "1" })
			return false
		elseif special_key_str == "<Space>" then
			local under_cursor_file = cx.active.current.window[folder.cursor - folder.offset + 1]
			local toggle_state = under_cursor_file:is_selected() and "false" or "true"
			ya.manager_emit("toggle", { state = toggle_state })
			ya.manager_emit("arrow", { 1 })
			return false
		elseif special_key_str == "h"then
			if state.type == "global" then
				ya.manager_emit("leave", {})
			end
			return false
		elseif special_key_str == "j"then
			if state.type == "global" then
				ya.manager_emit("arrow", { "1" })
			end
			return false
		elseif special_key_str == "k"then
			if state.type == "global" then
				ya.manager_emit("arrow", { "-1" })
			end
			return false
		elseif special_key_str == "l"then
			if state.type == "global" then			
				ya.manager_emit("enter", {})
			end
			return false
		elseif special_key_str == "J" then
			ya.manager_emit("arrow", { "5" })
			return false
		elseif special_key_str == "K" then
			ya.manager_emit("arrow", { "-5" })
			return false
		elseif special_key_str == "<A-j>" then
			ya.manager_emit("seek", { "5" })
			return false
		elseif special_key_str == "<A-k>" then
			ya.manager_emit("seek", { "-5" })
			return false
		elseif special_key_str == "<C-j>" then
			ya.manager_emit("arrow", { "100%" })
			return false
		elseif special_key_str == "<C-k>" then
			ya.manager_emit("arrow", { "-100%" })
			return false
		elseif special_key_str == "y"then
			if state.type == "global" then
				ya.manager_emit("yank", {})
			end
			return false
		elseif special_key_str == "p"then
			if state.type == "global" then
				ya.manager_emit("paste", {})
			end
			return false

		end
	end

	-- apply global mode
	if state.type == "global" then
		-- hit current area
		if cand <= current_entry_num then -- hit normal key
			local current_folder = cx.active.current
			ya.manager_emit("arrow", { cand - 1 + current_folder.offset - current_folder.cursor })
		-- hit parent area
		elseif cand > current_entry_num and cand <= (current_entry_num + parent_entry_num) then
			local parent_folder = cx.active.parent
			ya.manager_emit("leave", {})
			ya.manager_emit("arrow", { cand - current_entry_num - 1 + parent_folder.offset - parent_folder.cursor })
		-- hit preview area
		elseif
			cand > (current_entry_num + parent_entry_num) and cand <= (current_entry_num + parent_entry_num + preview_entry_num) then
			local preview_folder = cx.active.preview.folder
			ya.manager_emit("enter", {})
			ya.manager_emit(
				"arrow",
				{ cand - current_entry_num - parent_entry_num - 1 + cx.active.preview.skip - preview_folder.cursor }
			)

		-- hit go
		elseif cand > (current_entry_num + parent_entry_num + preview_entry_num) and cand <= (current_entry_num + parent_entry_num + preview_entry_num + go_num) then
			return nil
		end

		-- whether continue global
		if state.times == "once" then
			return true
		else
			return false
		end
	end

	-- apply select mode
	if state.type == "select" then
		if cand <= current_entry_num then -- hit normal key
			local folder = cx.active.current
			ya.manager_emit("arrow", { cand - 1 + folder.offset - folder.cursor })
		end

		return false
	end

	-- apply keep mode and normal mode
	if (state.type == "keep" or not state.type) and folder.window[cand] then
		ya.manager_emit("arrow", { cand - 1 + folder.offset - folder.cursor })
	end

	-- keep mode will auto enter when select folder and continue keep mode
	if state.type == "keep" and folder.window[cand] and folder.window[cand].cha.is_dir then
		ya.manager_emit("enter", {})
		return false
	elseif folder.window[cand] == nil then
		return false
	else
		return true
	end

end)

local update_double_first_key = ya.sync(function(state, str)
	state.double_first_key = str
	ya.manager_emit("peek", { force = true })
end)

local recaculate_preview_num  = ya.sync(function(state, cwd)
	state.preview_num = count_files(cwd, #GLOBAL_PREVIEW_DOUBLE_KEYS)
end)

local function read_input_todo (arg_current_num,arg_parent_num,arg_preview_num,arg_type)

	local current_num = tonumber(arg_current_num)
	local parent_num = tonumber(arg_parent_num~= nil and arg_parent_num or "0")
	local preview_num = tonumber(arg_preview_num ~= nil and arg_preview_num or "0")
	local type = arg_type
	local current_cands, parent_cands, preview_cands, cands = {}, {}, {}, {}
	local cand = nil
	local is_signal_cand = true
	local pos,pos2
	local key_num_count = 0
	local key,double_key
	local first_key_of_lable = {}
	local special_and_go_key = {}
	local cands_count = 0


	-- generate cands of entry of current window
	if current_num == 0 then
		current_cands = {}
	elseif type == "global" then -- global mode disable signal key
		is_signal_cand = false
		current_cands = { table.unpack(GLOBAL_CURRENT_DOUBLE_KEYS, 1, current_num) }
	elseif current_num > #SINGLE_KEYS then
		is_signal_cand = false
		current_cands = { table.unpack(NORMAL_DOUBLE_KEYS, 1, current_num) }
	else
		current_cands = { table.unpack(SINGLE_KEYS, 1, current_num) }
	end

	-- generate cands of entry of parent window
	if parent_num ~= nil and parent_num ~= 0 then
		is_signal_cand = false
		parent_cands = { table.unpack(GLOBAL_PARENT_DOUBLE_KEYS, 1, parent_num) }
	else
		parent_cands = {}
		parent_num = 0
	end

	-- generate cands of entry of preview window
	if preview_num ~= nil and preview_num ~= 0 then
		is_signal_cand = false
		preview_cands = { table.unpack(GLOBAL_PREVIEW_DOUBLE_KEYS, 1, preview_num) }
	else
		preview_cands = {}
		preview_num = 0
	end

	--attach current cands to cands table
	for i = 1, #current_cands do
		local seca = current_cands[i]
		first_key_of_lable[seca:sub(1,1)] = ""
		cands_count =  cands_count + 1
		cands[seca] = cands_count
	end

	--attach parent cands to cands table
	for i = 1, #parent_cands do
		local seca = parent_cands[i]
		first_key_of_lable[seca:sub(1,1)] = ""
		cands_count =  cands_count + 1
		cands[seca] = cands_count
	end

	--attach preview cands to cands table
	for i = 1, #preview_cands do
		local seca = preview_cands[i]
		first_key_of_lable[seca:sub(1,1)] = ""
		cands_count =  cands_count + 1
		cands[seca] = cands_count
	end

	--attach go cands to cands table
	if type == "global" then
		for i = 1, #GO_MENU_KEYS do
			local seca = GO_MENU_KEYS[i]
			first_key_of_lable[seca] = ""
			cands_count =  cands_count + 1
			cands[seca] = cands_count
			special_and_go_key[seca] = ""
		end
	end

	--attach special cands to cands table
	for i = 1, #SPECIAL_KEYS do --attach special key
		local seca = SPECIAL_KEYS[i]
		first_key_of_lable[seca] = ""
		cands_count =  cands_count + 1
		cands[seca] = cands_count
		special_and_go_key[seca] = ""
	end

	while true do
		cand = ya.which { cands = INPUT_CANDS, silent = true }
		-- not candy key, continue get input
		if cand == nil then
			goto nextkey
		end

		-- hit exit easyjump
		if INPUT_KEY[cand] == "<Esc>" or INPUT_KEY[cand] == "z"  then
			key = INPUT_KEY[cand]	
			pos = cands[key]
			break
		end

		-- hit singal key or specail key in singal label mode
		if is_signal_cand then
			key = INPUT_KEY[cand]	
			pos = cands[key.."-"]
			pos2 = cands[key]
			if pos then
				break
			elseif pos2 and type and type ~= "" then
				pos = pos2
				break
			else
				goto nextkey
			end
		end

		-- hit special key in double label mode
		if key_num_count == 0 and special_and_go_key[INPUT_KEY[cand]] then
			key = INPUT_KEY[cand]
			pos = cands[key]
			break
		end

		-- hit backout a double key
		if INPUT_KEY[cand] == "<Backspace>" and not is_signal_cand then
			key_num_count = 0 -- backout to get the first double key
			update_double_first_key(nil) -- apply to the render change for first key
			goto nextkey
		end

		-- hit the first double key
		if key_num_count == 0 and not is_signal_cand then
			key = INPUT_KEY[cand]
			if first_key_of_lable[key] then	 
				key_num_count =  key_num_count + 1		
				update_double_first_key(key) -- apply to the render change for first key
			else
				key_num_count = 0 -- get the first double key fail, continue to get it
			end
			goto nextkey
		end

		-- hit the second double key
		if key_num_count == 1 and not is_signal_cand then

			double_key = key .. INPUT_KEY[cand]
			pos = cands[double_key]

			if pos == nil then -- get the second double key fail, continue to get it
				goto nextkey
			else
				update_double_first_key(nil)
				break
			end
		end

		::nextkey::
	end

	return apply(pos, current_num, parent_num, preview_num)

end


local init_global_action = ya.sync(function(state,arg_times)

	-- "once" or nil,nil means to don't auto exit
	state.times = arg_times
	state.type = "global"
	-- caculate file numbers of current window
	state.current_num = #cx.active.current.window
	if cx.active.parent and cx.active.parent.window then
		state.parent_num = #cx.active.parent.window
	else
		state.parent_num = 0
	end

	count_preview_files(state)

	return {state.current_num, state.parent_num, state.preview_num}

end)

local init_normal_action = ya.sync(function(state,action)

	state.current_num = #cx.active.current.window
	if state.current_num < ui.Rect.default.h then -- Maybe the folder has not been full loaded yet
		state.current_num = count_files(cx.active.current.cwd, #NORMAL_DOUBLE_KEYS)
	end

	state.type = action
	return state.current_num
end)

local go_again = ya.sync(function(state)
	state.again = true
end)

local set_keep_hook = ya.sync(function(state,status)
	state.keep_hook = status
end)

local remove_cwd_status_watch = ya.sync(function(state)
	Header:children_remove(state.header_status_id)
end)

local clear_state = ya.sync(function (state)
	state.again = nil
	state.keep_hook = nil
	state.header_status_id = nil
	state.times = nil
	state.current_num = nil
	state.parent_num = nil
	state.parent_num = nil
	state.type = nil
	state.double_first_key = nil
end)

local get_go_table = ya.sync(function (state)
	return state.opt_go_table
end)


local add_cwd_status_watch = ya.sync(function(state)

	if state.header_status_id ~= nil then
		return
	end

	local function cwd_status(self)
		if ((#cx.active.current.window >0 and cx.active.current.hovered and cx.active.current.hovered.url) or state.preview_num == 0) and state.again then
			state.again = false
			local times = state.times and state.times or ""
			ya.manager_emit("plugin", { "keyjump", args = ya.quote(state.type).." "..times})	
		end
		return ui.Line{}
	end
	state.header_status_id = Header:children_add(cwd_status,200,Header.LEFT)
end)

return {
	setup = function(state, opts)
		if (opts == nil or opts.icon_fg == nil) then
			state.opt_icon_fg = "#fda1a1"
		else
			state.opt_icon_fg  = opts.icon_fg
		end
		if (opts == nil or opts.first_key_fg == nil) then
			state.opt_first_key_fg = "#ffff33"
		else
			state.opt_first_key_fg  = opts.first_key_fg
		end
		

		if (opts == nil or opts.go_table == nil) then
			state.opt_go_table = {}

		else
			state.opt_go_table = opts.go_table
		end
	end,

	entry = function(_, job)
		add_cwd_status_watch()

		local args = job.args
		local action = args[1]
		local want_exit = false

		-- enter normal, keep or select mode
		if not action or action == "keep" or action == "select" then
			local current_num = init_normal_action(action)
			toggle_ui()
			want_exit = read_input_todo(current_num, "0", "0", action)
		end
		-- enter global mode
		if action == "global" then
			local times = args[2]
			local data = init_global_action(times)
			toggle_ui()
			want_exit = read_input_todo(data[1], data[2], data[3], action)
		end
		
		if want_exit == nil then
			local go_table = get_go_table()
			local cand
			while true do
				cand = ya.which { cands = go_table, silent = false }
				if cand ~= nil then
					break
				end
			end
			local cmd = split_yazi_cmd_arg(go_table[cand].run)
			recaculate_preview_num(cmd[2])
			ya.manager_emit(cmd[1], { cmd[2], args=cmd[3] }) 
			set_keep_hook(true)
			go_again()
		elseif want_exit == false and action and action ~= "" then
			set_keep_hook(true)
			go_again()
		else
			set_keep_hook(false)
			remove_cwd_status_watch()
			clear_state()
		end

		toggle_ui()

	end
}

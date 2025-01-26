local toggle_ui = ya.sync(function(self)
	if self.children then
		Modal:children_remove(self.children)
		self.children = nil
	else
		self.children = Modal:children_add(self, 10)
	end
	ya.render()
end)

local subscribe = ya.sync(function(self)
	ps.unsub("mount")
	ps.sub("mount", function() ya.manager_emit("plugin", { self._id, args = "refresh" }) end)
end)

local update_partitions = ya.sync(function(self, partitions)
	self.partitions = partitions
	self.title = "Mount"
	self.title_color = "#82ab3a"
	self.cursor = math.max(0, math.min(self.cursor or 0, #self.partitions - 1))
	ya.render()
end)

local set_pending_status = ya.sync(function(self)
	self.title_color = "#d9734b"
	self.title = "Pending..."
	ya.render()
end)

local active_partition = ya.sync(function(self) return self.partitions[self.cursor + 1] end)

local update_cursor = ya.sync(function(self, cursor)
	if #self.partitions == 0 then
		self.cursor = 0
	else
		self.cursor = ya.clamp(0, self.cursor + cursor, #self.partitions - 1)
	end
	ya.render()
end)

local M = {
	keys = {
		{ on = "q", run = "quit" },
		{ on = "<Esc>", run = "quit" },
		{ on = "<Enter>", run = "cd_quit" },
		{ on = "<Space>", run = "toggle" },

		{ on = "k", run = "up" },
		{ on = "j", run = "down" },
		{ on = "K", run = "4up" },
		{ on = "J", run = "4down" },
		{ on = "l", run = "right" },
		{ on = "h", run = "left" },

		{ on = "<Up>", run = "up" },
		{ on = "<Down>", run = "down" },
		{ on = "<S-Up>", run = "4up" },
		{ on = "<S-Down>", run = "4down" },
		{ on = "<Left>", run = "left" },

		{ on = "m", run = "mount" },
		{ on = "u", run = "unmount" },
		{ on = "M", run = "unmount" },
		{ on = "e", run = "eject" },
	},
}

function M:new(area)
	self:layout(area)
	return self
end

function M:layout(area)
	local chunks = ui.Layout()
		:constraints({
			ui.Constraint.Percentage(10),
			ui.Constraint.Percentage(80),
			ui.Constraint.Percentage(10),
		})
		:split(area)

	local chunks = ui.Layout()
		:direction(ui.Layout.HORIZONTAL)
		:constraints({
			ui.Constraint.Percentage(10),
			ui.Constraint.Percentage(80),
			ui.Constraint.Percentage(10),
		})
		:split(chunks[2])

	self._area = chunks[2]
end

function M:entry(job)
	if job.args[1] == "refresh" then
		return update_partitions(self.obtain())
	end

	toggle_ui()
	update_partitions(self.obtain())
	subscribe()

	local tx1, rx1 = ya.chan("mpsc")
	local tx2, rx2 = ya.chan("mpsc")
	function producer()
		while true do
			local cand = self.keys[ya.which { cands = self.keys, silent = true }]
			if cand then
				tx1:send(cand.run)
				if cand.run == "quit" or cand.run == "cd_quit" then
					break
				end
			end
		end
	end

	function consumer1()
		repeat
			local run = rx1:recv()
			if run == "quit" then
				tx2:send(run)
				toggle_ui()
				break
			elseif run == "cd_quit" then
				local active = active_partition()
				if active and active.dist then
					ya.manager_emit("cd", { active.dist })
				end
				tx2:send(run)
				toggle_ui()
				break
			elseif run == "up" then
				update_cursor(-1)
			elseif run == "down" then
				update_cursor(1)
			elseif run == "4up" then
				update_cursor(-4)
			elseif run == "4down" then
				update_cursor(4)
			elseif run == "right" then
				local active = active_partition()
				if active and active.dist then
					ya.manager_emit("cd", { active.dist })
				end
			elseif run == "left" then
				ya.manager_emit("leave", {})
			else
				tx2:send(run)
			end
		until not run
	end

	function consumer2()
		repeat
			local run = rx2:recv()
			if run == "quit" then
				break
			elseif run == "cd_quit" then
				break
			elseif run == "toggle" then
				local active = active_partition()

				if active and active.dist then
					set_pending_status()
					self.operate("unmount")
				elseif active and not active.dist then
					set_pending_status()
					self.operate("mount")
				end				
			elseif run == "mount" then
				self.operate("mount")
			elseif run == "unmount" then
				self.operate("unmount")
			elseif run == "eject" then
				self.operate("eject")
			end
		until not run
	end

	ya.join(producer, consumer1, consumer2)
end

function M:reflow() return { self } end

function M:redraw()
	local rows = {}
	for _, p in ipairs(self.partitions or {}) do
		if p.sub == "" and p.fstype == nil and p.dist == nil then
			rows[#rows + 1] = ui.Row { p.main }
		else

			rows[#rows + 1] = ui.Row { p.dist and (p.sub.." *") or (p.sub), p.label or "", p.dist or "", p.fstype or "" }
		end
	end

	return {
		ui.Clear(self._area),
		ui.Border(ui.Border.ALL)
			:area(self._area)
			:type(ui.Border.ROUNDED)
			:style(ui.Style():fg("#82ab3a"))
			:title(ui.Line(self.title):align(ui.Line.CENTER):fg(self.title_color)),
		ui.Table(rows)
			:area(self._area:pad(ui.Pad(1, 2, 1, 2)))
			:header(ui.Row({ "Src", "Label", "Dist", "FSType" }):style(ui.Style():bold()))
			:row(self.cursor)
			:row_style(ui.Style():fg("#82ab3a"):underline())
			:widths {
				ui.Constraint.Length(20),
				ui.Constraint.Length(20),
				ui.Constraint.Percentage(70),
				ui.Constraint.Length(10),
			},
	}
end

-- Function to execute system commands and capture output
local function exec_command(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result
end

-- Function to parse lsblk output and create a table
local function parse_lsblk()
    -- Execute lsblk commands
    local mount_output = exec_command("lsblk -l -o NAME,TYPE,MOUNTPOINT")
    local fstype_output = exec_command("lsblk -l -o NAME,TYPE,FSTYPE")
    local label_output = exec_command("lsblk -l -o NAME,TYPE,LABEL")

    -- Initialize tables to hold the parsed data
    local mount_table = {}
    local fstype_table = {}
    local label_table = {}

	local exit_main = {}

    -- Helper function to parse command output into a table
    local function parse_output(output, table)
        for line in output:gmatch("[^\r\n]+") do
            local name, type, value = line:match("(%S+)%s+(%S+)%s+(%S+.*)")
            if name and type then
                table[name] = value ~= "" and value or nil
            end
        end
    end

    -- Parse the outputs
    parse_output(mount_output, mount_table)
    parse_output(fstype_output, fstype_table)
    parse_output(label_output, label_table)

    -- Combine the data into the desired format
    local combined_table = {}
    for name, _ in pairs(fstype_table) do
        local main_device, sub_device
        if name:match("^nvme") then
            main_device = name:match("^(nvme%d+n%d)")
            sub_device = name:match("(p%d+)$")
        else
            main_device = name:match("^(%a+)%d+")
            sub_device = name:match("%d+$")
        end
        if main_device then

			if not exit_main[main_device] then
				exit_main[main_device] = true
				table.insert(combined_table, {
					main = "/dev/" .. main_device,
					src = "/dev/" .. main_device,
					sub = ""
				})
			end
			if name and fstype_table[name] and sub_device and fstype_table[name] ~= "swap" then
            	table.insert(combined_table, {
            	    dist = mount_table[name],
            	    fstype = fstype_table[name],
            	    label = label_table[name],
            	    main = "/dev/" .. main_device,
            	    src = "/dev/" .. name,
            	    sub = sub_device
            	})
			end
        end
    end

    return combined_table
end


function M.obtain()
	local tbl = {}
	if ya.target_os() == "macos" then
		local last
		for _, p in ipairs(fs.partitions()) do
			local main, sub
			main, sub = p.src:match("^(/dev/disk%d+)(.+)$")

			if sub then
				if last ~= main then
					last, tbl[#tbl + 1] = main, { src = main, main = main, sub = "" }
				end
				p.main, p.sub, tbl[#tbl + 1] = main, "  " .. sub, p
			end
		end
	else
		tbl = parse_lsblk()
	end
	table.sort(tbl, function(a, b)
		if a.main == b.main then
			return a.sub < b.sub
		else
			return a.main > b.main
		end
	end)
	return tbl
end

function M.operate(type)
	local active = active_partition()
	if not active then
		return
	elseif active.sub == "" then
		ya.manager_emit("plugin", {"mount", args = "refresh" })
		return -- TODO: mount/unmount main disk
	end

	local output, err
	if ya.target_os() == "macos" then
		output, err = Command("diskutil"):args({ type, active.src }):output()
	end
	if ya.target_os() == "linux" then
		if type == "eject" then
			Command("udisksctl"):args({ "unmount", "-b", active.src }):status()
			output, err = Command("udisksctl"):args({ "power-off", "-b", active.src }):output()
		else
			output, err = Command("udisksctl"):args({ type, "-b", active.src }):output()
		end
	end

	if not output then
		M.fail("Failed to %s `%s`: %s", type, active.src, err)
	elseif not output.status.success then
		M.fail("Failed to %s `%s`: %s", type, active.src, output.stderr)
	end
end

function M.fail(s, ...) 
	ya.manager_emit("plugin", {"mount", args = "refresh" })
	ya.notify { title = "Mount", content = string.format(s, ...), timeout = 10, level = "error" } 
end

function M:click() end

function M:scroll() end

function M:touch() end

return M

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function()

		local urls = selected_or_hovered()

		if #urls == 0 then
			return ya.notify({ title = "System Clipboard", content = "No file selected", level = "warn", timeout = 5 })
		end


	local args,child,files
	if  ya.target_family() == "windows" then
		files = table.concat(urls, [[","]])
		args = string.format([[Add-Type -AssemblyName System.Windows.Forms; $data = New-Object System.Collections.Specialized.StringCollection; $data.AddRange(@("%s")); [System.Windows.Forms.Clipboard]::SetFileDropList($data)]], files)
		shell = "powershell"
		child, _ = Command("powershell"):args({"-Command",args}):spawn()
	elseif ya.target_family() == "unix" and os.getenv("XDG_SESSION_TYPE") == "x11" then
		files = table.concat(urls, [[" "]])
		args = string.format([[for path in "%s"; do  echo -en "file://${path}\n"; done |  xclip -i -selection clipboard -rmlastnl -t text/uri-list]], files)
		child, _ = Command("bash"):args({"-c",args}):spawn()
	elseif ya.target_family() == "unix" and os.getenv("XDG_SESSION_TYPE") == "wayland" then
		files = table.concat(urls, [[" "]])
		args = string.format([[for path in "%s"; do echo -en "file://${path}\n"; done | wl-copy -t text/uri-list;]], files)
		child, _ = Command("bash"):args({"-c",args}):spawn()
  else
			ya.notify({
				title = "System Clipboard",
				content = "unknow desktop env",
				level = "error",
				timeout = 5,
			})
      return
	end
		local output, err = child:wait_with_output()

		if output and output.status.success then
			ya.notify({
				title = "System Clipboard",
				content = "Succesfully copied the file(s) to system clipboard",
				level = "info",
				timeout = 5,
			})
		else
			ya.notify({
				title = "System Clipboard",
				content = string.format(
					"Could not copy selected file(s) %s",
					status and status.code or err
				),
				level = "error",
				timeout = 5,
			})
		end
	end,
}

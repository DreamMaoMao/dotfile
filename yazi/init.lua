require("keyjump"):setup({
	icon_fg = "#fda1a1",
	first_key_fg = "#df6249",
    go_table = { -- `g` to open go menu(only global mode)
		{ on = { "w" },       run = "cd ~/文档/WeChat_Data/home",       desc = "Go to weixin" },
		{ on = { "n" },       run = "cd ~/_install",       desc = "Go to _install" },
		{ on = { "h" },       run = "cd ~",             desc = "Go to home" },
		{ on = { "c" },       run = "cd ~/.config",     desc = "Go to config" },
		{ on = { "u" },       run = "cd /media/UUI/",     desc = "Go to Mobile disk" },
		{ on = { "d" },       run = "cd ~/down",   desc = "Go to downloads" },
		{ on = { "t" },       run = "cd ~/tool/",          desc = "Go to tool" },
		{ on = { "o" },       run = "cd ~/video",          desc = "Go to video" },
		{ on = { "y" },       run = "cd ~/.config/yazi/",          desc = "Go to video" },
		{ on = { "i" },       run = "cd ~/Images",          desc = "Go to image" },
		{ on = { "r" },       run = "cd /",          desc = "Go to /" },
		{ on = { "j" },       run = "cd /home/wrq/deskenv/dev",          desc = "Go to dev" },
		{ on = { "k" },       run = "cd /home/wrq/deskenv/master",       desc = "Go to master" },

	}
})

require("easyjump"):setup({
	icon_fg = "#fda1a1",
    first_key_fg = "#df6249"
})

require("searchjump"):setup({
	unmatch_fg = "#b2a496",
    match_str_fg = "#000000",
    match_str_bg = "#73AC3A",
    first_match_str_fg = "#000000",
    first_match_str_bg = "#73AC3A",
    lable_fg = "#EADFC8",
    lable_bg = "#BA603D",
    only_current = false,
    show_search_in_statusbar = false,
    auto_exit_when_unmatch = false,
    enable_capital_lable = true,
	search_patterns = ({"hell[dk]d","%d+.1080p","第%d+集","第%d+话","%.E%d+","S%d+E%d+",})
})

require("status-owner"):setup({
	color = "#d98a8a"
})

require("status-mtime"):setup({
	color = "#ba884a"
})

require("header-hidden"):setup({
    color = "#88c2f4"
})

require("header-host"):setup({
    color = "#B5B520"
})


require("fg"):setup({
    default_action = "menu", -- nvim, jump
})


require("cd-last"):setup()


require("git"):setup()
require("current-size"):setup({
    equal_ignore = {"~","/","/home"}, -- full path match
	-- sub_ignore = {"~/deskenv/master","~/deskenv/dev"} -- sub path match
})

require("full-border"):setup()

require("mime-preview"):setup()

require("autofilter"):setup({
  -- cache_path = '/home/wrq/autofiltercache',
})
require("autosort"):setup({
  -- cache_path = '/home/wrq/autosortcache',
})
-- require("session"):setup({
-- 	sync_yanked = true,
-- })

require("lastopen"):setup({
  -- cache_path = '/home/wrq/lastopencache',
})
require("mime-ext"):setup {
	-- Expand the existing filename database (lowercase), for example:
	-- with_files = {
	-- 	makefile = "text/makefile",
	-- 	-- ...
	-- },

	-- Expand the existing extension database (lowercase), for example:
	with_exts = require("mime-preview"):get_mime_data(),

	-- If the mime-type is not in both filename and extension databases,
	-- then fallback to Yazi's preset `mime` plugin, which uses `file(1)`
	fallback_file1 = true,
}

require("zoxide"):setup {
	update_db = true,
}

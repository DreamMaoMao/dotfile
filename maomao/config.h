/* speedie's maomao config */

#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

/* animaion */
static const char *animation_type = "slide"; //是否启用动画 //slide,zoom
static const bool animations = true; //是否启用动画
static const char animation_fade_in = 1; // Enable animation fade in
static const float zoom_initial_ratio = 0.5; //动画起始窗口比例
static const float fadeout_begin_opacity = 0.9; // Begin opacity for animations fadeout
static const float fadein_begin_opacity = 0; // Begin opac window ratio for animations
static const uint32_t animation_duration_move = 400; // Animation move speed
static const uint32_t animation_duration_open = 400; // Animation open speed
static const uint32_t animation_duration_close = 300; // Animation close speed
static const uint32_t animation_duration_tag = 300; // Animation tag speed
static const double animation_curve[4] = {0.46,1.0,0.29,0.99}; //动画曲线

/* appearance */
static const unsigned int axis_bind_apply_timeout = 100; //滚轮绑定动作的触发的时间间隔
static const unsigned int focus_on_activate = 1; //收到窗口激活请求是否自动跳转聚焦
static const unsigned int new_is_master = 1; //新窗口是否插在头部
static const unsigned int default_mfact = 0.55f; // master 窗口比例
static const unsigned int default_nmaster = 1; //默认master数量
/* logging */
static int log_level = WLR_ERROR;
static const unsigned int numlockon = 1; //是否打开右边小键盘
static const unsigned int hotarea_size              = 10; //热区大小,10x10
static const unsigned int enable_hotarea            = 1; //是否启用鼠标热区
static int smartgaps                 = 0;  /* 1 means no outer gap when there is only one window */
static int sloppyfocus               = 1;  /* focus follows mouse */
static unsigned int gappih           = 5; /* horiz inner gap between windows */
static unsigned int gappiv           = 5; /* vert inner gap between windows */
static unsigned int gappoh           = 10; /* horiz outer gap between windows and screen edge */
static unsigned int gappov           = 10; /* vert outer gap between windows and screen edge */
static int bypass_surface_visibility = 0;  /* 1 means idle inhibitors will disable idle tracking even if it's surface isn't visible  */
static unsigned int borderpx         = 5;  /* border pixel of windows */
static const float rootcolor[]             = COLOR(0x323232ff);
static const float bordercolor[]           = COLOR(0x444444ff);
static const float focuscolor[]            = COLOR(0xad741fff);
static const float fakefullscreencolor[]   = COLOR(0x89aa61ff);
static const float urgentcolor[]           = COLOR(0xad401fff);
static const float scratchpadcolor[]       = COLOR(0x516c93ff);
static const float globalcolor[]       	   = COLOR(0xb153a7ff);
// static const char *cursor_theme = "Bibata-Modern-Ice";

static const int overviewgappi = 5; /* overview时 窗口与边缘 缝隙大小 */
static const int overviewgappo = 30; /* overview时 窗口与窗口 缝隙大小 */

/* To conform the xdg-protocol, set the alpha to zero to restore the old behavior */
static const float fullscreen_bg[]         = {0.1, 0.1, 0.1, 1.0};

static int warpcursor = 1; /* Warp cursor to focused client */

/* Autostart */
static const char *const autostart[] = {
	"/bin/sh",
	"-c",
	"~/.config/maomao/autostart.sh",
	NULL,
	NULL,
};

/* tagging
 * expand the array to add more tags
 */
static const char *tags[] = {
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
};

static const Rule rules[] = {
	/* app_id     title       tags mask     isfloating  isfullscreen animation_type isnoborder monitor  width height */
	/* examples:
	{ "Gimp",     NULL,       0,            1,           -1,800,600 },
	*/
	{ NULL,  									"QQ",       		1 << 2,       	0,   0, 	NULL,      0,-1, 0,0},
	{ "Google-chrome",  						NULL,       		1 << 3,       	0,   0, 	NULL,		0,-1, 0,0},
	{ "Microsoft-edge-dev", 		 			NULL,       		1 << 4,       	0,   0, 	NULL,		0,-1, 0,0},
	{ "Clash for Windows",  					NULL,       		0,       		1,   0, 	NULL,		0,-1, 1400,800},
	{ "electron-netease-cloud-music",  			NULL,       		0,       		1,   0, 	NULL,		0,-1, 1300,900},
	{ "yesplaymusic",  							NULL,       		1 << 4,       	1,   0, 	NULL,      0,-1, 1500,900},
	{ NULL,  									"图片查看器",   	  0,       		  1,   0, 	"zoom",		 0,-1, 0,0},
	{ NULL,  									"图片查看",     	 0,       		  1,   0, 	"zoom",		 0,-1, 0,0},
	{ NULL,  									"选择文件",     	 0,       		  1,   0, 	"zoom",		 0,-1, 1200,800},
	{ NULL,  									"打开文件",     	 0,       		 1,   0, 	"zoom",		 0,-1, 1200,800},
	{ "polkit-gnome-authentication-agent-1",  	NULL,       		0,       		1,   0, 	"zoom",		0,-1, 0,0},
	{ "blueman-manager",  						NULL,       		0,       		1,   0, 	NULL,		0,-1, 700,600},
	{ "clash-verge",  							NULL,       		0,       		1,   0, 	NULL,		0,-1, 1200,800},
	{ "Gnome-system-monitor",  					NULL,       		0,       		0,   0, 	NULL,		0,-1, 700,600},
	{ "obs",  									NULL,       		1<<5,       	0,   0, 	NULL,		0,-1, 700,600},
	{ "flameshot",  							NULL,       		0,       		0,   1, 	NULL,		0,-1, 0,0},
	{ "com.xunlei.download",  					NULL,       		0,       		1,   0, 	NULL,		0,-1, 600,800},
	{ "pavucontrol",  							NULL,       		0,       		1,   0, 	NULL,		0,-1, 0,0},
	{ "baidunetdisk",  							NULL,       		0,       		1,   0, 	NULL,		0,-1, 1400,800},
	{ "alixby3",  								NULL,       		0,       		1,   0, 	NULL,		0,-1, 1400,800},
	{ "qxdrag.py",  							NULL,       		0,       		1,   0, 	"zoom",		0,-1, 400,300},
	{ NULL,  									"qxdrag",        	0,       		1,   0, 	"zoom",		0,-1, 400,300},
	{ NULL,  									"rofi - Networks",  0,       		1,   0, 	"zoom",		1,-1, 0,0},
	{ "Rofi",  									NULL,        		0,       		1,   0, 	"zoom",		1,-1, 0,0},
	{ "wofi",  									NULL,        		0,       		1,   0, 	"zoom",		1,-1, 0,0},
	{ "pot",  									NULL,        		0,       		1,   0, 	"zoom",		1,-1, 0,0},

};

/* layout(s) */
static const Layout overviewlayout = { "󰃇",  overview };

static const Layout layouts[] = { //最少两个,不能删除少于两个
	/* symbol     arrange function */
	{ "󱞬",      tile },	//堆栈布局
	{ "﩯",      grid },    //网格布局

};

/* monitors */
static const MonitorRule monrules[] = {
	/* name       		mfact 	nmaster scale 	layout       rotate/reflect    			x y*/
	/* example of a HiDPI laptop monitor:
	{ "eDP-1",    0.5,  1,      2,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL },
	*/
	/* defaults */
	// { "eDP-1",    		0.5,  	1,      1,    	&layouts[0], WL_OUTPUT_TRANSFORM_NORMAL },
	{ "eDP-1",       0.55f, 	1,      1,    	&layouts[0], 		WL_OUTPUT_TRANSFORM_NORMAL,	0,0},
	{ "HDMI-A-1",       0.55f, 	1,      1,    	&layouts[0], 		WL_OUTPUT_TRANSFORM_NORMAL,	1920,0},
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
	/* can specify fields: rules, model, layout, variant, options */
	/* example:
	.options = "ctrl:nocaps",
	*/
	.options = NULL,
};

static int repeat_rate = 25;
static int repeat_delay = 600;

/* Trackpad */
static int tap_to_click = 1;
static int tap_and_drag = 1;
static int drag_lock = 1;
static int natural_scrolling = 0;
static int disable_while_typing = 1;
static int left_handed = 0;
static int middle_button_emulation = 0;
/* You can choose between:
LIBINPUT_CONFIG_SCROLL_NO_SCROLL
LIBINPUT_CONFIG_SCROLL_2FG
LIBINPUT_CONFIG_SCROLL_EDGE
LIBINPUT_CONFIG_SCROLL_ON_BUTTON_DOWN
*/
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;

/* You can choose between:
LIBINPUT_CONFIG_CLICK_METHOD_NONE
LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS
LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER
*/
static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;

/* You can choose between:
LIBINPUT_CONFIG_SEND_EVENTS_ENABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED_ON_EXTERNAL_MOUSE
*/
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;

/* You can choose between:
LIBINPUT_CONFIG_ACCEL_PROFILE_FLAT
LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE
*/
static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;
/* You can choose between:
LIBINPUT_CONFIG_TAP_MAP_LRM -- 1/2/3 finger tap maps to left/right/middle
LIBINPUT_CONFIG_TAP_MAP_LMR -- 1/2/3 finger tap maps to left/middle/right
*/
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* If you want to use the windows key for MODKEY, use WLR_MODIFIER_LOGO */
#define MODKEY WLR_MODIFIER_ALT

#define TAGKEYS(KEY,SKEY,TAG) \
	{ WLR_MODIFIER_CTRL,                    KEY,            bind_to_view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
	{ WLR_MODIFIER_ALT, KEY,           tag,             {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,SKEY,toggletag, {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
// static const char *termcmd[] = { "st", NULL };
// static const char *menucmd[] = { "wofi --conf ~/.config/maomao/wofi/config_menu", NULL };

static const Key keys[] = {
	/* Note that Shift changes certain key codes: c -> C, 2 -> at, etc. */
	/* modifier                  			key                 	function        			argument */
	{ MODKEY,					 			XKB_KEY_space,      	spawn,          			SHCMD("wofi --normal-window -c ~/.config/maomao/wofi/config -s ~/.config/maomao/wofi/style.css") },
	{ MODKEY, 					 			XKB_KEY_Return,     	spawn,          			SHCMD("st") },
    { WLR_MODIFIER_LOGO,         			XKB_KEY_Return, 		spawn, 						SHCMD("google-chrome") },
    { WLR_MODIFIER_LOGO,         			XKB_KEY_space, 			spawn, 						SHCMD("microsoft-edge") },
	{ WLR_MODIFIER_CTRL,         			XKB_KEY_Return,         spawn, 						SHCMD("bash ~/tool/clash.sh") }, 
    { WLR_MODIFIER_CTRL|WLR_MODIFIER_LOGO,  XKB_KEY_Return, 		spawn, 						SHCMD("st -e /usr/local/bin/yazi") },  
    { WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT, XKB_KEY_Return, 		spawn, 						SHCMD("st -e aerc") },  
    { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,   XKB_KEY_a, 		 		spawn, 						SHCMD("grim -g \"$(slurp)\" - | swappy -f -") }, 
    { WLR_MODIFIER_LOGO,   					XKB_KEY_h, 		 		spawn, 						SHCMD("bash ~/tool/hide_waybar_dwl.sh") }, 
	{ WLR_MODIFIER_LOGO,         			XKB_KEY_l,          	spawn, 						SHCMD("swaylock -f -c 000000") }, 
    { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,   XKB_KEY_Return, 		spawn, 						SHCMD("st -e ~/tool/ter-multiplexer.sh") },  
    // { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,   XKB_KEY_Return, 		spawn, 						SHCMD("st -e \"zellij -s temp --config /home/wrq/.config/zellij/tempconfigwayland.kdl\"") },  
    /* { WLR_MODIFIER_LOGO,   					XKB_KEY_space, 			spawn, 						SHCMD("/usr/bin/rofi -config ~/.config/rofi/themes/trans.rasi -show website") },   */
    // { WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT,   XKB_KEY_Return, 		spawn, 						SHCMD("rofi -normal-window -theme ~/.config/rofi/themes/fancy2.rasi -modi blocks -show blocks -blocks-wrap ~/tool/movie.py") },  
    { WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT,   XKB_KEY_Return, 		spawn, 						SHCMD("mpv --player-operation-mode=pseudo-gui") },
    { WLR_MODIFIER_CTRL,   					XKB_KEY_space, 			spawn, 						SHCMD("rofi -normal-window -theme ~/.config/rofi/themes/fancy2.rasi -modi blocks -show blocks -blocks-wrap ~/.config/rofi/search.py") },  
    { WLR_MODIFIER_LOGO,   					XKB_KEY_space, 				spawn, 						SHCMD("rofi -normal-window -theme  ~/.config/rofi/themes/fancy2.rasi -modi blocks -show blocks -blocks-wrap ~/.config/rofi/history.py") },  

    { WLR_MODIFIER_CTRL,   					XKB_KEY_comma, 			spawn, 						SHCMD("~/.config/hypr/scripts/brightness.sh down") },  
    { WLR_MODIFIER_CTRL,   					XKB_KEY_period, 		spawn, 						SHCMD("~/.config/hypr/scripts/brightness.sh up") },  
    { WLR_MODIFIER_ALT,   					XKB_KEY_comma, 			spawn, 						SHCMD("~/.config/hypr/scripts/volume.sh down") },  
    { WLR_MODIFIER_ALT,   					XKB_KEY_period, 		spawn, 						SHCMD("~/.config/hypr/scripts/volume.sh up") },  
    { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,   XKB_KEY_backslash, 		spawn, 						SHCMD("swaync-client -t") },  
    { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,   XKB_KEY_BackSpace, 		spawn, 						SHCMD("swaync-client -C") }, 
    { WLR_MODIFIER_LOGO|WLR_MODIFIER_SHIFT, XKB_KEY_P, 				spawn, 						SHCMD("wlr-randr --output eDP-1 --on") },    //打开笔记本显示器
    { WLR_MODIFIER_LOGO,   					XKB_KEY_p, 				spawn, 						SHCMD("bash ~/.config/maomao/scripts/monitor.sh") },   //关闭笔记本显示器
    { WLR_MODIFIER_LOGO,   					XKB_KEY_k, 				spawn, 						SHCMD("bash ~/tool/wshowkey.sh") },   //显示按键


	{ WLR_MODIFIER_LOGO,                    XKB_KEY_Tab,          	focusstack,     			{.i = +1} },

    { WLR_MODIFIER_ALT,                  	XKB_KEY_Left,         	focusdir,         			{.i = LEFT } },            /* alt left           |  本tag内切换聚焦窗口 */
    { WLR_MODIFIER_ALT,                  	XKB_KEY_Right,        	focusdir,         			{.i = RIGHT } },           /* alt right          |  本tag内切换聚焦窗口 */
    { WLR_MODIFIER_ALT,                  	XKB_KEY_Up,           	focusdir,         			{.i = UP } },              /* alt up             |  本tag内切换聚焦窗口 */
    { WLR_MODIFIER_ALT,                  	XKB_KEY_Down,         	focusdir,         			{.i = DOWN } },    


	{ WLR_MODIFIER_LOGO,                    XKB_KEY_e,          	incnmaster,     			{.i = +1} },
	{ WLR_MODIFIER_LOGO,                    XKB_KEY_t,          	incnmaster,     			{.i = -1} },
	{ WLR_MODIFIER_ALT|WLR_MODIFIER_CTRL,   XKB_KEY_Left,          	setmfact,       			{.f = -0.01} },
	{ WLR_MODIFIER_ALT|WLR_MODIFIER_CTRL,   XKB_KEY_Right,         	setmfact,       			{.f = +0.01} },
	{ MODKEY,                    			XKB_KEY_s,          	zoom,           			{0} },
    { WLR_MODIFIER_LOGO|WLR_MODIFIER_SHIFT, XKB_KEY_Up,           	exchange_client,  			{.i = UP } },              /* super shift up       | 二维交换窗口 (仅平铺) */
    { WLR_MODIFIER_LOGO|WLR_MODIFIER_SHIFT, XKB_KEY_Down,         	exchange_client,  			{.i = DOWN } },            /* super shift down     | 二维交换窗口 (仅平铺) */
    { WLR_MODIFIER_LOGO|WLR_MODIFIER_SHIFT, XKB_KEY_Left,         	exchange_client,  			{.i = LEFT} },             /* super shift left     | 二维交换窗口 (仅平铺) */
    { WLR_MODIFIER_LOGO|WLR_MODIFIER_SHIFT, XKB_KEY_Right,        	exchange_client,  			{.i = RIGHT } },  		   /* super shift right     | 二维交换窗口 (仅平铺) */
	{ WLR_MODIFIER_LOGO,                    XKB_KEY_g,          	toggleglobal,           	{0} },
	{ MODKEY,                    			XKB_KEY_Tab,        	toggleoverview,         	{0} },
	{ WLR_MODIFIER_LOGO,                    XKB_KEY_Left,        	viewtoleft,           		{0} },
	{ WLR_MODIFIER_CTRL,                    XKB_KEY_Left,        	viewtoleft_have_client, 	{0} },
	{ WLR_MODIFIER_LOGO,                    XKB_KEY_Right,        	viewtoright,            	{0} },
	{ WLR_MODIFIER_CTRL,                    XKB_KEY_Right,        	viewtoright_have_client,	{0} },
    { WLR_MODIFIER_CTRL|WLR_MODIFIER_LOGO,  XKB_KEY_Left,         	tagtoleft,        			{0} },                     /* ctrl alt left      |  将本窗口移动到左边tag */
    { WLR_MODIFIER_CTRL|WLR_MODIFIER_LOGO,  XKB_KEY_Right,        	tagtoright,       			{0} }, 
	{ MODKEY,					 			XKB_KEY_q,          	killclient,     			{0} },
	{ WLR_MODIFIER_CTRL|WLR_MODIFIER_LOGO,  XKB_KEY_t,          	setlayout,      			{.v = &layouts[0]} },
	{ WLR_MODIFIER_CTRL|WLR_MODIFIER_LOGO,  XKB_KEY_g,          	setlayout,      			{.v = &layouts[1]} },
	{ WLR_MODIFIER_LOGO,                    XKB_KEY_n,          	switch_layout,      		{0} },
	{ WLR_MODIFIER_ALT, 					XKB_KEY_backslash,      togglefloating, 			{0} },
	{ MODKEY,                    			XKB_KEY_a,          	togglefakefullscreen, 		{0} },
	{ MODKEY,                    			XKB_KEY_f,          	togglefullscreen, 		{0} },
	{ WLR_MODIFIER_LOGO,                    XKB_KEY_i,          	minized, 					{0} },  //最小化,放入便签
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_SHIFT, XKB_KEY_I,          	restore_minized, 			{0} },
	{ WLR_MODIFIER_ALT, 					XKB_KEY_z,          	toggle_scratchpad, 			{0} },  //便签循环切换
	// { WLR_MODIFIER_CTRL,                    XKB_KEY_KP_0,          	view,           			{.ui = ~0} },
	// { WLR_MODIFIER_CTRL|WLR_MODIFIER_LOGO, 	XKB_KEY_KP_0, 			tag,            			{.ui = ~0} },
	{ WLR_MODIFIER_LOGO,                    XKB_KEY_bracketleft,    focusmon,       			{.i = WLR_DIRECTION_LEFT} },  //super + [
	{ WLR_MODIFIER_LOGO,                    XKB_KEY_bracketright,   focusmon,       			{.i = WLR_DIRECTION_RIGHT} }, // suepr + ]
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_CTRL, XKB_KEY_bracketleft,    tagmon,         			{.i = WLR_DIRECTION_LEFT} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_CTRL, XKB_KEY_bracketright,   tagmon,         			{.i = WLR_DIRECTION_RIGHT} },
    { MODKEY|WLR_MODIFIER_SHIFT, 			XKB_KEY_X,          	incgaps,        			{.i = +1 } },
	{ MODKEY|WLR_MODIFIER_SHIFT, 			XKB_KEY_Z,          	incgaps,        			{.i = -1 } },
	{ MODKEY|WLR_MODIFIER_SHIFT, 			XKB_KEY_R,          	togglegaps,     			{0} },
	TAGKEYS(          XKB_KEY_KP_1, XKB_KEY_exclam,                     0),
	TAGKEYS(          XKB_KEY_KP_2, XKB_KEY_at,                         1),
	TAGKEYS(          XKB_KEY_KP_3, XKB_KEY_numbersign,                 2),
	TAGKEYS(          XKB_KEY_KP_4, XKB_KEY_dollar,                     3),
	TAGKEYS(          XKB_KEY_KP_5, XKB_KEY_percent,                    4),
	TAGKEYS(          XKB_KEY_KP_6, XKB_KEY_asciicircum,                5),
	TAGKEYS(          XKB_KEY_KP_7, XKB_KEY_ampersand,                  6),
	TAGKEYS(          XKB_KEY_KP_8, XKB_KEY_asterisk,                   7),
	TAGKEYS(          XKB_KEY_KP_9, XKB_KEY_parenleft,                  8),
	//{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Q,          quit,           {0} },

	/* Ctrl-Alt-Backspace and Ctrl-Alt-Fx used to be handled by X server */
	{ WLR_MODIFIER_LOGO,XKB_KEY_m, quit, {0} },
#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_XF86Switch_VT_##n, chvt, {.ui = (n)} }
	CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
	CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),
};

static const Button buttons[] = {
	{ WLR_MODIFIER_LOGO, 	BTN_LEFT,   	moveresize,     			{.ui = CurMove } },
	{ 0, 					BTN_MIDDLE, 	togglefakefullscreen, 		{0} }, //中键触发假全屏
	{ WLR_MODIFIER_LOGO, 	BTN_RIGHT,  	moveresize,     			{.ui = CurResize } },
	{ WLR_MODIFIER_ALT|WLR_MODIFIER_CTRL, 	BTN_LEFT,  		spawn,						SHCMD("bash ~/tool/shotTranslate.sh shot")},
	{ 0, 					BTN_LEFT,  		toggleoverview,     		{0} },
	{ 0, 					BTN_RIGHT,  	killclient,     			{0} },
};

static const Axis axes[] = {
	{ WLR_MODIFIER_LOGO, AxisUp, 	viewtoleft_have_client, 	{0} }, //中键+super向前切换工作区
	{ WLR_MODIFIER_LOGO, AxisDown, viewtoright_have_client, 	{0} }, //中键+super向后切换工作区
};

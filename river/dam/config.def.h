/* appearance */
static int showbar           = 1; /* 0 means no bar */
static int topbar            = 1; /* 0 means bottom bar */
static const char *fonts[]   = {"JetbrainsMono Nerd Font:size=11:antialias=true:hinting=true", "Noto Color Emoji Regular:size=11:antialias=true:hinting=true"};

static uint32_t colors[][3]  = {
	/*               fg          bg         */
	[SchemeNorm] = { 0x93a1a1ff, 0x000000ff },
	[SchemeSel]  = { 0xeeeeeeff, 0x000000ff },
};

/* tagging */
static char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

/* layout name replacement values */
static const char *layouts[][2] = {
	/* layout name          replace */
	{ "rivertile - left",   "[]=" },
	{ "rivertile - right",  "=[]" },
	{ "rivertile - top",    "[^]" },
	{ "rivertile - bottom", "[_]" },
	{ NULL,                 "><>" }, /* no layout, last layout */
};

static const char *termcmd[] = { "foot", NULL };

/* button definitions */
/* click can be ClkTagBar, ClkLayout, ClkMode, ClkTitle, ClkStatus */
static const Button buttons[] = {
	/* click     button      function  argument */
	{ ClkTagBar, BTN_LEFT,   command,  {.s = "set-focused-tags"} },
	{ ClkTagBar, BTN_RIGHT,  command,  {.s = "set-view-tags"} },
	{ ClkTagBar, BTN_MIDDLE, command,  {.s = "toggle-focused-tags"} },
	{ ClkTitle,  BTN_LEFT,   command,  {.s = "zoom"} },
	{ ClkStatus, BTN_LEFT, spawn,    {.v = termcmd } },
};

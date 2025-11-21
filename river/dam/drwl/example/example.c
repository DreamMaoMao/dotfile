/* Code adapted from wayland-book XDG shell & fcft example. */
#include <errno.h>
#include <getopt.h>
#include <poll.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>
#include <wayland-client.h>

#include "drwl.h"
#include "bufpool.h"
#include "xdg-shell-client-protocol.h"

#define LENGTH(X) (sizeof(X) / sizeof(X[0]))

enum { FontSans, FontMono };
enum { SchemeNorm, SchemeBack };

static const char *font_names[][1] = {
	[FontSans] = { "sans:size=16" },
	[FontMono] = { "monospace:size=16" },
};

static struct fcft_font *fonts[LENGTH(font_names)];

static uint32_t scheme[][2] = {
	/*               fg           bg         */
	[SchemeNorm]  = { 0xbbbbbbff, 0x005577ff },
	[SchemeBack]  = { 0x222222ff, 0x22222266 },
};

static const char *text = "hello world 😺";

static struct wl_display *display;
static struct wl_registry *registry;
static struct wl_shm *shm;
static struct wl_compositor *compositor;
static struct xdg_wm_base *xdg_wm_base;
static struct wl_surface *surface;
static struct xdg_surface *xdg_surface;
static struct xdg_toplevel *xdg_toplevel;
static Drwl *drwl;
static BufPool pool;

static int32_t width = 640;
static int32_t height = 480;
static int32_t scale = 1;
static bool running = false;

static void
noop()
{
	/*
	 * :3
	 */
}

static void
die(const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);

	if (fmt[0] && fmt[strlen(fmt)-1] == ':') {
		fputc(' ', stderr);
		perror(NULL);
	} else {
		fputc('\n', stderr);
	}

	exit(EXIT_FAILURE);
}

static void
fonts_destroy(void)
{
	int i;

	for (i = 0; i < LENGTH(fonts); i++)
		drwl_font_destroy(fonts[i]);
}

static void
fonts_load(void)
{
	int i;
	char fontattrs[12];

	fonts_destroy();
	snprintf(fontattrs, sizeof(fontattrs), "dpi=%.2f", 96. * scale);
	for (i = 0; i < LENGTH(fonts); i++)
		if (!(fonts[i] = drwl_font_create(NULL, LENGTH(font_names[i]), font_names[i], fontattrs)))
			die("could not load font %d", i);
}

static void 
surface_handle_preferred_scale(void *data, 
	struct wl_surface *surface, int32_t factor)
{
	scale = factor;
	fonts_load();
}

static void
draw_frame(void)
{
	int y;
	int fh;
	int tw;
	char tbuf[50];
	time_t t;
	DrwBuf *buf = NULL;

	errno = 0;
	if (!(buf = bufpool_getbuf(&pool, shm, width, height))) {
		if (errno)
			die("poolbuf_create:");
		else
			die("no buffer avail");
	}
	drwl_setimage(drwl, buf->image);

	drwl_setscheme(drwl, scheme[SchemeBack]);
	drwl_rect(drwl, 0, 0, width, height, 1, 1);
	drwl_setscheme(drwl, scheme[SchemeNorm]);

	drwl_setfont(drwl, fonts[FontSans]);
	fh = drwl->font->height;
	tw = drwl_font_getwidth(drwl, text);
	y = (height - fh) / 2;

	drwl_text(drwl, 0, y, width, fh, (width - tw) / 2, text, 1);
	
	drwl_setfont(drwl, fonts[FontMono]);
	fh = drwl->font->height;
	y = height - fh;
	
	drwl_setscheme(drwl, scheme[SchemeBack]);
	drwl_rect(drwl, 0, y, width, fh, 1, 0);
	drwl_setscheme(drwl, scheme[SchemeNorm]);

	t = time(NULL);
	strftime(tbuf, sizeof(tbuf), "%c", localtime(&t));
	tw = drwl_font_getwidth(drwl, tbuf);
	drwl_text(drwl, 0, y, tw, fh, 0, tbuf, 0);

	sprintf(tbuf, "%p %d %dx%d", (void*)buf, buf->size, width, height);
	tw = drwl_font_getwidth(drwl, tbuf);
	drwl_text(drwl, width - tw, y, tw, fh, 0, tbuf, 0);

	drwl_setimage(drwl, buf->image);
	wl_surface_set_buffer_scale(surface, scale);
	wl_surface_attach(surface, buf->wl_buf, 0, 0);
	wl_surface_damage_buffer(surface, 0, 0, width, height);
	wl_surface_commit(surface);
}


static void
xdg_toplevel_configure(void *data,
		struct xdg_toplevel *xdg_toplevel, int32_t w, int32_t h,
		struct wl_array *states)
{
	if (w == 0 || h == 0)
		return;

	width = w * scale;
	height = h * scale;
}

static void
xdg_toplevel_close(void *data, struct xdg_toplevel *toplevel)
{
	running = false;
}

static const struct xdg_toplevel_listener xdg_toplevel_listener = {
	.configure = xdg_toplevel_configure,
	.close = xdg_toplevel_close,
};

static void
xdg_surface_configure(void *data,
		struct xdg_surface *xdg_surface, uint32_t serial)
{
	xdg_surface_ack_configure(xdg_surface, serial);
	draw_frame();
}

static const struct xdg_surface_listener xdg_surface_listener = {
	.configure = xdg_surface_configure,
};

static const struct wl_surface_listener surface_listener = {
	.enter = noop,
	.leave = noop,
	.preferred_buffer_scale = surface_handle_preferred_scale,
	.preferred_buffer_transform = noop,
};

static void
xdg_wm_base_ping(void *data, struct xdg_wm_base *xdg_wm_base, uint32_t serial)
{
	xdg_wm_base_pong(xdg_wm_base, serial);
}

static const struct xdg_wm_base_listener xdg_wm_base_listener = {
	.ping = xdg_wm_base_ping,
};

static void
registry_global(void *data, struct wl_registry *registry,
		uint32_t name, const char *interface, uint32_t version)
{
	if (!strcmp(interface, wl_shm_interface.name))
		shm = wl_registry_bind(registry, name, &wl_shm_interface, 1);
	else if (!strcmp(interface, wl_compositor_interface.name))
		compositor = wl_registry_bind(
			registry, name, &wl_compositor_interface, 6);
	else if (!strcmp(interface, xdg_wm_base_interface.name)) {
		xdg_wm_base = wl_registry_bind(
				registry, name, &xdg_wm_base_interface, 1);
		xdg_wm_base_add_listener(xdg_wm_base,
				&xdg_wm_base_listener, NULL);
	}
}

static const struct wl_registry_listener registry_listener = {
	.global = registry_global,
	.global_remove = noop,
};

static void
setup(void)
{
	if (!(display = wl_display_connect(NULL)))
		die("can't connect to wayland");

	registry = wl_display_get_registry(display);
	wl_registry_add_listener(registry, &registry_listener, NULL);
	wl_display_roundtrip(display);

	if (!shm || !compositor || !xdg_wm_base)
		die("bad compositor");

	surface = wl_compositor_create_surface(compositor);
	wl_surface_add_listener(surface, &surface_listener, NULL);

	xdg_surface = xdg_wm_base_get_xdg_surface(xdg_wm_base, surface);
	xdg_surface_add_listener(xdg_surface, &xdg_surface_listener, NULL);

	xdg_toplevel = xdg_surface_get_toplevel(xdg_surface);
	xdg_toplevel_add_listener(xdg_toplevel, &xdg_toplevel_listener, NULL);
	xdg_toplevel_set_title(xdg_toplevel, "drwl demo");
	
	wl_surface_commit(surface);

	if (!(drwl_init()))
		die("failed to initialize drwl");

	if (!(drwl = drwl_create()))
		die("could not create drwl drawing context");

	fonts_load();
}

/* More complicated run routine to allow for timeout of 1 second */
static void
run(void)
{
	int ret;
	struct pollfd pfds[] = {
		{ .fd = wl_display_get_fd(display), .events = POLLIN }
	};

	running = true;

/*
	while (running && display_dispatch(display) > 0)
		;
*/
	
	while (running) {
		if (wl_display_prepare_read(display) < 0)
			if (wl_display_dispatch_pending(display) < 0)
				die("wl_display_dispatch_pending:");

		if (wl_display_flush(display) < 0)
			die("wl_display_flush:");

		if ((ret = poll(pfds, LENGTH(pfds), 1000)) < 0) {
			wl_display_cancel_read(display);
			die("poll:");
		} else if (ret == 0)
			draw_frame();

		if (!(pfds[0].revents & POLLIN)) {
			wl_display_cancel_read(display);
			continue;
		}

		if (wl_display_read_events(display) < 0)
			die("wl_display_read_events:");
		if (wl_display_dispatch_pending(display) < 0)
			die("wl_display_dispatch_pending:");
	}
}

static void
cleanup(void)
{
	drwl_setimage(drwl, NULL);
	bufpool_cleanup(&pool);
	drwl_setfont(drwl, NULL);
	fonts_destroy();
	xdg_toplevel_destroy(xdg_toplevel);
	xdg_surface_destroy(xdg_surface);
	wl_surface_destroy(surface);
	drwl_destroy(drwl);
	drwl_fini();
	xdg_wm_base_destroy(xdg_wm_base);
	wl_compositor_destroy(compositor);
	wl_shm_destroy(shm);
	wl_registry_destroy(registry);
	wl_display_disconnect(display);
}

int
main(int argc, char *argv[])
{
	int opt;

	while ((opt = getopt(argc, argv, "t:h")) != -1)  {
		switch (opt) {
		case 't':
			text = optarg;
			break;
		case 'h':
		default:
			fprintf(stderr, "usage: %s [-h] [-t text]\n", argv[0]);
			return opt == 'h' ? EXIT_SUCCESS : EXIT_FAILURE;
		}
	}

	setup();
	run();
	cleanup();

	return EXIT_SUCCESS;
}

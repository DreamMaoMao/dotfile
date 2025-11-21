/* Layout generator for river based on the layout example from the river repo
 * with some features added to it:
 *
 * Per-tag state
 * Master/stack(s) layout
 * Monocle with no borders borders
 * Layout toggling via cmd
 * Inner, outer and smart gaps
 * Smart borders (dont work too well with floating windows, feel free to fix if needed)
 *
 *
 *
 * To build, you need to generate the header and code of the layout protocol
 * extension and link against them. This is done by the makefile provided in
 * this directory. You just need to make install.
 */

#include <assert.h>
#include <ctype.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <wayland-client.h>
#include <wayland-client-protocol.h>

#include "river-layout-v3.h"

#define MIN(a, b) ( (a) < (b) ? (a) : (b) )
#define MAX(a, b) ( (a) > (b) ? (a) : (b) )
#define CLAMP(a, b, c) ( MIN(MAX(b, c), MAX(MIN(b, c), a)) )

struct Output {
    struct wl_list link;
    struct wl_output       *output;
    struct river_layout_v3 *layout;

    #define MAX_TAGS 32

    uint32_t main_count[MAX_TAGS];
    double   main_ratio[MAX_TAGS];
    bool     monocle[MAX_TAGS];
    uint32_t last_tags;

    // gaps
    uint32_t view_padding;
    uint32_t outer_padding;
    bool     smart_gaps;

    // borders
    uint32_t border_width;
    bool     smart_borders;
    uint32_t last_sent_border_width;

    bool configured;
};

struct wl_display  *wl_display;
struct wl_registry *wl_registry;
struct wl_callback *sync_callback;
struct river_layout_manager_v3 *layout_manager;
struct wl_list outputs;
bool loop = true;
int ret = EXIT_FAILURE;

static void layout_handle_layout_demand(void *data,
        struct river_layout_v3 *river_layout,
        uint32_t view_count, uint32_t width, uint32_t height,
        uint32_t tags, uint32_t serial)
{
    struct Output *o = data;
    o->last_tags = tags;

    unsigned int ti = (tags ? __builtin_ffs(tags)-1 : 0);
    uint32_t mcount = o->main_count[ti];
    double   mratio = o->main_ratio[ti];
    bool     mono   = o->monocle[ti];

    // Determine effective gaps
    bool hide_gaps = o->smart_gaps && view_count <= 1;
    uint32_t outer = hide_gaps ? 0 : o->outer_padding;
    uint32_t inner = hide_gaps ? 0 : o->view_padding;



    /* Monocle: every view full‑screen with no borders */
    if (mono) {
        if (o->smart_borders) {
          if (o->last_sent_border_width != 0) {
            char cmd[64];
            snprintf(cmd, sizeof(cmd), "riverctl border-width 0");
            system(cmd);
            o->last_sent_border_width = 0;
          }
        }
        for (uint32_t i = 0; i < view_count; i++) {
            river_layout_v3_push_view_dimensions(o->layout, 0, 0, width, height, serial);
        }
        char label[16];
        snprintf(label, sizeof(label), "[%u]", view_count);
        river_layout_v3_commit(o->layout, label, serial);
        return;
    }

    if (o->smart_borders) {
        bool hide_border = mono || view_count <= 1;
        char cmd[64];
        uint32_t bw = hide_border ? 0 : o->border_width;
        if (bw != o->last_sent_border_width) {
          if (hide_border)
              snprintf(cmd, sizeof(cmd), "riverctl border-width 0");
          else
              snprintf(cmd, sizeof(cmd), "riverctl border-width %u", bw);
        system(cmd);
        o->last_sent_border_width = bw;
        }
    }
    width  -= 2 * outer;
    height -= 2 * outer;

    unsigned int main_size, stack_size;
    if (mcount == 0) {
        main_size  = 0;
        stack_size = width;
    } else if (view_count <= mcount) {
        main_size  = width;
        stack_size = 0;
    } else {
        main_size  = width * mratio;
        stack_size = width - main_size;
    }

    for (uint32_t i = 0; i < view_count; i++) {
        uint32_t x, y, w, h;
        if (i < mcount) {
            x = 0;
            w = main_size;
            h = height / MIN(mcount, view_count);
            y = i * h;
        } else {
            x = main_size;
            w = stack_size;
            h = height / (view_count - mcount);
            y = (i - mcount) * h;
        }

        // apply border and gaps
        river_layout_v3_push_view_dimensions(o->layout,
            x + outer + inner,
            y + outer + inner,
            w - 2*(inner),
            h - 2*(inner),
            serial);
    }

    river_layout_v3_commit(o->layout, "[]=", serial);
}

static void layout_handle_namespace_in_use(void *data,
        struct river_layout_v3 *layout)
{
    fputs("Namespace already in use.\n", stderr);
    loop = false;
}

static bool skip_whitespace (char **ptr)
{
	if ( *ptr == NULL )
		return false;
	while (isspace(**ptr))
	{
		(*ptr)++;
		if ( **ptr == '\0' )
			return false;
	}
	return true;
}

static bool skip_nonwhitespace (char **ptr)
{
	if ( *ptr == NULL )
		return false;
	while (! isspace(**ptr))
	{
		(*ptr)++;
		if ( **ptr == '\0' )
			return false;
	}
	return true;
}

static const char *get_second_word (char **ptr, const char *name)
{
	if ( !skip_nonwhitespace(ptr) || !skip_whitespace(ptr) )
	{
		fprintf(stderr, "ERROR: Too few arguments. '%s' needs one argument.\n", name);
		return NULL;
	}

	const char *second_word = *ptr;

	if ( skip_nonwhitespace(ptr) && skip_whitespace(ptr) )
	{
		fprintf(stderr, "ERROR: Too many arguments. '%s' needs one argument.\n", name);
		return NULL;
	}

	return second_word;
}

static void handle_uint32_command (char **ptr, uint32_t *value, const char *name)
{
	const char *second_word = get_second_word(ptr, name);
	if ( second_word == NULL )
		return;
	const int32_t arg = atoi(second_word);
	if ( *second_word == '+' || *second_word == '-' )
		*value = (uint32_t)MAX((int32_t)*value + arg, 0);
	else
		*value = (uint32_t)MAX(arg, 0);
}

static void handle_float_command(char **ptr, double *value, const char *name, double clamp_upper, double clamp_lower)
{
	const char *second_word = get_second_word(ptr, name);
	if ( second_word == NULL )
		return;
	const double arg = atof(second_word);
	if ( *second_word == '+' || *second_word == '-' )
		*value = CLAMP(*value + arg, clamp_upper, clamp_lower);
	else
		*value = CLAMP(arg, clamp_upper, clamp_lower);
}

static void layout_handle_user_command(void *data,
        struct river_layout_v3 *layout,
        const char *_command)
{
    struct Output *o = data;
    unsigned int ti = (o->last_tags ? __builtin_ffs(o->last_tags)-1 : 0);
    char *cmd = (char *)_command;
    if (!cmd || (!isspace(*cmd) && *cmd == '\0')) return;

    if (strncmp(cmd, "main_count", 10) == 0) {
        char *p = cmd;
        handle_uint32_command(&p, &o->main_count[ti], "main_count");
    } else if (strncmp(cmd, "view_padding", 12) == 0) {
        char *p = cmd;
        handle_uint32_command(&p, &o->view_padding, "view_padding");
    } else if (strncmp(cmd, "outer_padding", 13) == 0) {
        char *p = cmd;
        handle_uint32_command(&p, &o->outer_padding, "outer_padding");
    } else if (strncmp(cmd, "main_ratio", 10) == 0) {
        char *p = cmd;
        handle_float_command(&p, &o->main_ratio[ti], "main_ratio", 0.1, 0.9);
    } else if (strncmp(cmd, "smart_gaps", 10) == 0) {
        char *p = cmd;
        const char *arg = get_second_word(&p, "smart_gaps");
        if (!arg) return;
        o->smart_gaps = (strcmp(arg, "on") == 0);
    } else if (strncmp(cmd, "border_width", 12) == 0) {
        char *p = cmd;
        handle_uint32_command(&p, &o->border_width, "border_width");
    } else if (strncmp(cmd, "smart_borders", 13) == 0) {
        char *p = cmd;
        const char *arg = get_second_word(&p, "smart_borders");
        if (!arg) return;
        o->smart_borders = (strcmp(arg, "on") == 0);
    } else if (strncmp(cmd, "reset", 5) == 0) {
        for (int i = 0; i < MAX_TAGS; i++) {
          o->main_count[i] = 1;
          o->main_ratio[i] = 0.55;
        }
        o->view_padding  = 4;
        o->outer_padding = 4;
        o->smart_gaps    = true;
        o->border_width  = 2;
        o->smart_borders = true;
    } else {
        if (strncmp(cmd, "layout", 6) == 0) {
        char *p = cmd;
        const char *arg = get_second_word(&p, "layout");
        if (!arg) return;

        if (strcmp(arg, "monocle") == 0) {
            o->monocle[ti] = true;
        }
        else if (strcmp(arg, "tile") == 0) {
            o->monocle[ti] = false;
        }
        else if (strcmp(arg, "toggle") == 0) {
            o->monocle[ti] = !o->monocle[ti];
        }
        else {
            fprintf(stderr, "Unknown layout mode '%s'\n", arg);
            return;
        }
        return;
    }
        fprintf(stderr, "Unknown command '%s'\n", cmd);
    }
}

static const struct river_layout_v3_listener layout_listener = {
    .namespace_in_use = layout_handle_namespace_in_use,
    .layout_demand    = layout_handle_layout_demand,
    .user_command     = layout_handle_user_command,
};

static void configure_output(struct Output *o) {
    o->configured = true;
    o->layout = river_layout_manager_v3_get_layout(layout_manager,
            o->output, "tile");
    river_layout_v3_add_listener(o->layout, &layout_listener, o);
}

static bool create_output(struct wl_output *wl_output) {
    struct Output *o = calloc(1, sizeof(*o));
    if (!o) { fputs("Allocation failed.\n", stderr); return false; }
    o->output        = wl_output;
    o->configured    = false;

    // defaults
    for (int i = 0; i < MAX_TAGS; i++) {
      o->main_count[i] = 1;
      o->main_ratio[i] = 0.55;
      o->monocle[i]    = false;
    }

    o->view_padding  = 4;
    o->outer_padding = 4;
    o->smart_gaps    = true;
    o->border_width  = 2;
    o->smart_borders = true;

    if (layout_manager)
        configure_output(o);
    wl_list_insert(&outputs, &o->link);
    return true;
}

static void destroy_output (struct Output *output)
{
	if ( output->layout != NULL )
		river_layout_v3_destroy(output->layout);
	wl_output_destroy(output->output);
	wl_list_remove(&output->link);
	free(output);
}

static void destroy_all_outputs ()
{
	struct Output *output, *tmp;
	wl_list_for_each_safe(output, tmp, &outputs, link)
		destroy_output(output);
}

static void registry_handle_global (void *data, struct wl_registry *registry,
		uint32_t name, const char *interface, uint32_t version)
{
	if ( strcmp(interface, river_layout_manager_v3_interface.name) == 0 )
		layout_manager = wl_registry_bind(registry, name,
				&river_layout_manager_v3_interface, 1);
	else if ( strcmp(interface, wl_output_interface.name) == 0 )
	{
		struct wl_output *wl_output = wl_registry_bind(registry, name,
				&wl_output_interface, version);
		if (! create_output(wl_output))
		{
			loop = false;
			ret = EXIT_FAILURE;
		}
	}
}

/* A no-op function we plug into listeners when we don't want to handle an event. */

static void noop(void *data, struct wl_registry *registry, uint32_t name) {
    (void)data;    // Suppress unused parameter warnings
    (void)registry;
    (void)name;
}


static const struct wl_registry_listener registry_listener = {
	.global        = registry_handle_global,
	.global_remove = noop
};

static void sync_handle_done (void *data, struct wl_callback *wl_callback,
		uint32_t irrelevant)
{
	wl_callback_destroy(wl_callback);
	sync_callback = NULL;

	/* When this function is called, the registry finished advertising all
	 * available globals. Let's check if we have everything we need.
	 */
	if ( layout_manager == NULL )
	{
		fputs("Wayland compositor does not support river-layout-v3.\n", stderr);
		ret = EXIT_FAILURE;
		loop = false;
		return;
	}

	/* If outputs were registered before the river_layout_manager is
	 * available, they won't have a river_layout, so we need to create those
	 * here.
	 */
	struct Output *output;
	wl_list_for_each(output, &outputs, link)
		if (! output->configured)
			configure_output(output);
}

static const struct wl_callback_listener sync_callback_listener = {
	.done = sync_handle_done,
};

static bool init_wayland (void)
{
	/* We query the display name here instead of letting wl_display_connect()
	 * figure it out itself, because libwayland (for legacy reasons) falls
	 * back to using "wayland-0" when $WAYLAND_DISPLAY is not set, which is
	 * generally not desirable.
	 */
	const char *display_name = getenv("WAYLAND_DISPLAY");
	if ( display_name == NULL )
	{
		fputs("WAYLAND_DISPLAY is not set.\n", stderr);
		return false;
	}

	wl_display = wl_display_connect(display_name);
	if ( wl_display == NULL )
	{
		fputs("Can not connect to Wayland server.\n", stderr);
		return false;
	}

	wl_list_init(&outputs);

	/* The registry is a global object which is used to advertise all
	 * available global objects.
	 */
	wl_registry = wl_display_get_registry(wl_display);
	wl_registry_add_listener(wl_registry, &registry_listener, NULL);

	/* The sync callback we attach here will be called when all previous
	 * requests have been handled by the server. This allows us to know the
	 * end of the startup, at which point all necessary globals should be
	 * bound.
	 */
	sync_callback = wl_display_sync(wl_display);
	wl_callback_add_listener(sync_callback, &sync_callback_listener, NULL);

	return true;
}

static void finish_wayland (void)
{
	if ( wl_display == NULL )
		return;

	destroy_all_outputs();

	if ( sync_callback != NULL )
		wl_callback_destroy(sync_callback);
	if ( layout_manager != NULL )
		river_layout_manager_v3_destroy(layout_manager);

	wl_registry_destroy(wl_registry);
	wl_display_disconnect(wl_display);
}

int main (int argc, char *argv[])
{
	if (init_wayland())
	{
		ret = EXIT_SUCCESS;
		while ( loop && wl_display_dispatch(wl_display) != -1 );
	}
	finish_wayland();
	return ret;
}

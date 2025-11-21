/*
 * bufpool - https://codeberg.org/sewn/drwl
 *
 * Copyright (c) 2023-2024 sewn <sewn@disroot.org>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <wayland-client.h>
#ifdef __linux__
#include <linux/memfd.h>
#endif

#include "drwl.h"

typedef struct {
	struct wl_buffer *wl_buf;
	int32_t size;
	int busy;
	void *mmapped;
	Img *image;
} DrwBuf;

typedef struct {
	DrwBuf bufs[2];
} BufPool;

static void
drwbuf_cleanup(DrwBuf *buf)
{
	if (buf->wl_buf)
		wl_buffer_destroy(buf->wl_buf);
	if (buf->mmapped)
		munmap(buf->mmapped, buf->size);
	if (buf->image)
		drwl_image_destroy(buf->image);
	*buf = (DrwBuf){0};
}

static void
drwbuf_handle_release(void *data, struct wl_buffer *wl_buffer)
{
	DrwBuf *buf = data;
	buf->busy = 0;
}

static struct wl_buffer_listener drwbuf_buffer_listener = {
	.release = drwbuf_handle_release,
};

static DrwBuf *
bufpool_getbuf(BufPool *pool, struct wl_shm *shm,
		int32_t width, int32_t height)
{
	int i;
	int fd;
	void *mmapped;
	struct wl_shm_pool *shm_pool;
	struct wl_buffer *wl_buf;
	int32_t size = width * 4 * height;
	Img *image;
	DrwBuf *buf = NULL;

	for (i = 0; i < 2; i++) {
		if (pool->bufs[i].busy)
			continue;
		if (pool->bufs[i].wl_buf && pool->bufs[i].size != size)
			drwbuf_cleanup(&pool->bufs[i]);
		buf = &pool->bufs[i];
	}
	if (!buf)
		return NULL;
	if (buf->wl_buf && buf->size == size)
		return buf;

#if defined(__linux__) || \
	((defined(__FreeBSD__) && (__FreeBSD_version >= 1300048)))
	fd = memfd_create("drwbuf-shm-buffer-pool",
		MFD_CLOEXEC | MFD_ALLOW_SEALING |
#if defined(MFD_NOEXEC_SEAL)
		MFD_NOEXEC_SEAL
#else
		0
#endif
	);
#else
	char template[] = "/tmp/drwbuf-XXXXXX";
#if defined(__OpenBSD__)
	fd = shm_mkstemp(template);
#else
	fd = mkostemp(template, O_CLOEXEC);
#endif
	if (fd < 0)
		return NULL;
#if defined(__OpenBSD__)
    shm_unlink(template);
#else
	unlink(template);
#endif
#endif

	if ((ftruncate(fd, size)) < 0) {
		close(fd);
		return NULL;
	}

	mmapped = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (mmapped == MAP_FAILED) {
		close(fd);
		return NULL;
	}

#if defined(__linux__) || \
	((defined(__FreeBSD__) && (__FreeBSD_version >= 1300048)))
	fcntl(fd, F_ADD_SEALS, F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL);
#endif

	shm_pool = wl_shm_create_pool(shm, fd, size);
	wl_buf = wl_shm_pool_create_buffer(shm_pool, 0,
		width, height, width * 4, WL_SHM_FORMAT_ARGB8888);
	wl_shm_pool_destroy(shm_pool);
	close(fd);

	buf->wl_buf = wl_buf;
	buf->size = size;
	buf->mmapped = mmapped;
	buf->busy = 1;
	if (!(image = drwl_image_create(NULL, width, height, buf->mmapped)))
		drwbuf_cleanup(buf);
	buf->image = image;
	wl_buffer_add_listener(wl_buf, &drwbuf_buffer_listener, buf);
	return buf;
}

static void
bufpool_cleanup(BufPool *pool)
{
	int i;
	for (i = 0; i < 2; i++)
		drwbuf_cleanup(&pool->bufs[i]);
}

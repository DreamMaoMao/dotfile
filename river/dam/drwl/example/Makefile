.POSIX:

PKG_CONFIG = pkg-config

PKGS = wayland-client wayland-cursor fcft pixman-1
INCS = `$(PKG_CONFIG) --cflags $(PKGS)`
LIBS = `$(PKG_CONFIG) --libs $(PKGS)`

WAYLAND_PROTOCOLS = `$(PKG_CONFIG) --variable=pkgdatadir wayland-protocols`
WAYLAND_SCANNER   = `$(PKG_CONFIG) --variable=wayland_scanner wayland-scanner`

ECPPFLAGS = -D_GNU_SOURCE $(CPPFLAGS)
ECFLAGS   = -pedantic -Wall -Wno-unused-function -I../ $(INCS) $(CFLAGS) $(ECPPFLAGS)
LDLIBS    = $(LIBS)

all: example

example.o: xdg-shell-client-protocol.h
example: example.o xdg-shell-protocol.o
	$(CC) $(LDFLAGS) -o $@ example.o xdg-shell-protocol.o $(LDLIBS)

xdg-shell-protocol.c:
	$(WAYLAND_SCANNER) private-code $(WAYLAND_PROTOCOLS)/stable/xdg-shell/xdg-shell.xml $@
xdg-shell-client-protocol.h:
	$(WAYLAND_SCANNER) client-header $(WAYLAND_PROTOCOLS)/stable/xdg-shell/xdg-shell.xml $@

clean:
	rm -f example *.o *-protocol.*

.c.o:
	$(CC) -o $@ -c $(ECFLAGS) $<

.PHONY: clean

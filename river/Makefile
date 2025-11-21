# Use CC, CFLAGS, LDFLAGS etc. if set in environment
CC      ?= gcc
CFLAGS  ?= -Wall -Wextra -O2
LDFLAGS ?=
LDLIBS  ?= -lwayland-client

# Where to install
PREFIX ?= $(HOME)/.local
BINDIR := $(PREFIX)/bin

# Phony targets
.PHONY: all install clean

# Default: build the layout binary
all: layout

# Link layout from object files
layout: layout.o river-layout-v3.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

# Install into $(BINDIR)
install: layout
	@echo "Installing to $(BINDIR)"
	mkdir -p "$(BINDIR)"
	cp layout "$(BINDIR)/"

# Remove build artifacts
clean:
	rm -f layout *.o

# Allow overriding PREFIX on command‑line:
#   make PREFIX=/usr/local install


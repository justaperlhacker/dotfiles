# trayxeyes - xeyes as an i3bar system-tray icon
#
# Targets:
#   make          build the binary in-tree
#   make install  copy the binary into the i3 scripts dir
#   make uninstall
#   make clean

BIN          := trayxeyes
SRC          := $(BIN).c

# where the binary gets installed
INSTALL_DIR  ?= $(HOME)/.config/i3/scripts

CC       ?= cc
CFLAGS   ?= -O2 -Wall -Wextra -std=c11
LDLIBS   := -lX11 -lm

all: $(BIN)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)

install: $(BIN)
	install -Dm755 $(BIN) $(INSTALL_DIR)/$(BIN)

uninstall:
	rm -f $(INSTALL_DIR)/$(BIN)

clean:
	rm -f $(BIN)

.PHONY: all install uninstall clean
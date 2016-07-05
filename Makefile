LUA ?= lua5.1
LUA_VERSIONNUMBER ?= 5.1
LUA_LIBDIR ?= $(shell pkg-config $(LUA) --libs)
LUA_INCDIR ?= $(shell pkg-config $(LUA) --cflags)

UUID_LIBDIR ?= $(shell pkg-config uuid --libs)
UUID_INCDIR ?= $(shell pkg-config uuid --cflags)

INSTALL_PATH = $(shell pkg-config $(LUA) --variable=libdir)/lua/$(LUA_VERSION_NUMBER)

LIBFLAG ?= -shared
CFLAGS ?= -O2 -Wall -Werror

.PHONY: all clean install

all: lua_uuid.so

lua_uuid.so: lua_uuid.o
	$(CC) $(LIBFLAG) $(LUA_LIBDIR) -o $@ $< $(UUID_LIBDIR)
	$(LUA) test/lua_uuid_test.lua

%.o: %.c
	$(CC) -c $(CFLAGS) -fPIC $(LUA_INCDIR) $(UUID_INCDIR) $< -o $@

install: lua_uuid.so
	mkdir -p $(INSTALL_PATH)
	install -D -s lua_uuid.so $(INSTALL_PATH)/lua_uuid.so

clean:
	rm -f *.so *.o *.rock

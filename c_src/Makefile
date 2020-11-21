ERLANG_PATH ?= $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version)])])' -s init stop -noshell)
CC           = gcc
CFLAGS       = -Wall -Werror -O3 -fpic \
               -Wl,-undefined,dynamic_lookup -shared \
               -I$(ERLANG_PATH)/include -L$(ERLANG_PATH)/lib
LIBS         = -lopus
OBJDIR       = ../obj
OUTDIR       = ../priv

all: $(OUTDIR)/opus-nif.so

clean:
	$(RM) $(OUTDIR)/opus-nif.so

rebuild: clean all

$(OUTDIR)/opus-nif.so: opus-nif.c

%.so:
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

.PHONY: all clean rebuild
